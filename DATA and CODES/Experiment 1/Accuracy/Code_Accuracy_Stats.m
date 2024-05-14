%% Stats Accuracy Exp 1
clc
clear
close all

accuracy = readtable('Dataset_Accuracy.xlsx');

% Run stats
%------------------------------------------------
Social = categorical({'Competition' 'Competition' 'Cooperation' 'Cooperation'}');
Other = categorical({'Better' 'Worse' 'Better' 'Worse'}');

withintab = table(Social, Other,'variablenames',{'Social','Other'});

rm = fitrm(accuracy,'Competition_Better-Cooperation_Worse ~1','withindesign',withintab);

ANOVA_Accuracy = ranova(rm,'withinmodel','Social*Other');

ANOVA_Accuracy.etaSq = zeros(size(ANOVA_Accuracy,1), 1);
for i = 1:size(ANOVA_Accuracy,1)
    p = ANOVA_Accuracy.pValue(i);
    if p < 0.05
        eta = ( ANOVA_Accuracy.SumSq(i) ) / (ANOVA_Accuracy.SumSq(i) + ANOVA_Accuracy.SumSq(i+1));
        ANOVA_Accuracy.etaSq(i) = eta;
    end
end

% Post hocs
%--------------------------------------------------
[~, pHoc.Accuracy.CompB_CompW.p, ~, pHoc.Accuracy.CompB_CompW.stats] = ttest(accuracy.Competition_Better, accuracy.Competition_Worse);
[~, pHoc.Accuracy.CompW_CoopB.p, ~, pHoc.Accuracy.CompW_CoopB.stats] = ttest(accuracy.Competition_Worse, accuracy.Cooperation_Better);
[~, pHoc.Accuracy.CoopB_CoopW.p, ~, pHoc.Accuracy.CoopB_CoopW.stats] = ttest(accuracy.Cooperation_Better, accuracy.Cooperation_Worse);
[~, pHoc.Accuracy.CompB_CoopW.p, ~, pHoc.Accuracy.CompB_CoopW.stats] = ttest(accuracy.Competition_Better, accuracy.Cooperation_Worse);


% Correct with FDR
p_list = table();
p_list.Cond(1) = "CompB_CompW";
p_list.Cond(2) = "CompW_CoopB";
p_list.Cond(3) = "CoopB_CoopW";
p_list.Cond(4) = "CompB_CoopW";

p_list.p_orig(1) = pHoc.Accuracy.CompB_CompW.p;
p_list.p_orig(2) = pHoc.Accuracy.CompW_CoopB.p;
p_list.p_orig(3) = pHoc.Accuracy.CoopB_CoopW.p;
p_list.p_orig(4) = pHoc.Accuracy.CompB_CoopW.p;

p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.Accuracy.CompB_CompW.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_CompW"));
pHoc.Accuracy.CompW_CoopB.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompW_CoopB"));
pHoc.Accuracy.CoopB_CoopW.pCorr = p_list.p_corr_fdr((p_list.Cond == "CoopB_CoopW"));
pHoc.Accuracy.CompB_CoopW.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_CoopW"));
