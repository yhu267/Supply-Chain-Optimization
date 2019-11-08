load('results.mat');
%c = categorical({'Scenario I','Scenario II','Scenario III','Scenario IV','Scenario V','Scenario VI','Scenario VII','Scenario VIII'});
bar(y);
legend('Operational Cost','Transportation Cost', 'Fertilizer Cost (P)', 'Fertilizer Cost (N)','Total Cost','Location','northoutside','Orientation','horizontal');
ylabel('Ratio');
set(gca,'xtick',1:8, 'xticklabel',{'Scenario I','Scenario II','Scenario III','Scenario IV','Scenario V','Scenario VI','Scenario VII','Scenario VIII'});
set(gca,'FontSize', 8);
set(gcf,'Position',[50 50 800 300]);