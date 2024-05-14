
%% Stats BPM Exp 2

clc
clear
close all

fisio = readtable('Dataset_BPM.xlsx');

% Run stats
%------------------------------------------------
Social = categorical({'Competition' 'Competition' 'Competition' 'Cooperation' 'Cooperation' 'Cooperation'}');
Overtime = categorical({'1' '2' '3' '1' '2' '3'}');

withintab = table(Social, Overtime,'variablenames',{'Social','Overtime'});

rm = fitrm(fisio,'Comp1-Coop3 ~1','withindesign',withintab);

ANOVA_BPM = ranova(rm,'withinmodel','Social*Overtime');

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
m_Competition = mean([fisio.Comp1 fisio.Comp2 fisio.Comp3], 2);
m_Cooperation = mean([fisio.Coop1 fisio.Coop2 fisio.Coop3], 2);


[~, pHoc.fisio.Comp1_Coop1.p, ~, pHoc.fisio.Comp1_Coop1.stats] = ttest(fisio.Comp1, fisio.Coop1);
[~, pHoc.fisio.Comp2_Coop2.p, ~, pHoc.fisio.Comp2_Coop2.stats] = ttest(fisio.Comp2, fisio.Coop2);
[~, pHoc.fisio.Comp3_Coop3.p, ~, pHoc.fisio.Comp3_Coop3.stats] = ttest(fisio.Comp3, fisio.Coop3);
[~, pHoc.fisio.MainSocial.p, ~, pHoc.fisio.MainSocial.stats] = ttest(m_Competition, m_Cooperation);


% Versus 0 da sistemare
% [~, pHoc.BPM.CompB_Zero.p, ~, pHoc.BPM.CompB_Zero.stats] = ttest(data.BPM_Competition_Better);
% [~, pHoc.BPM.CompW_Zero.p, ~, pHoc.BPM.CompW_Zero.stats] = ttest(data.BPM_Competition_Worse);
% [~, pHoc.BPM.CoopB_Zero.p, ~, pHoc.BPM.CoopB_Zero.stats] = ttest(data.BPM_Cooperation_Better);
% [~, pHoc.BPM.CoopW_Zero.p, ~, pHoc.BPM.CoopW_Zero.stats] = ttest(data.BPM_Cooperation_Worse);
% 


% Correct with fdr - post hocs main
p_list = table();
p_list.Cond(1) = "MainSocial";

p_list.p_orig(1) = pHoc.fisio.MainSocial.p;

p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.fisio.MainSocial.pCorr = p_list.p_corr_fdr((p_list.Cond == "MainSocial"));



% Correct with fdr - post hocs interaction
p_list = table();
p_list.Cond(1) = "Comp1_Coop1";
p_list.Cond(2) = "Comp2_Coop2";
p_list.Cond(3) = "Comp3_Coop3";

p_list.p_orig(1) = pHoc.fisio.Comp1_Coop1.p;
p_list.p_orig(2) = pHoc.fisio.Comp2_Coop2.p;
p_list.p_orig(3) = pHoc.fisio.Comp3_Coop3.p;

p_list = sortrows(p_list, 'p_orig');
p_num = size(p_list,1);
p_list.corr = [1:p_num]';
p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;

pHoc.fisio.Comp1_Coop1.pCorr = p_list.p_corr_fdr((p_list.Cond == "Comp1_Coop1"));
pHoc.fisio.Comp2_Coop2.pCorr = p_list.p_corr_fdr((p_list.Cond == "Comp2_Coop2"));
pHoc.fisio.Comp3_Coop3.pCorr = p_list.p_corr_fdr((p_list.Cond == "Comp3_Coop3"));


% Correct with FDR - contro zero da sistemare
% p_list = table();
% p_list.Cond(1) = "CompB_Zero";
% p_list.Cond(2) = "CompW_Zero";
% p_list.Cond(3) = "CoopB_Zero";
% p_list.Cond(4) = "CoopW_Zero";
% 
% p_list.p_orig(1) = pHoc.BPM.CompB_Zero.p;
% p_list.p_orig(2) = pHoc.BPM.CompW_Zero.p;
% p_list.p_orig(3) = pHoc.BPM.CoopB_Zero.p;
% p_list.p_orig(4) = pHoc.BPM.CoopW_Zero.p;
% 
% p_list = sortrows(p_list, 'p_orig');
% p_num = size(p_list,1);
% p_list.corr = [1:p_num]';
% p_list.p_corr_bonfe(:) = p_list.p_orig*p_num;
% p_list.p_corr_fdr(:) = p_list.p_corr_bonfe./p_list.corr;
% 
% pHoc.BPM.CompB_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompB_Zero"));
% pHoc.BPM.CompW_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CompW_Zero"));
% pHoc.BPM.CoopB_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CoopB_Zero"));
% pHoc.BPM.CoopW_Zero.pCorr = p_list.p_corr_fdr((p_list.Cond == "CoopW_Zero"));
% 



