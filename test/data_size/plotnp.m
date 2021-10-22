clear;
load('data.txt');

% subplot(2,2,1)
ll=loglog(data(:,5),data(:,2),data(:,5),data(:,4),'--');
set(ll(1:2),'linewidth',2);
legend('double-send','double-recv','FontSize',18,'FontName','Helvetica Neue',...
    'Location','southeast')
set(gca,'FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold','Linewidth',1);
ylabel('time used (ms)','FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold');
xlabel('particle number','FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold');