clear
clc
% T = 'H:\DataRaw\Toolbox\spm8\templates\T1.nii';% 91x109x91 NOTE THIS template can not be used here.
% T = 'H:\DataRaw\Toolbox\gretna_1.0_beta\Templates\AAL1024.nii'; % 181x217x181
T = 'H:\DataRaw\Toolbox\gretna_1.0_beta\Templates\AAL_1024_3mm.nii';% 61x73x61 Better
% T = 'H:\DataRaw\Toolbox\gretna_1.0_beta\Templates\AAL_90_3mm.nii';% 61x73x61
% T ='\media\DATA\DataAnalysis\Runing\Repeat\fMRI\DataAnalysis\sub001\run003\swraf20120806_04_LuoYJ_XPF_LiuShuang-0005-00239-000239-01.img';
% T = 'H:\DataRaw\Toolbox\gretna_1.0_beta\Templates\ROI264_61x73x61.nii';
C = load('H:\DataRaw\Toolbox\px_toolbox\Template\Old\MNI_Coordinates_264.txt');
R = 5;
op = 'H:\DataRaw\Toolbox\gretna_1.0_beta\Templates\ROI264_61x73x61.nii';
px_ball2mask(T,C,R,op);