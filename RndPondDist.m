function nbr_list = RndPondDist(n2,L,R_i)
center = [rand(n2,1).*L,rand(n2,1).*L];

nbr_list = zeros(n2,20);
n_nbr = nan.*ones(n2,1);

for i = 1:n2
   dist = center-repmat(center(i,:),[n2 1]);
   dist = sqrt(dist(:,1).^2 + dist(:,2).^2);
   
   idx = find(dist<=R_i);
   idx(idx==i) = [];
   
   n_nbr(i) = length(idx);
   nbr_list(i,1:length(idx)) = idx';
   
   dsts(i) = nanmean(dist(idx));
end