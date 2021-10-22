clear;
load('data.txt');

% subplot(2,2,1)
ll=loglog(data(:,1),data(:,2),data(:,1),data(:,4),'--',...
    data(:,8),data(:,9),data(:,8),data(:,12),'--',...
    data(:,8),data(:,10),data(:,8),data(:,13),'--');
set(ll(1:2),'linewidth',2);
set(ll(3:4),'linewidth',3);
set(ll(5:6),'linewidth',4);
legend('double-send','double-recv','integer-send','integer-recv',...
    'integer-send*2','integer-recv*2','FontSize',18,'FontName','Helvetica Neue',...
    'Location','southeast')
set(gca,'FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold','Linewidth',1);
ylabel('time used (ms)','FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold');
xlabel('data-size (*4/*8 bytes)','FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold');