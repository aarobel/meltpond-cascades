function [zs,thsp,avs,zs_big,ths_big] = meltponds_cap(n,iters,th_init,heal_speed,hf_dmg,capacity)
big_save_on=0;

nidx = [-1 0;1 0;0 -1;0 1];

if(big_save_on)
    bst = 0;
    zs_big = nan*ones(n,n,iters);
    ths_big = nan*ones(n,n,iters);
else 
    zs_big = [];
    ths_big = [];
end
z = zeros(n);%randi(2,n);
av_plt = 0;  
th = th_init;%.*ones(n);

seeds = randi(n,2,iters);
seeds2 = randi(n,2,iters,heal_speed);

for i = 1:iters
%     zinit = z;
    
    zidx = [seeds(1,i),seeds(2,i)];
    add_amount = 1+0.2*(randn(1)-0.5);
    if(z(zidx(1),zidx(2))+add_amount<=capacity(zidx(1),zidx(2))) %max out water thickness at a pre-defined capacity
        z(zidx(1),zidx(2)) = z(zidx(1),zidx(2))+add_amount;
    end
            
    
    for q=1:heal_speed
        th(seeds2(1,i,q),seeds2(2,i,q)) = th(seeds2(1,i,q),seeds2(2,i,q))+1;
        th(seeds2(1,i,q),seeds2(2,i,q)) = min([th(seeds2(1,i,q),seeds2(2,i,q)) th_init(seeds2(1,i,q),seeds2(2,i,q))]);
    end
    
    av = 0;
    
    if(big_save_on)
        bst = bst+1;
        zs_big(:,:,bst) = z;
        ths_big(:,:,bst) = th;
    end
    
    while(sum(sum((z>=th & z>0)))>0)
        bidx = (z>=th & z>0);
        av = av + sum(sum(bidx));
        
%         dmg_knl = bidx.*z./5;
                
        sft_11=circshift(bidx,1,1);sft_11(1,:) = 0;
        sft_m11=circshift(bidx,-1,1);sft_m11(end,:) = 0;
        sft_12=circshift(bidx,1,2);sft_12(:,1) = 0;
        sft_m12=circshift(bidx,-1,2);sft_m12(:,end) = 0;

        z = z - z.*bidx; %hydrofracture remove all water
%         z(bidx) = z(bidx) - 4; %hydrofracture remove water equal to damage
        
        th = th - hf_dmg.*(bidx+sft_11+sft_m11+sft_12+sft_m12);
%         th = th - hf_dmg.*(z.*bidx/5); %damage HF sites
        
        th = max(th,zeros(n));
        if(big_save_on)
            bst = bst+1;
            zs_big(:,:,bst) = z;
            ths_big(:,:,bst) = th;
        end
            
    end
%     avs(i) = av;
    % update avalanche counter
    if i>4*(n^2)
        if av > 0
            if numel(av_plt)>=av
                av_plt(av) = av_plt(av)+1;
            else
                av_plt(av) = 1;
            end
        end
    end
    
%     if(mod(i,1e3)==0 | i==1);[i,sum(sum(z))]
%         figure(1);clf;
%         subplot(2,1,1);pcolor(z); shading('flat'); colormap(flipud(bone(5)));colorbar;caxis([0 4])
%         subplot(2,1,2);pcolor(th); shading('flat'); colormap(flipud(bone(5)));colorbar;caxis([0 4])
%         
%         figure(2);hold on
%         subplot(2,1,1);plot(i,mean(mean(z)),'k.');hold on
%         subplot(2,1,2);plot(i,mean(mean(th)),'k.');hold on
%         drawnow
%     end
    
    zs(i) = mean(mean(z));
%     ths(i) = mean(mean(th));
    thsp(i) = mean(mean(th));%sum(sum(th<th_init))./(n^2);
    avs(i) = av;
end