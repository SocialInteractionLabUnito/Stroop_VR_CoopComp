%% Stats stress Exp 2

clc
clear
close all

Stress = readtable('Dataset_Stress.xlsx');

% Run stats
%------------------------------------------------
Social = categorical({'Competition' 'Competition' 'Competition' 'Cooperation' 'Cooperation' 'Cooperation'}');
Overtime = categorical({'1' '2' '3' '1' '2' '3'}');

withintab = table(Social, Overtime,'variablenames',{'Social','Overtime'});

rm = fitrm(Stress,'Stress_Comp1-Stress_Coop3 ~1','withindesign',withintab);

ANOVA_Stress = ranova(rm,'withinmodel','Social*Overtime');

ANOVA_Stress.etaSq = zeros(size(ANOVA_Stress,1), 1);
for i = 1:size(ANOVA_Stress,1)
    p = ANOVA_Stress.pValue(i);
    if p < 0.05
        eta = ( ANOVA_Stress.SumSq(i) ) / (ANOVA_Stress.SumSq(i) + ANOVA_Stress.SumSq(i+1));
        ANOVA_Stress.etaSq(i) = eta;
    end
end


% Post hocs
%--------------------------------------------------
m_Competition = mean([Stress.Stress_Comp1 Stress.Stress_Comp2 Stress.Stress_Comp3], 2);
m_Cooperation = mean([Stress.Stress_Coop1 Stress.Stress_Coop2 Stress.Stress_Coop3], 2);


[~, pHoc.Stress.Comp1_Coop1.p, ~, pHoc.Stress.Comp1_Coop1.stats] = ttest(Stress.Stress_Comp1, Stress.Stress_Coop1);
[~, pHoc.Stress.Comp2_Coop2.p, ~, pHoc.Stress.Comp2_Coop2.stats] = ttest(Stress.Stress_Comp2, Stress.Stress_Coop2);
[~, pHoc.Stress.Comp3_Coop3.p, ~, pHoc.Stress.Comp3_Coop3.stats] = ttest(Stress.Stress_Comp3, Stress.Stress_Coop3);
[~, pHoc.Stress.MainSocial.p, ~, pHoc.Stress.MainSocial.stats] = ttest(m_Competition, m_Cooperation);


% Correct with fdr - post hocs main
p_list = table();
p_list.Cond(1) = "MainSocial";

p_list.p_orig(1) = pHoc.Stress.MainSocial.p;

p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.Stress.MainSocial.pCorr = p_list.p_corr_fdr((p_list.Cond == "MainSocial"));


% Correct with fdr - post hocs interaction
p_list = table();
p_list.Cond(1) = "Comp1_Coop1";
p_list.Cond(2) = "Comp2_Coop2";
p_list.Cond(3) = "Comp3_Coop3";

p_list.p_orig(1) = pHoc.Stress.Comp1_Coop1.p;
p_list.p_orig(2) = pHoc.Stress.Comp2_Coop2.p;
p_list.p_orig(3) = pHoc.Stress.Comp3_Coop3.p;

p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.Stress.Comp1_Coop1.pCorr = p_list.p_corr_fdr((p_list.Cond == "Comp1_Coop1"));
pHoc.Stress.Comp2_Coop2.pCorr = p_list.p_corr_fdr((p_list.Cond == "Comp2_Coop2"));
pHoc.Stress.Comp3_Coop3.pCorr = p_list.p_corr_fdr((p_list.Cond == "Comp3_Coop3"));



