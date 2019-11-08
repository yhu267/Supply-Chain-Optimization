data = load('daily_prediction.csv');
day = data(:,1);
X   = data(:,2);
figure()
plot([0;day],50*ones(1+length(day),1),'r','LineWidth',2);
hold on
plot([0;day],10*ones(1+length(day),1),'y','LineWidth',2);
plot(day,X,'b','LineWidth',2);
plot([0;day],0*ones(1+length(day),1),'g','LineWidth',2);
axis([0 210 0 120]);
%ylabel('Concentration of Chl-a (mg/m^3)');
XAxisLine = 'off';
x0=10;
y0=10;
width=600;
height=200;
set(gcf,'units','points','position',[x0,y0,width,height]);
set(gca,'xtick',[]);
xt = get(gca, 'YTick');
set(gca, 'FontSize', 14);
hold off
