function meltponds_plot(z,th,th_init,fig,hf_dmg)

[I,J] = meshgrid(1:length(z),1:length(z));

f=figure(fig);set(f,'units','normalized','position',[0 0.1 0.6 0.8],'visible','off');
clf

ax1 = axes;
pcolor(I-0.9,J-0.9,th);shading('flat');hold on;caxis([0 th_init])

view(2)
ax2 = axes;
scatter(I(:)-0.4,J(:)-0.4,150,z(:),'filled');caxis([0 th_init])

linkaxes([ax1,ax2])
title(ax1,['Regularly-Spaced Pond Network (D=' int2str(hf_dmg) ', A=1)'],'fontsize',30)
% title(ax1,['Mean pond depth = ' num2str(round(mean(mean(z))*100)/100) '; Mean strength = ' num2str(round(mean(mean(th))*100)/100)],'fontsize',24)
ax2.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];
ax1.XTick = [];
ax1.YTick = [];
%% Give each one its own colormap
thcm = gray(th_init);%thcm(1,:) = [0.2 0.2 0.2];
zcm = brewermap(th_init,'PuBu');zcm(1,:) = [1 1 1];

colormap(ax1,thcm)
colormap(ax2,zcm)
%% Then add colorbars and get everything lined up
set([ax1,ax2],'Position',[.17 .11 .685 .815]);
cb1 = colorbar(ax1,'Position',[.05 .11 .0675 .815]);set(cb1,'fontsize',24,'Ticks',[0.5:1:3.5],'TickLabels',{'1','2','3','4'});ylabel(cb1,'Ice Strength (k)','fontsize',24)
cb2 = colorbar(ax2,'Position',[.88 .11 .0675 .815]);set(cb2,'fontsize',24,'Ticks',[0.5:1:3.5],'TickLabels',{'1','2','3','4'});ylabel(cb2,'Pond Depth (z)','fontsize',24)

figure(f);

end