

%coeff = {'0';'0.2';'0.4';'0.6';'0.8';'1';'1.2';'1.4';'1.6';'1.8';'2'};
coeff = {'0';'0.2';'0.4';'0.6';'0.8'};
day = 210;
total_cost = zeros(length(coeff),1);
chla = zeros(day,length(coeff));


for i = 1:length(coeff)
    path = strcat('../../tradeoff_analysis/5_6/', coeff{i});
    cost = csvread(strcat(path,'/results_summary.csv'), 0, 1);
    chl  = csvread(strcat(path,'/daily_chla_distribution.csv'), 1, 1);
    total_cost(i) = cost(2) + cost(3) + cost (4);
    chla(:,i) = 1/5*(chl(:,1)+ chl(:,2)+ chl(:,3)+ chl(:,4)+ chl(:,5));
end
figure()
plot([0;day],50*ones(1+length(day),1),'r','LineWidth',2);
hold on
plot([0;day],10*ones(1+length(day),1),'Color',[0.95 0.7 0.05],'LineWidth',2);
plot([0;day],0*ones(1+length(day),1),'g','LineWidth',2);
for i = 1:length(coeff)
plot(1:day,chla(:,i),'LineWidth', 2);
end
%legend('Total Cost: 9.31e5 USD', 'Total Cost: 1.17e6 USD','Total Cost: 1.30e6 USD','Total Cost: 1.37e6 USD','Total Cost: 1.40e6 USD','Total Cost: 1.41e6 USD')
axis([0 210 0 150]);

x0=10;
y0=10;

width=600;
height=200;
set(gcf,'units','points','position',[x0,y0,width,height]);
set(gca,'xtick',[]);
xt = get(gca, 'YTick');
set(gca, 'FontSize', 14);
hold off



line_color = {[71/255, 155/255, 222/255],[99/255, 203/255, 87/255],[0.95 0.7 0.05],1/255*[255, 54, 133], 1/255*[114, 0, 176]};

figure()
h(1) = mesh(total_cost/1e6,1:day ,chla, zeros(size(chla))-0.1, 'LineWidth', 0.3);
hold on
view([120 30 120]);
for i = 1:length(coeff)
plot3(total_cost(i)*ones(210,1)/1e6,1:210,chla(:,i),'LineWidth', 3, 'Color', line_color{i});
end
alpha(0.3);

x=(8.5e5:10:1.3e6)/1e6;
y=1:day;
[x,y]=meshgrid(x,y);
z=ones(size(x))*50;
h(2) = surf(x,y,z,zeros(size(z))+0.1);
colormap([0.7 0.7 0.7; 1  0  0]);
shading interp
alpha(0.2);
axis([8.5e5/1e6 1.3e6/1e6 0 210 0 100]);

x0=10;
y0=10;
width=800;
height=400;
set(gcf,'units','points','position',[x0,y0,width,height]);
set(gca,'ytick',[]);
set(gca, 'FontSize', 14);
hold off