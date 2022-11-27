% !Mode:: "TeX:UTF-8"
%%
%% 2019年第九届APMCM亚太地区大学生数学建模竞赛论文LaTeX模版的类文件
%%
%% apmcmthesis.cls
%% V1.0
%% 2019/11/06
%% by LaTeXStudio.net
%% see http://www.latexstudio.net/
%% for current contact information.

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{apmcmthesis}[2019/11/11 v1.0 LaTeX Template for APMCM]
%% Inital Code
\newif\if@tzmcm@bwprint\@tzmcm@bwprintfalse
\newif\if@tzmcm@preface\@tzmcm@prefacetrue
% tokens definition
%%%% 承诺书
\newcommand\tzmcm@tokens@keywords{}
\newcommand*\tzmcm@tokens@tihao{}
\newcommand*\tzmcm@tokens@baominghao{}
\newcommand*\tzmcm@tokens@schoolname{}
\newcommand*\tzmcm@tokens@membera{}
\newcommand*\tzmcm@tokens@memberb{}
\newcommand*\tzmcm@tokens@memberc{}
\newcommand*\tzmcm@tokens@supervisor{}
\newcommand*\tzmcm@tokens@yearinput{}
\newcommand*\tzmcm@tokens@monthinput{}
\newcommand*\tzmcm@tokens@dayinput{}
\newcommand*\tzmcm@tokens@date{}
%%%% 编号专用页
% 没有
%% Declaration of Options
\DeclareOption{colorprint}{\@tzmcm@bwprintfalse}
\DeclareOption{withoutpreface}{\@tzmcm@prefacefalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
%% Executing of Options
\ExecuteOptions{colorprint}
\ProcessOptions\relax
%% Loading Class
\LoadClass[a4paper,12pt]{article}

% 支持中文的 ctex 宏包

%% Loading Package
\RequirePackage{ifxetex}

% 页面布局
\RequirePackage{geometry}
%% Document Layout
% 页面布局
\geometry{top=25.4mm,bottom=25.4mm,left=31.8mm,right=31.8mm}
\renewcommand*{\baselinestretch}{1.38}
% 数学宏包
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}
\RequirePackage{bm}
\RequirePackage{titlesec}
\RequirePackage{titletoc}
% 设置颜色
\RequirePackage[x11names,svgnames,dvipsnames]{xcolor}
% 插入图片
\RequirePackage{graphicx}
% 表格
\RequirePackage{array,lastpage}
%% 长表格
\RequirePackage{longtable,tabularx}
%% booktabs 提供了\toprule 等命令.
\RequirePackage{booktabs}
%% multirow 支持在表格中跨行
\RequirePackage{multirow}
%% 调整间隔, 让表格更好看些
\RequirePackage{bigstrut}

% 保护脆落命令
\RequirePackage{cprotect}
% 设置代码环境
\RequirePackage{listings}

\ifxetex
\RequirePackage{ctex}
\setmainfont{Times New Roman}
\else
\RequirePackage{CJK}
\usepackage{newtxtext}
\usepackage{newtxmath}
\fi

\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}

\lstset{
  frame=tb,
  aboveskip=3mm,
  belowskip=3mm,
  showstringspaces=false,
  columns=flexible,
  framerule=1pt,
  rulecolor=\color{gray!35},
  backgroundcolor=\color{gray!5},
  basicstyle={\small\ttfamily},
  numbers=none,
  numberstyle=\tiny\color{gray},
  keywordstyle=\color{blue},
  commentstyle=\color{dkgreen},
  stringstyle=\color{mauve},
  breaklines=true,
  breakatwhitespace=true,
  tabsize=3,
}

% 设置浮动体的标题
\RequirePackage{caption}
% 定制列表环境
\RequirePackage{enumitem}
% 下划线
\RequirePackage{ulem}
% 尺寸计算
\RequirePackage{calc}

\RequirePackage[titletoc,title]{appendix}


