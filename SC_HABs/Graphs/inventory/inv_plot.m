load('inv_results.mat');
plot(inv_results(:,1),inv_results(:,2),inv_results(:,1),inv_results(:,3),inv_results(:,1),inv_results(:,4),inv_results(:,1),inv_results(:,5),inv_results(:,1),inv_results(:,6),inv_results(:,1),inv_results(:,7),inv_results(:,1),inv_results(:,8),inv_results(:,1),inv_results(:,9),'LineWidth', 1.0);
ylabel('Inventory Level (tonne)');
legend('Scenario I','Scenario II', 'Scenario III', 'Scenario IV','Scenario V','Scenario VI','Scenario VII','Scenario VIII')
axis([0 15 0 170000])
hold off
set(gca,'xtick',1:15, 'xticklabel',{' ','Apr.',' ','May.',' ','Jun.',' ','Jul.',' ','Aug.',' ','Sep.',' ','Oct',' '});
set(gcf,'Position',[50 50 800 300]);
set(gca,'FontSize', 12);