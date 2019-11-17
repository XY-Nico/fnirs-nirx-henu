clc;clear;
% addpath(genpath('C:\Toolbox_new\spm12'));
% addpath(genpath('C:\Toolbox_new\spm_fnirs'));
% addpath(genpath('C:\Toolbox_new\NIRS_SPM_v4_r1'));
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
Path = [cd,'\'];
NbackAll = {};
t = 1;
for i = 1:NSubj
    NbackAll{i} = A_E1(i,fList,DPF,ext_coef);
    NbackC0(:,:,t) = NbackAll{1,i}(1).oxyData;
    NbackC1(:,:,t) = NbackAll{1,i}(2).oxyData;
    NbackC2(:,:,t) = NbackAll{1,i}(3).oxyData;
    t =t+1;
end
NbackMeanC(:,:,:,1) = NbackC0;
NbackMeanC(:,:,:,2) = NbackC1;
NbackMeanC(:,:,:,3) = NbackC2;
p_value = zeros(size(NbackMeanC,1),size(NbackMeanC,2));
Anova_Table =  num2cell(zeros(size(NbackMeanC,1),size(NbackMeanC,2)));
Anova_stats =  num2cell(zeros(size(NbackMeanC,1),size(NbackMeanC,2)));
for Cha = 1:size(NbackMeanC,2)
    for Scan = 1:size(NbackMeanC,1)
        [P,Table,stats]=anova2(squeeze(NbackMeanC(Scan,Cha,:,:)));
        p_value(Scan,Cha) = P(1);
        Anova_Table{Scan,Cha} = Table;
        Anova_stats{Scan,Cha} = stats;
        close all
    end
end
Check_P = p_value<=0.05;
t = 1;
for Cha = 1:size(NbackMeanC,2)
    for Scan = 1:size(NbackMeanC,1)
        if Check_P(Scan,Cha) == 1
            Check_table(t,1) = Cha;
            Check_table(t,2) = Scan;
            Check_table(t,3) = Anova_Table{Scan,Cha}{2,5};
            Check_table(t,4) = Anova_Table{Scan,Cha}{2,3};
            Check_table(t,5) = Anova_Table{Scan,Cha}{2,6};
            t = t+1;
        end
    end
end
hold on
plot(mean(NbackMeanC(:,16,:,1),3),'r');
plot(mean(NbackMeanC(:,16,:,2),3),'b');
plot(mean(NbackMeanC(:,16,:,3),3),'y');