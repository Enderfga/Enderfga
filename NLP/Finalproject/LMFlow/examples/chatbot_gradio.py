#!/usr/bin/env python
# coding=utf-8
# Copyright 2023 Statistics and Machine Learning Research Group at HKUST. All rights reserved.
"""A simple shell chatbot implemented with lmflow APIs.
"""
import logging
import json
import os
import sys
sys.path.remove(os.path.abspath(os.path.dirname(sys.argv[0])))
import torch
import warnings
import gradio as gr
from dataclasses import dataclass, field
from transformers import HfArgumentParser
from typing import Optional

from lmflow.datasets.dataset import Dataset
from lmflow.pipeline.auto_pipeline import AutoPipeline
from lmflow.models.auto_model import AutoModel
from lmflow.args import ModelArguments, DatasetArguments, AutoArguments

MAX_BOXES = 20

logging.disable(logging.ERROR)
warnings.filterwarnings("ignore")

title = """
<h1 align="center">Enderfga-KBQA-CHAT</h1>
<link rel="stylesheet" href="/path/to/styles/default.min.css">
<script src="/path/to/highlight.min.js"></script>
<script>hljs.highlightAll();</script>

<div style="display: flex; align-items: center;">
  <img src="https://img.enderfga.cn/img/9s_%E6%97%A0%E8%83%8C%E6%99%AF.png" alt="LMFlow" style="height: 30px;">
  <div style="margin-left: 10px;">
    <p style="margin: 0;">自然语言处理期末项目——自动问答bot</p>
    <p style="margin: 0;">小组成员：方桂安20354027；刘梦莎20354091；梁静蕾20354072。</p>
  </div>
</div>
"""
css = """
#user {                                                                         
    float: right;
    position:relative;
    right:5px;
    width:auto;
    min-height:32px;
    max-width: 60%
    line-height: 32px;
    padding: 2px 8px;
    font-size: 14px;
    background:	#9DC284;
    border-radius:5px; 
    margin:10px 0px;
}
                                             
#chatbot {                                                                      
    float: left;
    position:relative;
    right:5px;
    width:auto;
    min-height:32px;
    max-width: 60%
    line-height: 32px;
    padding: 2px 8px;
    font-size: 14px;
    background:#7BA7D7;
    border-radius:5px; 
    margin:10px 0px;
}
"""


@dataclass
class ChatbotArguments:
    prompt_structure: Optional[str] = field(
        default="{input_text}",
        metadata={
            "help": "prompt structure given user's input text"
        },
    )
    end_string: Optional[str] = field(
        default="\n\n",
        metadata={
            "help": "end string mark of the chatbot's output"
        },
    )
    max_new_tokens: Optional[int] = field(
        default=200,
        metadata={
            "help": "maximum number of generated tokens"
        },
    )
    temperature: Optional[float] = field(
        default=0,
        metadata={
            "help": "higher this value, more random the model output"
        },
    )


pipeline_name = "inferencer"
PipelineArguments = AutoArguments.get_pipeline_args_class(pipeline_name)

parser = HfArgumentParser((
    ModelArguments,
    PipelineArguments,
    ChatbotArguments,
))
model_args, pipeline_args, chatbot_args = (
    parser.parse_args_into_dataclasses()
)

with open (pipeline_args.deepspeed, "r") as f:
    ds_config = json.load(f)

model = AutoModel.get_model(
    model_args,
    tune_strategy='none',
    ds_config=ds_config,
    device=pipeline_args.device,
    torch_dtype=torch.float16
)

# We don't need input data, we will read interactively from stdin
data_args = DatasetArguments(dataset_path=None)
dataset = Dataset(data_args)

inferencer = AutoPipeline.get_pipeline(
    pipeline_name=pipeline_name,
    model_args=model_args,
    data_args=data_args,
    pipeline_args=pipeline_args,
)

# Chats
model_name = model_args.model_name_or_path
if model_args.lora_model_path is not None:
    model_name += f" + {model_args.lora_model_path}"


context = (
    "你是一个由沈颖老师开设的自然语言处理课程的期末项目，项目内容是自动问答系统，基于nlpcc-iccpol-2016.kbqa训练的llama-7B语言模型"
)


end_string = chatbot_args.end_string
prompt_structure = chatbot_args.prompt_structure


token_per_step = 4

def hist2context(hist):
    context = ""
    for query, response in hist:
        context += prompt_structure.format(input_text=query)
        if not (response is None):
            context += response
    return context

def chat_stream(query: str, history= None, **kwargs):
    if history is None:
        history = []

    context = hist2context(history)
    print_index = 0
    context += prompt_structure.format(input_text=query)
    context_ = context[-model.get_max_length():] 
    input_dataset = dataset.from_dict({
        "type": "text_only",
        "instances": [ { "text": context_ } ]
    })
    print(context_)
    for response, flag_break in inferencer.stream_inference(context=context_, model=model, max_new_tokens=chatbot_args.max_new_tokens, 
                                    token_per_step=token_per_step, temperature=chatbot_args.temperature,
                                    end_string=end_string, input_dataset=input_dataset):
        delta = response[print_index:]
        seq = response
        print_index = len(response)
        
        yield delta, history + [(query, seq)]
        if flag_break:
            break




def predict(input, history=None): 
    if history is None:
        history = []
    for response, history in chat_stream(input, history):
        updates = []
        for query, response in history:
            updates.append(gr.update(visible=True, value="" + query))
            updates.append(gr.update(visible=True, value="" + response))
        if len(updates) < MAX_BOXES:
            updates = updates + [gr.Textbox.update(visible=False)] * (MAX_BOXES - len(updates))
        yield [history] + updates





with gr.Blocks(css=css) as demo:
    gr.HTML(title)
    state = gr.State([])
    text_boxes = []
    for i in range(MAX_BOXES):
        if i % 2 == 0:
            text_boxes.append(gr.Markdown(visible=False, label="Q:", elem_id="user"))
        else:
            text_boxes.append(gr.Markdown(visible=False, label="A:", elem_id="chatbot"))

    txt = gr.Textbox(
        show_label=False,
        placeholder="输入文本并点击发送",
    )
    button = gr.Button("发送")

    button.click(predict, [txt, state], [state] + text_boxes)
    demo.queue().launch(share=True)



