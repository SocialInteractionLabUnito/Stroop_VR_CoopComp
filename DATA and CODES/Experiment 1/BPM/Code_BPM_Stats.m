%% Stats BPM Exp 1

clc
clear
close all

BPM = readtable('Dataset_BPM.xlsx');


% Run stats
%------------------------------------------------
Social = categorical({'Competition' 'Competition' 'Cooperation' 'Cooperation'}');
Other = categorical({'Better' 'Worse' 'Better' 'Worse'}');

withintab = table(Social, Other,'variablenames',{'Social','Other'});

rm = fitrm(BPM,'BPM_Competition_Better-BPM_Cooperation_Worse ~1','withindesign',withintab);

ANOVA_BPM = ranova(rm,'withinmodel','Social*Other');

ANOVA_BPM.etaSq = zeros(size(ANOVA_BPM,1), 1);
for i = 1:size(ANOVA_BPM,1)
    p = ANOVA_BPM.pValue(i);
    if p < 0.05
        eta = ( ANOVA_BPM.SumSq(i) ) / (ANOVA_BPM.SumSq(i) + ANOVA_BPM.SumSq(i+1));
        ANOVA_BPM.etaSq(i) = eta;
    end
end

% Post hocs
%--------------------------------------------------
m_Competition = mean([BPM.BPM_Competition_Better BPM.BPM_Competition_Worse], 2);
m_Cooperation = mean([BPM.BPM_Cooperation_Better BPM.BPM_Cooperation_Worse], 2);
m_Better = mean([BPM.BPM_Competition_Better BPM.BPM_Cooperation_Better], 2);
m_Worse = mean([BPM.BPM_Competition_Worse BPM.BPM_Cooperation_Worse], 2);

[~, pHoc.BPM.MainSocial.p, ~, pHoc.BPM.MainSocial.stats] = ttest(m_Competition, m_Cooperation);
[~, pHoc.BPM.MainOther.p, ~, pHoc.BPM.MainOther.stats] = ttest(m_Better, m_Worse);
[~, pHoc.BPM.CompB_CompW.p, ~, pHoc.BPM.CompB_CompW.stats] = ttest(BPM.BPM_Competition_Better, BPM.BPM_Competition_Worse);
[~, pHoc.BPM.CompB_CoopB.p, ~, pHoc.BPM.CompB_CoopB.stats] = ttest(BPM.BPM_Competition_Better, BPM.BPM_Cooperation_Better);
[~, pHoc.BPM.CompB_CoopW.p, ~, pHoc.BPM.CompB_CoopW.stats] = ttest(BPM.BPM_Competition_Better, BPM.BPM_Cooperation_Worse);

% Versus 0
[~, pHoc.BPM.CompB_Zero.p, ~, pHoc.BPM.CompB_Zero.stats] = ttest(BPM.BPM_Competition_Better);
[~, pHoc.BPM.CompW_Zero.p, ~, pHoc.BPM.CompW_Zero.stats] = ttest(BPM.BPM_Competition_Worse);
[~, pHoc.BPM.CoopB_Zero.p, ~, pHoc.BPM.CoopB_Zero.stats] = ttest(BPM.BPM_Cooperation_Better);
[~, pHoc.BPM.CoopW_Zero.p, ~, pHoc.BPM.CoopW_Zero.stats] = ttest(BPM.BPM_Cooperation_Worse);



% Correct with fdr - post hocs main
p_list = table();
p_list.Cond(1) = "MainSocial";
p_list.Cond(2) = "MainOther";

p_list.p_orig(1) = pHoc.BPM.MainSocial.p;
p_list.p_orig(2) = pHoc.BPM.MainOther.p;


p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.BPM.MainSocial.pCorr = p_list.p_corr_fdr((p_list.Cond == "MainSocial"));
pHoc.BPM.MainOther.pCorr = p_list.p_corr_fdr((p_list.Cond == "MainOther"));



% Correct with fdr - post hocs interaction
p_list = table();
p_list.Cond(1) = "CompB_CompW";
p_list.Cond(2) = "CompB_CoopB";
p_list.Cond(3) = "CompB_CoopW";

p_list.p_orig(1) = pHoc.BPM.CompB_CompW.p;
p_list.p_orig(2) = pHoc.BPM.CompB_CoopB.p;
p_list.p_orig(3) = pHoc.BPM.CompB_CoopW.p;

p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.BPM.CompB_CompW.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_CompW"));
pHoc.BPM.CompB_CoopB.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_CoopB"));
pHoc.BPM.CompB_CoopW.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_CoopW"));


% Correct with FDR - contro zero
p_list = table();
p_list.Cond(1) = "CompB_Zero";
p_list.Cond(2) = "CompW_Zero";
p_list.Cond(3) = "CoopB_Zero";
p_list.Cond(4) = "CoopW_Zero";

p_list.p_orig(1) = pHoc.BPM.CompB_Zero.p;
p_list.p_orig(2) = pHoc.BPM.CompW_Zero.p;
p_list.p_orig(3) = pHoc.BPM.CoopB_Zero.p;
p_list.p_orig(4) = pHoc.BPM.CoopW_Zero.p;

p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.BPM.CompB_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_Zero"));
pHoc.BPM.CompW_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompW_Zero"));
pHoc.BPM.CoopB_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CoopB_Zero"));
pHoc.BPM.CoopW_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CoopW_Zero"));





