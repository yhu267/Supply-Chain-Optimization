data = load('economic_results.csv');
day  = data(:,1);
Cop    = data(:,2);
Ctrans = data(:,3);
Cp     = data(:,6)*1.34*1000;
Cn     = data(:,7)*0.86*1000;

figure()
plot(day,Cop,'k-o','LineWidth',1,'MarkerSize', 4, 'MarkerFaceColor','k');
hold on
plot(day,Ctrans,'b--d','LineWidth',1,'MarkerSize', 4, 'MarkerFaceColor','b');
plot(day,Cp,'r-.x','LineWidth',1,'MarkerSize', 5, 'MarkerFaceColor','r');
plot(day,Cn,'g:^','LineWidth',1,'MarkerSize', 5);
scatter(day,Cp,15,'rx','LineWidth',1.5)
scatter(day,Cn,15,'g^', 'LineWidth',1.25);
%xlabel('Time Interval');
ylabel('USD');
legend('Operational Cost','Transportation Cost', 'Fertilizer Cost (P)', 'Fertilizer Cost (N)','Location','northoutside','Orientation','horizontal')
axis([1 15 0 80000])
hold off
set(gcf,'Position',[50 50 800 300]);
set(gca,'xtick',1:15, 'xticklabel',{' ','Apr.',' ','May.',' ','Jun.',' ','Jul.',' ','Aug.',' ','Sep.',' ','Oct',' '});
set(gca,'FontSize', 12);