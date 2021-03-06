clear;
gpu1=load('Log_particles.00000.txt');
gpu2=load('Log_particles.00001.txt');
gpu3=load('Log_particles.00002.txt');
gpu4=load('Log_particles.00003.txt');
cpu=load('../4gpu_LW/SLIM_LW_log.txt');

% h1=load('../half1.txt');
% h2=load('../half2.txt');
% hh(1:99999)=h1(1:99999,15);
% hh(100000:175200)=h2(1:75201,14);

t=1:3600;
ll=plot(t,gpu1(t,14)+gpu2(t,14)+gpu3(t,14)+gpu4(t,14),'o',t,cpu(:,15),...
    t,gpu1(t,14),t,gpu2(t,14),t,gpu3(t,14),t,gpu4(t,14));
set(ll,'linewidth',2);
set(gca,'FontSize',18,'FontName','Times New Roman','FontWeight','Bold','Linewidth',1);
ylabel('Active Particle Number','FontSize',20,'FontName','Times New Roman','FontWeight','Bold');
xlabel('Timestep','FontSize',20,'FontName','Times New Roman','FontWeight','Bold');

% legend('gpu','cpu-total','gpu1','gpu2','gpu3')
