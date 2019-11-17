clc;clear
addpath(genpath('C:\Toolbox_new\spm12'));
addpath(genpath('C:\Toolbox_new\spm_fnirs'));
addpath(genpath('C:\Toolbox_new\NIRS_SPM_v4_r1'));
fList = dir('10*');
DPF = [7.15 5.98];
ext_coef = [1.4866 3.8437 2.2314 1.7917];
flag_window = 1;
StartReservedTime=3*7.8125;
EndReservedTime=3*7.8125;
StartForwardReservedTime = 240*7.8125;
StartBackReservedTime = 0*7.8125;
EndForwardReservedTime = 240*7.8125;
EndBackReservedTime = 0*7.8125;
NSubj = length(fList);
hb = 'hbo';
HPF = 'wavelet';
LPF = 'hrf';
Path = [cd,'\']; 
NbackAll = {};
RestTimeEnd = {};
RestTimeStart = {};
for i = 1:NSubj
    [NbackAll{i},RestTimeEnd{i},RestTimeStart{i},betaList(:,:,i)] = A_B(i,fList,hb,DPF,HPF,ext_coef,LPF,flag_window,StartReservedTime,EndReservedTime,StartForwardReservedTime,StartBackReservedTime,EndForwardReservedTime,EndBackReservedTime);
end
p_value = [];
for i = 1:size(betaList,2)
    %         [H,P,CI,stats] = ttest(squeeze(betaList(1,i,:)),squeeze(betaList(3,i,:)));
    [P,table,stats]=anova2(squeeze(betaList(1:3,i,:))');
    p_value = [p_value;P];
%     t_value = [t_value;stats.tstat];
end
save([cd,'\BlockResult.mat'],'NbackAll','RestTimeEnd','RestTimeStart','betaList','p_value');