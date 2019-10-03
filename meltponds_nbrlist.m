function [zs,thsp,avs,av_plt,zs_big,ths_big] = meltponds_nbrlist(nbr_list,iters,th_init,hf_dmg)
%meltponds_nonconserve is a cellular automaton model for the filling,
%draining, and interaction of a arbitrary network of melt ponds on 
%an ice shelf. The model is described in Robel & Banwell 2019 in GRL
%(note this is a type of nonconservative sanpdile model, a few small
%changes can be implemented to make the model conservative)
%(also note this is a variation on meltponds_nonconserve that finds the
%nearest neighbors of a melt pond based on a prescribed network geometry,
%the neighbor search also makes this slightly slower in running than
%meltponds_conserve)
%Inputs:  nbr_list - a list of the neighbor sites to each site, may be
%         created in another function, such as RndPondDist
%         iters - number of meltwater perturbations to add (model
%         iterations)
%         th_init - initial distribution of k, ice strength
%         hf_dmg - rate of damaging per hydrofracture event (D in paper)
%Outputs: zs - mean meltpond depth as a function of iteration
%         thsp - mean ice strength as a function of iteration
%         avs - number of hydrofracture cascades as a function of iteration
%         av_plt - cascade size counter
%         zs_big - meltwater pond thickness at every iteration and
%         sub-iteration
%         ths_big - ice strength at every iteration and sub-iteration

big_save_on=1;  %set to one to produce verbose output (every iteration and sub-iteration)
n = length(nbr_list);

if(big_save_on)
    bst = 0;
    zs_big = nan*ones(n,iters);
    ths_big = nan*ones(n,iters);
else 
    zs_big = [];
    ths_big = [];
end

z = zeros(n,1);           %initialize water thickness distribution, z
av_plt = 0;               %initialize water thickness distribution, z
th = th_init;             %initialize ice strength, k

seeds = randi(n,1,iters); %random seeds for location of melt water addition

for i = 1:iters         %loop of iterations
    z(seeds(i)) = z(seeds(i))+1;  %add meltwater at random site
    
    av = 0;
    
    if(big_save_on)
        bst = bst+1;
        zs_big(:,bst) = z;
        ths_big(:,bst) = th;
    end
    
    while(sum((z>=th & z>0))>0)    %while there are sites with z>=k
        bidx = (z>=th & z>0);      %check where z>=k
        bidxn = find(z>=th & z>0);
        av = av + sum(bidx);
        
        %find neighbors of hydrofracturing sites
        hf_list = nbr_list(bidxn,:);
        hf_list = hf_list(:);
        hf_list(hf_list==0) = [];
        hf_list = unique(hf_list);  %not allowing double counting for HF
        
        hf_logical = zeros(n,1);
        hf_logical(hf_list) = 1;
        
        z = z - z.*bidx;            %hydrofracture remove all water
        
        th = th - hf_dmg.*(bidx+hf_logical); %damage HF and nearby sites
        
        th = max(th,zeros(n,1));
        if(big_save_on)
            bst = bst+1;
            zs_big(:,bst) = z;
            ths_big(:,bst) = th;
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
    zs(i) = mean(z);
    thsp(i) = mean(th);
    avs(i) = av;
end