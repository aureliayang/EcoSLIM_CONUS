clear;
gpu1=load('Log_particles.00000.txt');
gpu2=load('Log_particles.00001.txt');
h1=load('../half1.txt');
h2=load('../half2.txt');
hh(1:99999)=h1(1:99999,15);
hh(100000:175200)=h2(1:75201,14);

t=1:175200;
ll=plot(t,gpu1(t,14),t,gpu2(t,14),t,gpu1(t,14)+gpu2(t,14),t,hh,'--');
set(ll,'linewidth',2);
