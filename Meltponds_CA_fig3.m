%% Common Parameters
clr = lines(8);
k=0;

binedge = [1.5:1:10.5,logspace(1.1,3,20)];
binmid = (binedge(1:end-1)+binedge(2:end))./2;

n = 50;
n2=n^2;         %number of ponds
iters=3*(n2);   %number of iterations
nrep = 100;     %number of times to repeat simulations with given parameters to get robust cascade size counts
L=n;

%% Run random-dsitributed meltpond CA model with: D=1 A=6 n2=2500
k=k+1;
hf_dmg = 1;
R_i = sqrt(5/pi);
av_plt_rep = zeros(1,n2);
thspm = zeros(1,iters);

for rep=1:nrep   %repeat simulation to get robust avalance counts
    nbr_list = RndPondDist(n2,L,R_i);
    th_init = 4.*ones(n2,1);
    [zs,thsp,avs,av_plt,zs_big,ths_big] = meltponds_nbrlist(nbr_list,iters,th_init,hf_dmg);

    av_plt_rep(1:length(av_plt)) = av_plt_rep(1:length(av_plt)) + av_plt;
    [rep]

    thspm = thspm + thsp./nrep;
end

idx=2:numel(av_plt_rep);
dsc = discretize(idx,binedge);
avless=av_plt_rep(idx);
for i=1:length(binmid)
    avp(i) = sum(avless(dsc==i))./sum(dsc==i);
end

Stotal_bl = sum(avp);

figure(3);set(3,'units','normalized','position',[0 0.1 0.5 0.7]);
subplot(2,2,1)
loglog(binmid,avp./nrep,'-','linewidth',3,'Color',clr(k,:));hold on;drawnow

subplot(2,2,3)
plot((1:iters)/(n^2),thsp(1:iters),'-','linewidth',3,'Color',clr(k,:));hold on;%ylabel('avg dmg');xlabel('Water/pond')


%% Run random-dsitributed meltpond CA model with: D=4 A=6 n2=2500
k=k+1;
hf_dmg = 4;
R_i = sqrt(5/pi);
av_plt_rep = zeros(1,n2);
thspm = zeros(1,iters);

for rep=1:nrep   %repeat simulation to get robust avalance counts
    nbr_list = RndPondDist(n2,L,R_i);
    th_init = 4.*ones(n2,1);
    [zs,thsp,avs,av_plt,zs_big,ths_big] = meltponds_nbrlist(nbr_list,iters,th_init,hf_dmg);

    av_plt_rep(1:length(av_plt)) = av_plt_rep(1:length(av_plt)) + av_plt;
    [rep]

    thspm = thspm + thsp./nrep;
end

idx=2:numel(av_plt_rep);
dsc = discretize(idx,binedge);
avless=av_plt_rep(idx);
for i=1:length(binmid)
    avp(i) = sum(avless(dsc==i))./sum(dsc==i);
end

figure(3);
subplot(2,2,1)
loglog(binmid,avp./nrep,'-','linewidth',3,'Color',clr(k,:));hold on;drawnow

subplot(2,2,3)
plot((1:iters)/(n^2),thsp(1:iters),'-','linewidth',3,'Color',clr(k,:));hold on;%ylabel('avg dmg');xlabel('Water/pond')

%% Run random-dsitributed meltpond CA model with: D=5 A=6 n2=2500
k=k+1;
hf_dmg = 5;
R_i = sqrt(5/pi);
av_plt_rep = zeros(1,n2);
thspm = zeros(1,iters);

for rep=1:nrep   %repeat simulation to get robust avalance counts
    nbr_list = RndPondDist(n2,L,R_i);
    th_init = 4.*ones(n2,1);
    [zs,thsp,avs,av_plt,zs_big,ths_big] = meltponds_nbrlist(nbr_list,iters,th_init,hf_dmg);

    av_plt_rep(1:length(av_plt)) = av_plt_rep(1:length(av_plt)) + av_plt;
    [rep]

    thspm = thspm + thsp./nrep;
end

idx=2:numel(av_plt_rep);
dsc = discretize(idx,binedge);
avless=av_plt_rep(idx);
for i=1:length(binmid)
    avp(i) = sum(avless(dsc==i))./sum(dsc==i);
end

figure(3);
subplot(2,2,1)
loglog(binmid,avp./nrep,'-','linewidth',3,'Color',clr(k,:));hold on;drawnow

subplot(2,2,3)
plot((1:iters)/(n^2),thsp(1:iters),'-','linewidth',3,'Color',clr(k,:));hold on;

%% Run random-dsitributed meltpond CA model with: D=5 A=10 n2=2500
k=k+1;
hf_dmg = 4;
R_i = sqrt(10/pi);
av_plt_rep = zeros(1,n2);
thspm = zeros(1,iters);

for rep=1:nrep   %repeat simulation to get robust avalance counts
    nbr_list = RndPondDist(n2,L,R_i);
    th_init = 4.*ones(n2,1);
    [zs,thsp,avs,av_plt,zs_big,ths_big] = meltponds_nbrlist(nbr_list,iters,th_init,hf_dmg);

    av_plt_rep(1:length(av_plt)) = av_plt_rep(1:length(av_plt)) + av_plt;
    [rep]

    thspm = thspm + thsp./nrep;
