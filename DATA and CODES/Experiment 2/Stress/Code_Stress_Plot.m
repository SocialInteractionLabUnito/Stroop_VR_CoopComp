%% Plot stress Exp 2
clc
clear
close all

data = readtable('Dataset_Stress.xlsx');

normdata= table2array(data(:, 2:7));

figure

y= [mean(normdata(:,4)), mean(normdata(:,1));...
    mean(normdata(:,5)), mean(normdata(:,2));...
    mean(normdata(:,6)), mean(normdata(:,3))];
yerr= [sterr(normdata(:,4)), sterr(normdata(:,1));...
        sterr(normdata(:,5)), sterr(normdata(:,2));...
        sterr(normdata(:,6)), sterr(normdata(:,3))];

categories = {'Block 1', 'Block 2', 'Block 3'};

figure;
b = bar(y, 'grouped');

hold on;

[ngroups, nbars] = size (y);

groupwidth = min(0.8,nbars/(nbars +1.5));

for i=1:nbars

    x=(1:ngroups)-groupwidth/2 +(2*i-1)* groupwidth/(2*nbars);
    errorbar(x,y(:,i), yerr(:,i), '.');
end

hold off


xticks(1:3);
xticklabels(categories);
title('BPM')



