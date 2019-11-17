clc;clear
fList = dir('10*');
Path = [cd,'\'];
NSubj = length(fList);
for subj = 1:NSubj
    %?????
    load([Path,fList(subj).name,'\','Data.mat']);
    [N0(1),~,~]= Nirsdata_joint(Nback0_FC(1:2));
    [N0(2),~,~]= Nirsdata_joint(Nback0_FC(3:4));
    C1 = Nirs_superposition_unequal(N0,600);
    C2 = Nirs_superposition_unequal(Nback1_FC,600);
    C3 = Nirs_superposition_unequal(Nback1_FC,600);
    C1_result_corr(subj) = nirs_corr(C1);
    C2_result_corr(subj) = nirs_corr(C2);
    C3_result_corr(subj) = nirs_corr(C2);
    C1_result_coh(subj) = nirs_coh(C1);
    C2_result_coh(subj) = nirs_coh(C2);
    C3_result_coh(subj) = nirs_coh(C2);
    C1_result_PLV(subj) = nirs_PLV(C1);
    C2_result_PLV(subj) = nirs_PLV(C2);
    C3_result_PLV(subj) = nirs_PLV(C2);
end
C1_AVG_cor = Struct_mean_nirsdata(C1_result_corr);
C2_AVG_cor = Struct_mean_nirsdata(C2_result_corr);
C3_AVG_cor = Struct_mean_nirsdata(C2_result_corr);
C1_AVG_coh = Struct_mean_nirsdata(C1_result_coh);
C2_AVG_coh = Struct_mean_nirsdata(C2_result_coh);
C3_AVG_coh = Struct_mean_nirsdata(C2_result_coh);
C1_AVG_PLV = Struct_mean_nirsdata(C1_result_PLV);
C2_AVG_PLV = Struct_mean_nirsdata(C2_result_PLV);
C3_AVG_PLV = Struct_mean_nirsdata(C2_result_PLV);
fig = figure;
subplot(1,3,1); imagesc(1:20, 1:20, C1_AVG_PLV.AVG_oxy); caxis([0.1 0.5]);
subplot(1,3,2); imagesc(1:20, 1:20, C2_AVG_PLV.AVG_oxy); caxis([0.1 0.5]);
subplot(1,3,3); imagesc(1:20, 1:20, C3_AVG_PLV.AVG_oxy); caxis([0.1 0.5]);
frame = getframe(fig);
img = frame2im(frame);
imwrite(img,['01FC_PLV','.tif']); 
fig = figure;
subplot(1,3,1); imagesc(1:20, 1:20, C1_AVG_cor.AVG_oxy); caxis([0.1 0.5]);
subplot(1,3,2); imagesc(1:20, 1:20, C2_AVG_cor.AVG_oxy); caxis([0.1 0.5]); 
subplot(1,3,3); imagesc(1:20, 1:20, C3_AVG_cor.AVG_oxy); caxis([0.1 0.5]); 
frame = getframe(fig);
img = frame2im(frame);
imwrite(img,['01FC_cor','.tif']); 
fig = figure;
subplot(1,3,1); imagesc(1:20, 1:20, C1_AVG_coh.AVG_oxy); caxis([0.1 0.5]);
subplot(1,3,2); imagesc(1:20, 1:20, C2_AVG_coh.AVG_oxy); caxis([0.1 0.5]);
subplot(1,3,3); imagesc(1:20, 1:20, C3_AVG_coh.AVG_oxy); caxis([0.1 0.5]);
frame = getframe(fig);
img = frame2im(frame);
imwrite(img,['01FC_coh','.tif']); 
FC = struct;
FC = C1_result_PLV;
FC(2,:) = C1_result_PLV;
FC(3,:) = C1_result_PLV;

% Result.cor = nirs_statistical_test(C1_result_corr,C2_result_corr,5000,1);
% Result.coh = nirs_statistical_test(C1_result_coh,C2_result_coh,5000,1);
% Result.PLV = nirs_statistical_test(C1_result_PLV,C2_result_PLV,5000,1);
save('FC_outPUT.mat')