% 修改tabular 环境, 设置表格中的行间距为正文行间距.
\let\tzmcm@oldtabular\tabular
\let\tzmcm@endoldtabular\endtabular
\renewenvironment{tabular}%
	{\bgroup%
	\renewcommand{\arraystretch}{1.3}%
	\tzmcm@oldtabular}%
	{\tzmcm@endoldtabular\egroup}
% 每行缩进两个汉字
\setlength\parindent{2em}
% 设置字体
\newcommand{\team}{Team \#\ \tzmcm@tokens@baominghao}
\RequirePackage{fancyhdr}
\pagestyle{fancy}

\fancypagestyle{frontmatterstyle}{% style for frontmatter
    \fancyhf{}% clear fields
\fancyhf{}
\lhead{\small \team}
\rhead{}
}
\fancypagestyle{mainmatterstyle}{% style for mainmatter
\fancyhf{}
\lhead{\small \team}
\rhead{\small  Page \thepage\ of \pageref{LastPage}}
}
% 数学环境, 定理等设置
\newtheorem{definition}{\tzmcm@cap@definition}
\newtheorem{theorem}{\tzmcm@cap@theorem}
\newtheorem{lemma}{\tzmcm@cap@lemma}
\newtheorem{corollary}{\tzmcm@cap@corollary}
\newtheorem{assumption}{\tzmcm@cap@assumption}
\newtheorem{conjecture}{\tzmcm@cap@conjecture}
\newtheorem{axiom}{\tzmcm@cap@axiom}
\newtheorem{principle}{\tzmcm@cap@principle}
\newtheorem{problem}{\tzmcm@cap@problem}
%\newtheorem{example}{\tzmcm@cap@example}
\newtheorem{proof}{\tzmcm@cap@proof}
\newtheorem{solution}{\tzmcm@cap@solution}

% 浮动环境设置
% 默认情况下, \LaTeX{} 要求每页的文字至少占据 20%,否则该页就只单独放置一个浮动环境,
% 而这通常不是我们想要的, 我们将这个要求降低到 5%.
 \renewcommand*{\textfraction}{0.05}
% 有时如果多个浮动环境连续放在一起, \LaTeX{}
% 会将它们分在几个不同页，即使它们可在同一页放
% 得下. 我们可以通过修改 |\topfraction| 和 |\bottomfraction| 分别设置顶端和底端的浮
% 动环境的最大比例.
 \renewcommand*{\topfraction}{0.9}
 \renewcommand*{\bottomfraction}{0.8}
% 有时\LaTeX{}会把一个浮动环境单独放在一页,
% 我们要求这个环境至少要占据 85% 才能单独放在一页.
% 注意:  |\floatpagefraction| 的数值必须小于 |\topfraction|.
 \renewcommand*{\floatpagefraction}{0.85}
% 关于图片 graphicx
 % 如果图片没有指定后缀, 依次按下列顺序搜索
\DeclareGraphicsExtensions{.pdf,.eps,.jpg,.png}
 % 设置图表搜索路径, 可以给图表文件夹取如下名字
\graphicspath{{figures/}{figure/}{pictures/}%
  {picture/}{pic/}{pics/}{image/}{images/}}
% 图表标题
\DeclareCaptionFont{minusfour}{\small}
\captionsetup[figure]{%
	format=hang,   % 标题从第二行开始都有缩进, 应该和 justification=raggedright 的效果一样.
	labelsep=space, % 分隔符是一个空格
	font={minusfour,bf}, % 图的字体, 宋体小四
	position=bottom % position=bottom, 不代表标题放在下面, 标题仍放在你放\caption的位置.
}
\captionsetup[table]{%
	format=hang,   % 标题从第二行开始都有缩进, 应该和 justification=raggedright 的效果一样.
	labelsep=quad, % 分隔符是一个空格
	font={minusfour,bf}, % 表的字体, 宋体小四
	position=top % position=bottom, 不代表标题放在下面, 标题仍放在你放\caption的位置.
}
% 列表环境设置
\setlist{%
	topsep=0.3em, % 列表顶端的垂直空白
	partopsep=0pt, % 列表环境前面紧接着一个空白行时其顶端的额外垂直空白
	itemsep=0ex plus 0.1ex, % 列表项之间的额外垂直空白
	parsep=0pt, % 列表项内的段落之间的垂直空白
	leftmargin=2em, % 环境的左边界和列表之间的水平距离
	rightmargin=0em, % 环境的右边界和列表之间的水平距离
	labelsep=0.5em, % 包含标签的盒子与列表项的第一行文本之间的间隔
	labelwidth=2em % 包含标签的盒子的正常宽度；若实际宽度更宽，则使用实际宽度。
}


\lstnewenvironment{tcode}
  {
    \lstset{basicstyle = \small\ttfamily,
        language=TeX,
        tabsize = 4,
        frame = single,
        escapechar = `,
        breaklines = true,
        breakatwhitespace = true,
        frameround = tttt,
    }
  }
  {}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Document Markup

% 生成封面, 使用\maketitle
\newcommand{\makecontrolsheet}{\par
	\begingroup
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \endgroup
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\def\@maketitle{%
  \thispagestyle{empty}%\fontsize{12pt}{\baselineskip}\selectfont%
  \begin{center}%
    {\huge\bfseries \tzmcm@numberpage@string@titlea \par}%
  \end{center}
    {\linespread{1.5}\selectfont \tzmcm@commit@string@contents \par}

     \begin{tabularx}{13.8cm}{@{}l@{}X}
    \tzmcm@commit@string@problemnum &{\hspace{1em}\tzmcm@tokens@tihao\hfill}\\
    \cline{2-2}
    \end{tabularx}

    \medskip%
     \begin{tabularx}{13.8cm}{@{}l@{}X}
    \tzmcm@commit@string@signupnum &{\hspace{1em}\tzmcm@tokens@baominghao\hfill}\\
    \cline{2-2}
    \end{tabularx}

    \medskip%
     \begin{tabularx}{13.8cm}{@{}l@{}X}
    \tzmcm@commit@string@schoolname &{\hspace{1em}\tzmcm@tokens@schoolname\hfill}\\[-2pt]
    \cline{2-2}
    \end{tabularx}

    \medskip%
    % 不这样做右边难以对齐!
     \begin{tabularx}{13.8cm}{@{}l@{}l@{\ }X}
    \tzmcm@commit@string@membername &1. &{\hspace{.5em}\tzmcm@tokens@membera\hfill} \\[-2pt]
    \cline{3-3}
    &2.& {\hspace{.5em}\tzmcm@tokens@memberb\hfill} \\[-2pt]
    \cline{3-3}
    &3.& {\hspace{.5em}\tzmcm@tokens@memberc\hfill} \\[-2pt]
    \cline{3-3}
    \end{tabularx}

    \medskip%
    \begin{tabularx}{13.8cm}{@{}l@{}X}
    \tzmcm@commit@string@supervisorname &{\hspace{.5em}\tzmcm@tokens@supervisor\hfill}\\[-2pt]
    \cline{2-2}
    \end{tabularx}
	
    (Please check the above content carefully, \textbf{fill in English}, and will not be
allowed to make any changes after submission. Such as fill in error, the thesis may be
canceled qualification awards.)

  \null\hfill\begin{tabularx}{5.8cm}{@{}l@{}X}
    Date: &{\hspace{.5em}\tzmcm@tokens@date\hfill}\\[-2pt]
    \cline{2-2}
    \end{tabularx}
	}


% 标题名称设置
\renewcommand\contentsname{\tzmcm@cap@contentsname}
\renewcommand\refname{\tzmcm@cap@refname}
\renewcommand\indexname{\tzmcm@cap@indexname}
\renewcommand\figurename{\tzmcm@cap@figurename}
\renewcommand\tablename{\tzmcm@cap@tablename}
\renewcommand\appendixname{\tzmcm@cap@appendixname}
\renewcommand\abstractname{\tzmcm@cap@abstractname}


% 目录深度
\setcounter{secnumdepth}{3}
\renewcommand\thesubsection{\arabic{section}\thinspace.\thinspace\arabic{subsection}}
\renewcommand\thesubsubsection{\thesubsection\thinspace.\thinspace\arabic{subsubsection}}

\titleformat{\section}
{\centering\normalfont\Large\bfseries}{\Roman{section}.}{.5em}{}
\titleformat{\subsection}
{\normalfont\large\bfseries}{\thesubsection}{.5em}{}
\titleformat{\subsubsection}
{\normalfont\normalsize\bfseries\itshape}{\normalfont\bfseries\textrm{\thesubsubsection}}{.5em}{}
\titleformat{\paragraph}[runin]
{\normalfont\normalsize\bfseries}{\theparagraph}{.5em}{}
\titlespacing*{\section} {0pt}{3.5ex plus 1ex minus .2ex}{2.3ex plus .2ex}
\titlespacing*{\subsection} {0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}
\titlespacing*{\subsubsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}

%设置目录格式
% 节的目录格式
 \titlecontents{section}[0pt]{\bfseries}
 {{\thecontentslabel}.\enspace }{}{\titlerule*[0.5pc]{.}\contentspage}
 % 小节的目录格式
 \titlecontents{subsection}[13pt]{\rmfamily}
 {\thecontentslabel\hskip.5em}{}{\titlerule*[0.5pc]{.}\contentspage}
 \titlecontents{subsubsection}[35pt]{\itshape}
 {{\normalfont\textrm{\thecontentslabel}}\hskip.5em}{}{\titlerule*[0.5pc]{.}\normalfont\textrm{\contentspage}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define new environment and command
%% 摘要两个字设置为 4 号.
%% 定义摘要环境
\def\abstract{%
    \if@twocolumn
      \begin{center}  \the\year\ APMCM summary sheet(non-technical article \end{center}%
    \else
	\newpage
\begin{center}
\begin{tabularx}{8cm}{|l|X|}
\hline%
Team Number:&\tzmcm@tokens@baominghao\\
\hline%
Problem Chosen:& \tzmcm@tokens@tihao\\
\hline%
\end{tabularx}
\end{center}
\noindent\rule{\textwidth}{2pt}
    \begin{center}  \the\year\ APMCM summary sheet \end{center}%
    \fi}
\def\endabstract{\vspace{0.6em}\par\if@twocolumn\endquotation\else\fi
    \normalsize\rm}

\newcommand\keywords[1]{%
	\renewcommand{\tzmcm@tokens@keywords}{#1}
	\par
	\vskip1ex
	{\noindent\bfseries\tzmcm@cap@keywordsname:}~{\tzmcm@tokens@keywords}
	}

\renewenvironment{quotation}
	{\list{}{\listparindent 2em%
	 \itemindent \listparindent
	 \rightmargin\z@
	 \leftmargin\z@
	 \parsep \z@ \@plus\p@}%
	\item\relax}
	{\endlist}



% 重定义参考文献环境
\renewenvironment{thebibliography}[1]
     {\section{\refname}%
      \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}	

\newcommand*\tihao[1]{%
	\renewcommand{\tzmcm@tokens@tihao}{#1}}
\newcommand*\baominghao[1]{%
	\renewcommand{\tzmcm@tokens@baominghao}{#1}}
\newcommand*\schoolname[1]{%
	\renewcommand{\tzmcm@tokens@schoolname}{#1}}
\newcommand*\membera[1]{%
	\renewcommand{\tzmcm@tokens@membera}{#1}}
\newcommand*\memberb[1]{%
	\renewcommand{\tzmcm@tokens@memberb}{#1}}
\newcommand*\memberc[1]{%
	\renewcommand{\tzmcm@tokens@memberc}{#1}}
\newcommand*\supervisor[1]{%
	\renewcommand{\tzmcm@tokens@supervisor}{#1}}
\newcommand*\filldate[1]{%
	\renewcommand{\tzmcm@tokens@date}{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 文档开始导入默认配置
\AtBeginDocument{\makeatletter\input{apmcmthesis.cfg}\makeatother}


\endinput
