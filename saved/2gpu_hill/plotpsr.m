% clear;
% gpu1=load('Log_particles.00000.txt');
% gpu2=load('Log_particles.00001.txt');


t=1:175200;
subplot(2,2,1)
ll=plot(t,gpu1(t,18),t,gpu1(t,19));
set(ll,'linewidth',1);
set(gca,'FontSize',18,'FontName','Times New Roman','FontWeight','Bold','Linewidth',1);
ylabel('Send/Receive Number','FontSize',20,'FontName','Times New Roman','FontWeight','Bold');
xlabel('Timestep','FontSize',20,'FontName','Times New Roman','FontWeight','Bold');
legend('send','receive')

subplot(2,2,2)
ll=plot(t,gpu2(t,18),t,gpu2(t,19));
set(ll,'linewidth',1);
set(gca,'FontSize',18,'FontName','Times New Roman','FontWeight','Bold','Linewidth',1);
ylabel('Send/Receive Number','FontSize',20,'FontName','Times New Roman','FontWeight','Bold');
xlabel('Timestep','FontSize',20,'FontName','Times New Roman','FontWeight','Bold');
legend('send','receive')
