     % Used for HKUST ELEC 5660

close all
clear all

clc;
addpath('./utils', './readonly','/SI_DFM_2D_SYSU');

h1 = subplot(6, 12, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]);
%第一架飞机数据分析图
h2 = subplot(6, 12, 25);
h3 = subplot(6, 12, 26);
h4 = subplot(6, 12, 27);
h5 = subplot(6, 12, 28);

h6 = subplot(6, 12, 37);
h7 = subplot(6, 12, 38);
h8 = subplot(6, 12, 39);
h9 = subplot(6, 12, 40);

%第二架飞机数据飞行图
h10 = subplot(6, 12, 29);
h11 = subplot(6, 12, 30);
h12 = subplot(6, 12, 31);
h13 = subplot(6, 12, 32);

h14 = subplot(6, 12, 41);
h15 = subplot(6, 12, 42);
h16 = subplot(6, 12, 43);
h17 = subplot(6, 12, 44);

%第三架飞机数据飞行图
h18 = subplot(6, 12, 33);
h19 = subplot(6, 12, 34);
h20 = subplot(6, 12, 35);
h21 = subplot(6, 12, 36);

h22 = subplot(6, 12, 45);
h23 = subplot(6, 12, 46);
h24 = subplot(6, 12, 47);
h25 = subplot(6, 12, 48);

%第四架飞机数据飞行图
h26 = subplot(6, 12, 49);
h27 = subplot(6, 12, 50);
h28 = subplot(6, 12, 51);
h29 = subplot(6, 12, 52);

h30 = subplot(6, 12, 61);
h31 = subplot(6, 12, 62);
h32 = subplot(6, 12, 63);
h33 = subplot(6, 12, 64);

%第五架飞机数据飞行图
h34 = subplot(6, 12, 53);
h35 = subplot(6, 12, 54);
h36 = subplot(6, 12, 55);
h37 = subplot(6, 12, 56);

h38 = subplot(6, 12, 65);
h39 = subplot(6, 12, 66);
h40 = subplot(6, 12, 67);
h41 = subplot(6, 12, 68);

%第六架飞机数据飞行图
h42 = subplot(6, 12, 57);
h43 = subplot(6, 12, 58);
h44 = subplot(6, 12, 59);
h45 = subplot(6, 12, 60);

h46 = subplot(6, 12, 69);
h47 = subplot(6, 12, 70);
h48 = subplot(6, 12, 71);
h49 = subplot(6, 12, 72);

set(gcf, 'Renderer', 'painters');
set(gcf, 'Position', [100, 100, 1400, 1000]);


run6formation(h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14, ...
    h15, h16, h17, h18, h19, h20, h21, h22, h23, h24, h25, h26, h27, h28, h29, ...
    h30, h31, h32, h33, h34, h35, h36, h37, h38, h39, h40, h41, h42, h43, h44, ...
    h45, h46, h47, h48, h49,1);

JudgeStudentsPoint
