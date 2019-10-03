%% random capacity variation
n = 50;
iters=5*(n^2);
thm=4;
hf_dmg=1;
heal_speed = 0;

pvars = [0.1];
cms = [3.6:0.04:4.1];
clr = lines(length(pvars));
clr2 = viridis(length(cms));

for k = 1:length(pvars)
    
    if(pvars(k)>=0.3 && cms(j) < 3.1 )
        iters=500*(n^2);
    end

    for j = 1:length(cms)
        
        capacity = cms(j) + pvars(k).*randn(n);
        th_init = 3+rand(n,n);
        
        [zs,thsp,avs,zs_big,ths_big] = meltponds_cap(n,iters,th_init,heal_speed,hf_dmg,capacity);

        if(thsp(iters)<1)
            scurve = 'a+b*tanh(c-(x/d))';           %calculate fit to s-curve
            f1 = fit((1:iters)'/(n^2),thsp',scurve,'Start',[2 2 4 0.4]);
            spd=1/f1.d;
            winit = f1.c;
        else
            spd=0;
            winit = nan;
        end
        
        [pvars(k) cms(j) sum(sum(capacity>=th_init))/(n^2)]
            
        thsps(j,k) = thsp(iters);
        fracap(j,k) = sum(sum(capacity>=th_init));
        cmss(j,k) = cms(j);
        sps(j,k) = spd;
        winits(j,k) = winit;
        
        figure(3);hold on
        plot(linspace(0,iters/n^2,iters/10),thsp(1:10:end),'linewidth',3,'Color',clr2(j,:));
        
    end
end

set(3,'units','normalized','position',[0 0.1 0.2 0.2]);
xlim([0 4])
ylim([0 3.55])
set(gca,'fontsize',20);
xlabel('Mean water supply','fontsize',20)
ylabel('Mean ice strength','fontsize',20)
colormap('viridis');cb=colorbar;
ylabel(cb,'Mean Ponding Capacity')
caxis([min(cms) max(cms)])
box on
