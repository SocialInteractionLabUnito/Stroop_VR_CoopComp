
%% Plot Stress Exp 1

clc
clear
close all

Stress = readtable('Dataset_Stress.xlsx');

% Plot 1
%----------------------------------------------------
figure
m1 = mean(Stress.Stress_Competition_Better, 'omitnan');
m2 = mean(Stress.Stress_Competition_Worse, 'omitnan');
m3 = mean(Stress.Stress_Cooperation_Better, 'omitnan');
m4 = mean(Stress.Stress_Cooperation_Worse, 'omitnan');

s1 = sterr(Stress.Stress_Competition_Better);
s2 = sterr(Stress.Stress_Competition_Worse);
s3 = sterr(Stress.Stress_Cooperation_Better);
s4 = sterr(Stress.Stress_Cooperation_Worse);


errorbar([m1, m3], [s1, s3], 'k', 'linewidth', 2, 'Marker','o', 'MarkerFaceColor','k')
hold on
errorbar([m2, m4], [s2, s4], 'r', 'linewidth', 2, 'Marker','o', 'MarkerFaceColor','r')
xlim([0.5 2.5])
xticks(1:2)
yline(0, '-', 'Solo')
xticklabels({'Competition' 'Cooperation'})
xlabel('Social context')
ylabel('\Delta_Z')
legend({'Better' 'Worse'})
title('Stress')




