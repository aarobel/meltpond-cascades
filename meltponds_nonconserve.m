function [zs,thsp,avs,av_plt,zs_big,ths_big] = meltponds_nonconserve(n,iters,th_init,heal_speed,hf_dmg)
%meltponds_nonconserve is a cellular automaton model for the filling,
%draining, and interaction of a regularly-spaced network of melt ponds on 
%an ice shelf. The model is described in Robel & Banwell 2019 in GRL
%(note this is a type of nonconservative sanpdile model, a few small
%changes can be implemented to make the model conservative)
%Inputs: n - dimension of square melt pond network of size n x n
%        iters - number of meltwater perturbations to add (model
%        iterations)
%        th_init - initial value of k, ice strength
%        heal_speed - rate of ice strength increase (number of sites
%        strengthened per iteration - not used in paper)
%        hf_dmg - rate of damaging per hydrofracture event (D in paper)
%Outputs: zs - mean meltpond depth as a function of iteration
%         thsp - mean ice strength as a function of iteration
%         avs - number of hydrofracture cascades as a function of iteration
%         av_plt - cascade size counter
%         zs_big - meltwater pond thickness at every iteration and
%         sub-iteration
%         ths_big - ice strength at every iteration and sub-iteration

big_save_on=1;  %set to one to produce verbose output (every iteration and sub-iteration)

if(big_save_on)
    bst = 0;
    zs_big = nan*ones(n,n,iters);
    ths_big = nan*ones(n,n,iters);
else 
    zs_big = [];
    ths_big = [];
end
z = zeros(n);           %initialize water thickness distribution, z
av_plt = 0;           %initialize water thickness distribution, z
th = th_init.*ones(n);  %initialize ice strength, k

seeds = randi(n,2,iters);   %random seeds for location of melt water addition
seeds2 = randi(n,2,iters,heal_speed);   %random seeds for healing

for i = 1:iters         %loop of iterations
    z(seeds(1,i),seeds(2,i)) = z(seeds(1,i),seeds(2,i))+1;  %add meltwater at random site
    
    for q=1:heal_speed  %healing
        if(z(seeds2(1,i,q),seeds2(2,i,q))==0)
            th(seeds2(1,i,q),seeds2(2,i,q)) = th(seeds2(1,i,q),seeds2(2,i,q))+1;
            th(seeds2(1,i,q),seeds2(2,i,q)) = min([th(seeds2(1,i,q),seeds2(2,i,q)) th_init]);
        end
        
    end
    
    av = 0;
    
    if(big_save_on)
        bst = bst+1;
        zs_big(:,:,bst) = z;
        ths_big(:,:,bst) = th;
    end
    
    while(sum(sum((z>=th & z>0)))>0)    %while there are sites with z>=k
        bidx = (z>=th & z>0);           %check where z>=k
        av = av + sum(sum(bidx));
        
        %use matrix shifting to create kernel of damaging
        sft_11=circshift(bidx,1,1);sft_11(1,:) = 0;
        sft_m11=circshift(bidx,-1,1);sft_m11(end,:) = 0;
        sft_12=circshift(bidx,1,2);sft_12(:,1) = 0;
        sft_m12=circshift(bidx,-1,2);sft_m12(:,end) = 0;
        
        z = z - z.*bidx; %hydrofracture remove all water
        
        th = th - hf_dmg.*(bidx+sft_11+sft_m11+sft_12+sft_m12); %damage HF and nearby sites
        
        th = max(th,zeros(n));  %ensure k is not negative
        if(big_save_on)     %verbose output save
            bst = bst+1;
            zs_big(:,:,bst) = z;
            ths_big(:,:,bst) = th;
        end
            
    end

    % update avalanche counter
    if av > 0
        if numel(av_plt)>=av
            av_plt(av) = av_plt(av)+1;
        else
            av_plt(av) = 1;
        end
    end
    
    %save mean values on every iteration
    zs(i) = mean(mean(z));
    thsp(i) = mean(mean(th));
    avs(i) = av;
end