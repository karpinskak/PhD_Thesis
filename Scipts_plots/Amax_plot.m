clear
close all
clc
delete(gcp('nocreate'))

DIR='/home/pracownicy/karpinska/Dokumenty/Praca_doktorska_analizy/Monodisperse_particles/';

%% Load constants and functions
addpath(DIR)
Const=Constants;
fDIR=[DIR 'Functions/'];
addpath(fDIR)

% choose plot
opcja=1 ;  % 1- pcolor  % 2- patches, 3- 

% plot parameters
fsize=18;
width=16;
height=20;
%% parameter ranges

R=[0.01,(1:0.1:250)]*10^(-6);
%delta=[0.1,0.5:0.5:2.5]*10^(-2);
%delta=[0.1,0.3,0.5,0.7,0.9]*10^(-2);
delta=[0.01:0.005:1.005]*10^(-2);
%gamma=0.05:.01:1;
%delta=sqrt(2*Const.nu./gamma);
kolor=jet(numel(delta));
teta=[0.001,0.5,1]*pi/2; 
[RR,Delta,Teta]=meshgrid(R,delta,teta);
tau_p=2*Const.ro_p.*RR.^2/(9*Const.nu*Const.ro_a);
P=1+Const.nu^(-1)*Const.g^2*tau_p.^3.*(sin(Teta)).^2-Const.nu*tau_p.*Delta.^(-2);
C=(4*pi)^(-2);
Amax=(0.5*C*P.*((1+4*Const.nu*tau_p./(P.^2.*Delta.^2)).^(1/2)-1)).^(1/2);
Amax=real(Amax).*(imag(Amax)==0);
Amax(Amax==0)=NaN;

figure(1)
set(gcf,'Position', [640, 300, 2*560, 2*420 ],...
    'paperunits','centimeters',...
    'Color',[1 1 1],...
    'papersize',[width,height],...
    'InvertHardCopy','off')
box on

switch opcja
    case 1
        plot=pcolor(Delta(:,:,ceil(numel(teta)/2))*10^2,RR(:,:,ceil(numel(teta)/2))*10^6,Amax(:,:,ceil(numel(teta)/2)));
        pp=colorbar;
        ylabel(pp,'$A_{max}$','interpreter','latex','FontSize',fsize)
        %shading interp
        hold on
        %contour(Delta*10^2,RR*10^6,Amax,[Const.Acr,Const.Acr],'--','ShowText','on','Color','k')
        text(2.152,19,'$\theta=\frac{\pi}{4}$','interpreter','latex','FontSize',fsize+4)
        set(plot,'EdgeColor','none')
        ylabel('$R [\mu m]$','interpreter','latex')
        xlabel('$\delta [cm]$','interpreter','latex')
        ylim([1 250])
        set(gca,'FontSize',fsize)
        hold off
    case 2
        leg=[];
        legdesc={};
        for k=1:numel(delta)
            x1=RR(k,:,1)*10^6;
            y1=Amax(k,:,1);
            y2=Amax(k,:,numel(teta));
            p=patch([x1,fliplr(x1)],[y1 fliplr(y2)],kolor(k,:));
            hold on
            plot(x1,y1,'Color',kolor(k,:))%*(1-j/numel(teta)))
            hold on
            plot(x1,y2,'Color',kolor(k,:));
            hold on
            leg=[leg,p];
            legdesc=[legdesc,num2str(Delta(k,1,1)*100)];
        end
        plot(x1,Const.Acr+zeros(size(x1)),'k--')
        xlabel('$R~[\mu m]$','interpreter','latex')
        ylabel('$A_{max}$','interpreter','latex')
        
        %ylim([1 20])
        set(gca,'FontSize',fsize)
        hold off
        grid on
        leghand=legend(leg,legdesc)
        title(leghand,'$\delta [cm]$','interpreter','latex')
    case 3
        for k=1:numel(delta)
            xplot=RR(k,:,1);
            yplot=Amax(k,:,1);
            fun = @(x)sseval(x,xplot,yplot);
            x0=[yplot(1)/xplot(1),0];
            [wyn,~,exitflag] = fminsearch(fun,x0);
            afit(k)=wyn(1);
        end
        plot(Delta(:,1,1).^(-1),afit)
        
end
function sse=sseval(x,xdata,ydata)
a=x(1);
b=x(2);
sse = sum((ydata - (a*xdata+b)).^2);
end