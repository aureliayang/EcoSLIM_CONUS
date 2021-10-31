clear;
cpu0=load('./cpu/Reduce_time.00000.txt');
cpu1=load('./cpu/Reduce_time.00001.txt');
cpu2=load('./cpu/Reduce_time.00002.txt');
cpu3=load('./cpu/Reduce_time.00003.txt');

cpu_d2h0=load('./cpu_d2h/Reduce_time.00000.txt');
cpu_d2h1=load('./cpu_d2h/Reduce_time.00001.txt');
cpu_d2h2=load('./cpu_d2h/Reduce_time.00002.txt');
cpu_d2h3=load('./cpu_d2h/Reduce_time.00003.txt');

gpu20=load('./gpu2/Reduce_time.00000.txt');
gpu21=load('./gpu2/Reduce_time.00001.txt');
% gpu22=load('./gpu2/Reduce_time.00002.txt');
% gpu23=load('./gpu2/Reduce_time.00003.txt');

gpu40=load('./gpu4/Reduce_time.00000.txt');
gpu41=load('./gpu4/Reduce_time.00001.txt');
gpu42=load('./gpu4/Reduce_time.00002.txt');
gpu43=load('./gpu4/Reduce_time.00003.txt');

t=cpu0(5:60,1);

subplot(2,2,1)
ll=plot(t,cpu0(t,2),t,cpu1(t,2),t,cpu2(t,2),t,cpu3(t,2),...
    t,cpu_d2h0(t,2),t,cpu_d2h1(t,2),t,cpu_d2h2(t,2),t,cpu_d2h3(t,2),...
    t,gpu20(t,2),t,gpu21(t,2));
axis([0 60 0 0.1])
set(ll(1:4),'linewidth',1)
set(ll(5:8),'linewidth',2)
set(ll(9:10),'linewidth',3)
ylabel('time used (ms)','FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold');
xlabel('','FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold');
set(gca,'FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold','Linewidth',1);

subplot(2,2,2)
ll=plot(t,gpu40(t,2),t,gpu41(t,2),t,gpu42(t,2),t,gpu43(t,2));
axis([0 60 0 1.])
set(ll(1:4),'linewidth',1)
ylabel('time used (ms)','FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold');
xlabel('','FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold');
set(gca,'FontSize',18,'FontName','Helvetica Neue','FontWeight','Bold','Linewidth',1);
