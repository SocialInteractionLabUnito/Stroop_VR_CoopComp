
%% Stats Stress Exp 1

clc
clear
close all

Stress = readtable('Dataset_Stress.xlsx');

% Run stats
%------------------------------------------------
Social = categorical({'Competition' 'Competition' 'Cooperation' 'Cooperation'}');
Other = categorical({'Better' 'Worse' 'Better' 'Worse'}');

withintab = table(Social, Other,'variablenames',{'Social','Other'});

rm = fitrm(Stress,'Stress_Competition_Better-Stress_Cooperation_Worse ~1','withindesign',withintab);

ANOVA_Stress = ranova(rm,'withinmodel','Social*Other');

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
m_Competition = mean([Stress.Stress_Competition_Better Stress.Stress_Competition_Worse], 2);
m_Cooperation = mean([Stress.Stress_Cooperation_Better Stress.Stress_Cooperation_Worse], 2);
m_Better = mean([Stress.Stress_Competition_Better Stress.Stress_Cooperation_Better], 2);
m_Worse = mean([Stress.Stress_Competition_Worse Stress.Stress_Cooperation_Worse], 2);

[~, pHoc.Stress.MainSocial.p, ~, pHoc.Stress.MainSocial.stats] = ttest(m_Competition, m_Cooperation);
[~, pHoc.Stress.MainOther.p, ~, pHoc.Stress.MainOther.stats] = ttest(m_Better, m_Worse);
[~, pHoc.Stress.CompB_CompW.p, ~, pHoc.Stress.CompB_CompW.stats] = ttest(Stress.Stress_Competition_Better, Stress.Stress_Competition_Worse);
[~, pHoc.Stress.CompB_CoopB.p, ~, pHoc.Stress.CompB_CoopB.stats] = ttest(Stress.Stress_Competition_Better, Stress.Stress_Cooperation_Better);
[~, pHoc.Stress.CompB_CoopW.p, ~, pHoc.Stress.CompB_CoopW.stats] = ttest(Stress.Stress_Competition_Better, Stress.Stress_Cooperation_Worse);

% Versus 0
[~, pHoc.Stress.CompB_Zero.p, ~, pHoc.Stress.CompB_Zero.stats] = ttest(Stress.Stress_Competition_Better);
[~, pHoc.Stress.CompW_Zero.p, ~, pHoc.Stress.CompW_Zero.stats] = ttest(Stress.Stress_Competition_Worse);
[~, pHoc.Stress.CoopB_Zero.p, ~, pHoc.Stress.CoopB_Zero.stats] = ttest(Stress.Stress_Cooperation_Better);
[~, pHoc.Stress.CoopW_Zero.p, ~, pHoc.Stress.CoopW_Zero.stats] = ttest(Stress.Stress_Cooperation_Worse);

% Correct with fdr - post hocs main
p_list = table();
p_list.Cond(1) = "MainSocial";
p_list.Cond(2) = "MainOther";

p_list.p_orig(1) = pHoc.Stress.MainSocial.p;
p_list.p_orig(2) = pHoc.Stress.MainOther.p;


p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.Stress.MainSocial.pCorr = p_list.p_corr_fdr((p_list.Cond == "MainSocial"));
pHoc.Stress.MainOther.pCorr = p_list.p_corr_fdr((p_list.Cond == "MainOther"));

% Correct with fdr - post hocs interaction
p_list = table();
p_list.Cond(1) = "CompB_CompW";
p_list.Cond(2) = "CompB_CoopB";
p_list.Cond(3) = "CompB_CoopW";

p_list.p_orig(1) = pHoc.Stress.CompB_CompW.p;
p_list.p_orig(2) = pHoc.Stress.CompB_CoopB.p;
p_list.p_orig(3) = pHoc.Stress.CompB_CoopW.p;

p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.Stress.CompB_CompW.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_CompW"));
pHoc.Stress.CompB_CoopB.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_CoopB"));
pHoc.Stress.CompB_CoopW.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_CoopW"));


% Correct with FDR - contro zero
p_list = table();
p_list.Cond(1) = "CompB_Zero";
p_list.Cond(2) = "CompW_Zero";
p_list.Cond(3) = "CoopB_Zero";
p_list.Cond(4) = "CoopW_Zero";

p_list.p_orig(1) = pHoc.Stress.CompB_Zero.p;
p_list.p_orig(2) = pHoc.Stress.CompW_Zero.p;
p_list.p_orig(3) = pHoc.Stress.CoopB_Zero.p;
p_list.p_orig(4) = pHoc.Stress.CoopW_Zero.p;

p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.Stress.CompB_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_Zero"));
pHoc.Stress.CompW_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompW_Zero"));
pHoc.Stress.CoopB_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CoopB_Zero"));
pHoc.Stress.CoopW_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CoopW_Zero"));
















