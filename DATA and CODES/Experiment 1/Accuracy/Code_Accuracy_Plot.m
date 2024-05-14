%% Plot Accuracy Exp 1
clc
clear
close all

accuracy = readtable('Dataset_Accuracy.xlsx');

figure
m1 = mean(accuracy.Competition_Better);
m2 = mean(accuracy.Competition_Worse);
m3 = mean(accuracy.Cooperation_Better);
m4 = mean(accuracy.Cooperation_Worse);

s1 = sterr(accuracy.Competition_Better);
s2 = sterr(accuracy.Competition_Worse);
s3 = sterr(accuracy.Cooperation_Better);
s4 = sterr(accuracy.Cooperation_Worse);


errorbar([m1, m3], [s1, s3], 'k', 'linewidth', 2, 'Marker','o', 'MarkerFaceColor','k')
hold on
errorbar([m2, m4], [s2, s4], 'r', 'linewidth', 2, 'Marker','o', 'MarkerFaceColor','r')
xlim([0.5 2.5])
xticks(1:2)
xticklabels({'Competition' 'Cooperation'})
xlabel('Social context')
ylabel('Z_\Delta')
legend({'Better' 'Worse'})
title('Accuracy')




