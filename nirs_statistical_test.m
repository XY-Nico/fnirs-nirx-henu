function Result = nirs_statistical_test(ResultC1,ResultC2,n_perm,type)
Result = struct;
Nsubj = length(ResultC1);
for Subj = 1:Nsubj
    if type == 1%'oxy'
        FC_C1(:,:,Subj) = ResultC1(Subj).oxy;
        FC_C2(:,:,Subj) = ResultC2(Subj).oxy;
    elseif type == 2%'dxy'
        FC_C1(:,:,Subj) = ResultC1(Subj).dxy;
        FC_C2(:,:,Subj) = ResultC2(Subj).dxy;
    end
end
Ncha = size(FC_C1,1);
p_2tailed = ones(Ncha,Ncha);
for i = 1:Ncha
    for j = 1:Ncha
        if i ~= j
            [~, p_2tailed(i,j)] = ttest2(squeeze(FC_C1(i,j,:)), squeeze(FC_C2(i,j,:)));
        end
    end
end
figure;
subplot(1,3,1);imagesc(1:Ncha,1:Ncha, mean(FC_C1,3));caxis([0 1]);
subplot(1,3,2);imagesc(1:Ncha,1:Ncha, mean(FC_C2,3));caxis([0 1]);
subplot(1,3,3);imagesc(1:Ncha,1:Ncha, p_2tailed);caxis([0 0.05]);
[Result.fdr_bh.h, Result.fdr_bh.crit_p, Result.fdr_bh.adj_ci_cvrg, Result.fdr_bh.adj_p] = fdr_bh(p_2tailed);
[Result.fdr_bky.h,Result.fdr_bky.crit_p] = fdr_bky(p_2tailed);
[Result.bonf_holm.corrected_p, Result.bonf_holm.h] = bonf_holm(p_2tailed);
% %% permutation test
pairs = tril(ones(Ncha,Ncha), -1);
[x, y] = find(pairs > 0);
for i = 1:length(x)
    FC_C1_PT(:,i) = squeeze(FC_C1(x(i,1), y(i,1),:))';
    FC_C2_PT(:,i) = squeeze(FC_C2(x(i,1), y(i,1),:))';
end
[pval, ~] = mult_comp_perm_t2(FC_C1_PT,FC_C2_PT,n_perm);
pval2 = nan(Ncha,Ncha);
for i = 1:length(x)
    pval2(x(i,1), y(i,1)) = pval(1,i);
end
Result.pval2 = tril(pval2,-1) + tril(pval2,-1)' + eye(Ncha);
Result.p_withou_test = p_2tailed;
