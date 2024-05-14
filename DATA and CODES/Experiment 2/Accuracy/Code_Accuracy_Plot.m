%% Plot accuracy Exp 2 

clc
clear
close all

data = readtable('Dataset_Accuracy.xlsx');

normdata= table2array(data(:, 2:7));

figure
x = 1:3;

y = [mean(normdata(:,1)) mean(normdata(:,2)) mean(normdata(:,3)); 
     mean(normdata(:,4)) mean(normdata(:,5)) mean(normdata(:,6))];
yerr = [sterr(normdata(:,1)) sterr(normdata(:,2)) sterr(normdata(:,3)); 
     sterr(normdata(:,4)) sterr(normdata(:,5)) sterr(normdata(:,6))];


        plot(x,y(1,:),'b-o','LineWidth',1,'markerfacecolor','b')
        hold on
        plot(x,y(2,:),'r-o','LineWidth',1,'markerfacecolor','r')

        errorbar( x, y(1,:), yerr(1,:),'b-o','LineWidth',1,'markerfacecolor','b')
        hold on
        errorbar( x, y(2,:), yerr(2,:),'r-o','LineWidth',1,'markerfacecolor','r')
        
 
        xticks([1 2 3])
        xlim([0.5 3.5])
        xticklabels({'1', '2', '3' })

       
        title('Accuracy')


