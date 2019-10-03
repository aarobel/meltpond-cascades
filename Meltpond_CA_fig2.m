%% Parameters for baseline simulation
clear;

n = 50;             %square domain number of ponds per edge (total ponds: nxn)
iters=3*(n^2);      %number of iterations per pond
th_init=4;          %initial ice strength, k_0
hf_dmg=1;           %damage rate, D
heal_speed = 0;     %heal speed (off)

%snapshot iterations
t_fill = 1*(n^2);   
t_hf = 1.8*(n^2);
t_clps = 2.9*(n^2);

%% Run Simulation
[zs,thsp,avs,av_plt,zs_big,ths_big] = meltponds_nonconserve(n,iters,th_init,heal_speed,hf_dmg);

%% Plot Time evolution figure
figure(2);set(2,'units','normalized','position',[0 0.1 0.99 0.4]);
[ax,h1,h2] = plotyy((1:iters)./n^2,zs,(1:iters)./n^2,thsp);hold on;
plot(ax(1),t_fill.*ones(1,5)./n^2,linspace(0,4,5),'k--','linewidth',2)
plot(ax(1),t_hf.*ones(1,5)./n^2,linspace(0,4,5),'k--','linewidth',2)
plot(ax(1),t_clps.*ones(1,5)./n^2,linspace(0,4,5),'k--','linewidth',2)
set(h1,'linewidth',10)
set(h2,'linewidth',10,'linestyle','--')
xlabel('Mean water supply','fontsize',30)
ylabel(ax(1),'Mean water pond depth','fontsize',30)
ylabel(ax(2),'Mean ice strength','fontsize',30)
set(ax,'fontsize',30,'XLim',[0 iters/n^2])
set(ax(1),'YLim',[0 1.5])
set(ax(2),'YLim',[0 th_init])
set(gca,'fontsize',30);
text(0.319,1.11,'(b)','Units', 'Normalized', 'VerticalAlignment', 'Top','fontsize',30)
text(0.585,1.11,'(c)','Units', 'Normalized', 'VerticalAlignment', 'Top','fontsize',30)
text(0.952,1.11,'(d)','Units', 'Normalized', 'VerticalAlignment', 'Top','fontsize',30)

%% Plot snapshot 1
meltponds_plot(squeeze(zs_big(:,:,t_fill)),squeeze(ths_big(:,:,t_fill)),4,3);
xlim([0.5 n+0.5]);ylim([0.5 n+0.5]);

%% Plot snapshot 2
meltponds_plot(squeeze(zs_big(:,:,t_hf)),squeeze(ths_big(:,:,t_hf)),4,4);
xlim([0.5 n+0.5]);ylim([0.5 n+0.5]);

%% Plot snapshot 3
meltponds_plot(squeeze(zs_big(:,:,t_clps)),squeeze(ths_big(:,:,t_clps)),4,5);
xlim([0.5 n+0.5]);ylim([0.5 n+0.5]);
