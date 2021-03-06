clear
close all
clc
delete(gcp('nocreate'))

%% Declare constants
C = Constants;
%% Load functions
fDIR='/home/pracownicy/karpinska/Dokumenty/Praca_doktorska_analizy/Monodisperse_particles/Functions/othercolor';
addpath(fDIR)

R=(1:0.5:25)*10^(-6);
tau_ps=(2*C.ro_p*R.^2)./(9*C.nu*C.ro_a);
deltas=(0.1:0.05:1)*10^(-2);
[tau_p,delta]=meshgrid(tau_ps,deltas);
k=(sqrt(1+(4*C.nu*tau_p./(delta.^2)))).^(-1);
tau_z=2*tau_p./(k.^(-1)-1); % tau_z
wykres=(tau_z-delta.^2/C.nu)./tau_z;
cd = othercolor('RdYlBu_11b',(numel(tau_ps)+1));% uint8(ones(numel(tau_ps),1))].';


figHandler = figure('Color',[1 1 1]);
width=16;
height=20;
fsize=18;
set(gcf,'Position', [300, 300, 2*560, 2.3*420 ],...
    'paperunits','centimeters',...
    'papersize',[width,height],...
    'InvertHardCopy','off')
%opengl software
skala=100;

for j=1:numel(deltas)

hln = patch([ones(numel(tau_ps),1)*deltas(j)*skala'; NaN], [wykres(j,:)'; NaN], [tau_z(j,:)'; NaN],'FaceVertexCData',cd,'FaceAlpha',1);
set(hln, 'edgecolor', 'interp','FaceColor','interp','LineWidth',8);

    hold on
end
colormap(cd)
h=colorbar;
xlabel('\delta[cm]')
ylabel('$(\tau_z-\tau_z^{\approx})/\tau_z$','interpreter','latex');
set(gca,'FontSize',fsize)
set(gca,'clim',[1, 25])
box on
grid on
ylabel(h, '$R [\mu m]$','interpreter','latex')
yyaxis right
plot(deltas*skala,C.nu^(-1)*deltas.^2,'--','LineWidth',3)
ylabel('$\tau_z$ [s]','interpreter','latex')

xlim([min(deltas)*skala, max(deltas)*skala])
% magnifyOnFigure(...
%         figHandler,...
%         'units', 'pixels',...
%         'initialPositionSecondaryAxes', [550 600 164.941 200],... %left bottom width hight
%         'initialPositionMagnifier',     [828.5 643 14.1164 20],...    
%         'displayLinkStyle', 'straight',...        
%         'edgeWidth', 2,...
%         'edgeColor', 'black',...
%         'secondaryAxesFaceColor', [0.91 0.91 0.91],... 
%         'secondaryAxesYLim', [9.600 ,9.750],...
%         'frozenZoomAspectRatio','off'...
%             ); 
 %'secondaryAxesXLim', [0.595, 0.605],...