end

idx=2:numel(av_plt_rep);
dsc = discretize(idx,binedge);
avless=av_plt_rep(idx);
for i=1:length(binmid)
    avp(i) = sum(avless(dsc==i))./sum(dsc==i);
end

figure(3);
subplot(2,2,1)
loglog(binmid,avp./nrep,'-','linewidth',3,'Color',clr(k,:));hold on;drawnow

subplot(2,2,3)
plot((1:iters)/(n^2),thsp(1:iters),'-','linewidth',3,'Color',clr(k,:));hold on;%ylabel('avg dmg');xlabel('Water/pond')

%% Parameter space
Ds = 1:5;
Rs = linspace(0,sqrt(200/pi),40);
nrep=100;

i=0;
for hf_dmg = Ds
    i=i+1;j=0;
    for R_i = Rs
        j=j+1;
        av_plt_rep = zeros(1,n2);
        thspm = zeros(1,iters);
        avmax = 0;
        for rep=1:nrep
            nbr_list = RndPondDist(n2,L,R_i);
            th_init = 3+rand(n2,1);
            [zs,thsp,avs,av_plt,zs_big,ths_big] = meltponds_nbrlist(nbr_list,iters,th_init,hf_dmg);

            [hf_dmg,pi*R_i^2,rep]

            thspm = thspm + thsp./nrep;
            avmax = avmax + find(av_plt>0,1,'last')/nrep;
        end
        scurve = 'a+b*tanh(c-(x/d))';
        f1 = fit((1:iters)'/(n^2),thspm',scurve,'Start',[2 2 4 0.4]);
        sps(i,j) = 1/f1.d;
        avms(i,j) = avmax;
    end
end

%load Critfig_paramspace_0423.mat
Ds = [Ds,6];
sps_mf = [sps_mf;zeros(1,length(Rs))];
sps_fm = [sps_fm;zeros(1,length(Rs))];
avms = [avms;zeros(1,length(Rs))];

%% Plot param space

[DS,RS] = meshgrid(Ds,Rs);
subplot(2,2,4)
pcolor(DS,pi*(RS.^2),log10(sps_fm'));shading('flat');cb1=colorbar;caxis([0 4.5])
ylim([0 40])

subplot(2,2,2)
pcolor(DS,pi*(RS.^2),log10(avms'));shading('flat');cb2=colorbar;caxis([0 3])
ylim([0 40])

%% Plot options
subplot(2,2,1)
loglog(logspace(0.3,3,10),400*(logspace(0.3,3,10).^-1.5),'k--','linewidth',5)
xlim([1 1e3])
ylim([1e-3 5e2])
text(0.01,1.02,'a','Units', 'Normalized', 'VerticalAlignment', 'Top','fontsize',40)

set(gca,'fontsize',24)
xlabel('Number of ponds drained in cascade, S','fontsize',24)
ylabel('Avg. number cascades per sim., f(S)','fontsize',24)

legend('D=1,A=5','D=4,A=5','D=5,A=5','D=4,A=10','f(S) ~ S^{-3/2}','Location','NorthEast')

subplot(2,2,3)
xlabel('Mean water supply','fontsize',24)
ylabel('Mean ice strength','fontsize',24)
set(gca,'fontsize',24,'XLim',[0 iters/n^2])
text(0.01,1.02,'c','Units', 'Normalized', 'VerticalAlignment', 'Top','fontsize',40)

subplot(2,2,4)
xlabel('D','fontsize',24)
ylabel('A/P','fontsize',24)
ylabel(cb1,'Collapse speed','fontsize',24)
set(gca,'fontsize',24)
text(0.01,1.02,'d','Units', 'Normalized', 'VerticalAlignment', 'Top','fontsize',40)
text(0.18,0.17,'Realistic Parameter Range','Units', 'Normalized', 'VerticalAlignment', 'Top','fontsize',20,'Color','w')

cb1.Ticks = 0:4;
cb1.TickLabels = {'10^0','10^1','10^2','10^3','10^4'};
colormap('plasma')

subplot(2,2,2)
xlabel('D','fontsize',24)
ylabel('A/P','fontsize',24)
ylabel(cb2,'Average maximum cascade size','fontsize',24)
set(gca,'fontsize',24)
text(0.01,1.02,'b','Units', 'Normalized', 'VerticalAlignment', 'Top','fontsize',40)
cb2.Ticks = 0:3;
cb2.TickLabels = {'10^0','10^1','10^2','10^3'};

h1 = annotation('rectangle');h1.Position = [0.58 0.59 0.27 0.08];
h1.Color = 'w';h1.FaceColor = [0.5 0.5 0.5];h1.FaceAlpha = 0;h1.LineWidth=3;
h2 = annotation('rectangle');h2.Position = [0.58 0.115 0.27 0.08];
h2.Color = 'w';h2.FaceColor = [0.5 0.5 0.5];h2.FaceAlpha = 0;h2.LineWidth=3;
text(0.18,0.17,'Realistic Parameter Range','Units', 'Normalized', 'VerticalAlignment', 'Top','fontsize',20,'Color','w')