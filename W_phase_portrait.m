clear
close all
clc
delete(gcp('nocreate'))
tic

DIR ='/home/pracownicy/karpinska/Dokumenty/Praca_doktorska_analizy/Monodisperse_particles/';
spec='Results_dock_time/Initial_vel_fluid/';
loadDIR=[DIR spec];

%% Declare constants, load functions and data
Const = Constants;
fDIR='/home/pracownicy/karpinska/Dokumenty/Praca_doktorska_analizy/Monodisperse_particles/Functions/';
addpath(fDIR)

load([loadDIR 'Dock_time_eps_00001.mat'])

%% choose
typ=1; % 0 - particles starting at r0=0, 1 - at r0=rs

% plot parameters
ile=15;
fsize=16;
width=25;
height=20;


%% Plot
switch typ
    case 1
        r0=1.58499;
    case 0
        r0=0;
end

wybor=[];
for p=1:numel(part)
    param(p)=part(p).par.A^(-1)*part(p).par.St;
    if abs(part(p).init.r0_bez-r0)<=eps && imag(texit(p))==0 && isnan(texit(p))==0
        wybor=[wybor,p];
    end
end

param_wyb=param(wybor);
parmin=min(param_wyb);
parmax=max(param_wyb);
wartosci=linspace(parmin,parmax,ile);

for j=1:numel(wartosci)
    nr=1;
    [out,idx]=sort(abs(param_wyb-wartosci(j)));
    znalezione=find(param_wyb(idx(1))==param);
    numerki(j)=znalezione(1);
end
numerki(1)=[];
param_rys=param(numerki);


figure
set(gcf,'Position', [640, 300, 4*560, 2*420 ],...
     'paperunits','centimeters',...
     'papersize',[width,height],...
     'InvertHardCopy','off')
 
subplot(1,2,1)
for k=1:numel(numerki)
    p=numerki(k);

    xplot=part(p).traj.X(:,1);
    yplot= part(p).traj.X(:,3);
    plot(xplot,yplot,'Color',[param(p)/parmax 1-param(p)/parmax 0])
    hold on
        if numel(nonzeros(yplot<-0.2))>0
        end

end
    xlabel('$r^{\ast}$','interpreter','latex')
    ylabel('$\dot{r^{\ast}}$','interpreter','latex')
    
 subplot(1,2,2)
for k=1:numel(numerki)
    p=numerki(k);
    
    xplot=part(p).traj.X(:,2)/(2*pi);
    yplot= part(p).traj.X(:,4)/(2*pi);
    plot(xplot,yplot,'Color',[param(p)/parmax 1-param(p)/parmax 0])
    hold on

end
xlabel('$\phi^{\ast}/2\pi$','interpreter','latex')
 ylabel('$\dot{\phi^{\ast}}/2\pi$','interpreter','latex')