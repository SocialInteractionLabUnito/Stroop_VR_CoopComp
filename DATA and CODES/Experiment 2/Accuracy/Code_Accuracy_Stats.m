
%% Stats accuracy Exp 2

clc
clear
close all

accuracy = readtable('Dataset_Accuracy.xlsx');

% Run stats
%------------------------------------------------
Social = categorical({'Competition' 'Competition' 'Competition' 'Cooperation' 'Cooperation' 'Cooperation'}');
Overtime = categorical({'1' '2' '3' '1' '2' '3'}');

withintab = table(Social, Overtime,'variablenames',{'Social','Overtime'});

rm = fitrm(accuracy,'Acc_Comp1-Acc_Coop3 ~1','withindesign',withintab);

ANOVA_Accuracy = ranova(rm,'withinmodel','Social*Overtime');

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
[~, pHoc.Accuracy.Comp1_Coop1.p, ~, pHoc.Accuracy.Comp1_Coop1.stats] = ttest(accuracy.Acc_Comp1, accuracy.Acc_Coop1);
[~, pHoc.Accuracy.Comp2_Coop2.p, ~, pHoc.Accuracy.Comp2_Coop2.stats] = ttest(accuracy.Acc_Comp2, accuracy.Acc_Coop2);
[~, pHoc.Accuracy.Comp3_Coop3.p, ~, pHoc.Accuracy.Comp3_Coop3.stats] = ttest(accuracy.Acc_Comp3, accuracy.Acc_Coop3);
[~, pHoc.Accuracy.Firstsession_Secondsession.p, ~, pHoc.Accuracy.Firstsession_Secondsession.stats] = ttest(mean([accuracy.Acc_Comp1, accuracy.Acc_Coop1], 2), (mean([accuracy.Acc_Comp2, accuracy.Acc_Coop2], 2)));
[~, pHoc.Accuracy.Firstsession_Thirdsession.p, ~, pHoc.Accuracy.Firstsession_Thirdsession.stats] = ttest(mean([accuracy.Acc_Comp1, accuracy.Acc_Coop1], 2), (mean([accuracy.Acc_Comp3, accuracy.Acc_Coop3], 2)));

% Correct with FDR
p_list = table();
p_list.Cond(1) = "Comp1_Comp1";
p_list.Cond(2) = "Comp2_Coop2";
p_list.Cond(3) = "Comp3_Coop3";

p_list.p_orig(1) = pHoc.Accuracy.Comp1_Coop1.p;
p_list.p_orig(2) = pHoc.Accuracy.Comp2_Coop2.p;
p_list.p_orig(3) = pHoc.Accuracy.Comp3_Coop3.p;

p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.Accuracy.Comp1_Coop1.pCorr = p_list.p_corr_fdr((p_list.Cond == "Comp1_Comp1"));
pHoc.Accuracy.Comp2_Coop2.pCorr = p_list.p_corr_fdr((p_list.Cond == "Comp2_Coop2"));
pHoc.Accuracy.Comp3_Coop3.pCorr = p_list.p_corr_fdr((p_list.Cond == "Comp3_Coop3"));

p_list = table();
p_list.Cond(1) = "1_2";
p_list.Cond(2) = "1_3";

p_list.p_orig(1) = pHoc.Accuracy.Firstsession_Secondsession.p;
p_list.p_orig(2) = pHoc.Accuracy.Firstsession_Thirdsession.p;


p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.Accuracy.Firstsession_Secondsession.pCorr = p_list.p_corr_fdr((p_list.Cond == "1_2"));
pHoc.Accuracy.Firstsession_Thirdsession.pCorr = p_list.p_corr_fdr((p_list.Cond == "1_3"));


