%%
clear
close all
clc
delete(gcp('nocreate'))
tic

DIR ='/home/pracownicy/karpinska/Dokumenty/Praca_doktorska_analizy/Monodisperse_particles/';
spec='Results_dock_time/Initial_vel_fluid/';
loadDIR=[DIR spec];

% plot parameters
fsize=16;
width=16;
height=20;
skala=100;

%% Declare constants, load data
Const = Constants;
name='Dock_time_eps_00001_full.mat';
load([loadDIR name])

%% Grid data
X=AA;
Y=ST;
Z=reshape(texitt,size(X));

%% plot
close all
figure
set(gcf,'Position', [640, 300, 2*560, 2*420 ],...
    'paperunits','centimeters',...
    'papersize',[width,height],...
    'InvertHardCopy','off')

%% classic (A,St,log t_doc) surf plot
plot3(aa,16*pi^2*aa,zeros(1,numel(aa))+14,'Color',[0 0 0],'LineWidth',2)
%legend('St/A=16 \pi^2')
%hold on
%stem3(A,St,real(texit))%,'EdgeColor','none')
surf(X,Y,Z)
colormap(jet)
c=colorbar;
set(gca,'zscale','log')
set(gca,'ColorScale','log')

shading interp
xlabel('A')
ylabel('St')
ylim([0 1])
xlim([min(A) max(A)])
zlabel('t^+_{doc}')
c.Label.String='t^+_{doc}';
set(gca,'FontSize',fsize)
hold off

%% line plot



% (St/A,St,log t_doc) surf plot
% close all
% figure
% set(gcf,'Position', [640, 300, 2*560, 2*420 ],...
%     'paperunits','centimeters',...
%     'papersize',[width,height],...
%     'InvertHardCopy','off')
% 
% it=0;
%  for j=1:10:numel(St2(:,1))
%      it=it+1;
%      plot(St2(j,:)./(16*pi^2*A2(j,:)),real(texit2(j,:)))%,'Color',[it/numel(3:3:numel(A2(1,:))),1-it/numel(3:3:numel(A2(1,:))),0],'LineWidth',2)
%      leg{it}=num2str(St2(j,1));
%      hold on
%  end
% 
% 
% set(gca,'yscale','log')
% xlabel('St/A')
% ylabel('t_{doc}')
% set(gca,'FontSize',fsize)
% hold off



%% figure(1a)
% figure(2)
% kont=1:1000:300001;
% 
% contour(A2,St2,real(texit2),kont)
% colormap colorcube
% xlabel('A')
% ylabel('St')
% zlabel('t_{doc}')
% colorbar
% hold off

%% 
% figure(2) 
% close all
% figure
% set(gcf,'Position', [640, 300, 2*560, 2*420 ],...
%     'paperunits','centimeters',...
%     'papersize',[width,height],...
%     'InvertHardCopy','off')
% 
% it=0;
%  for j=3:3:numel(A2(1,:))
%      it=it+1;
%      plot(St2(:,j),real(texit2(:,j)),'Color',[it/numel(3:3:numel(A2(1,:))),1-it/numel(3:3:numel(A2(1,:))),0],'LineWidth',2)
%      leg{it}=num2str(A2(1,j));
%      hold on
%  end
%  set(gca,'yscale','log')
%  xlabel('St')
%  ylabel('t_{doc}')
%  set(gca,'FontSize',fsize)
%  ylim([3*10^2 10^7])
%  a=legend(leg);
%  a.Title.String='A';
%  a.Title.FontSize=fsize-2;
%  a.FontSize=fsize-6;
%  hold off

 % figure(2a) 
% close all
% figure
% set(gcf,'Position', [640, 300, 2*560, 2*420 ],...
%     'paperunits','centimeters',...
%     'papersize',[width,height],...
%     'InvertHardCopy','off')

% it=0;
% wybrane=1:4:numel(ST);
%  for j=wybrane
%      it=it+1;
%      rozn=(AA-ST(j)/(16*pi^2));
%      [val,~]=min(rozn(rozn>0));
%      k=find(rozn==val);
%      plot(A2(j,k:end),real(texit2(j,k:end)),'Color',[it/numel(wybrane),1-it/numel(wybrane),0],'LineWidth',2)
%      leg{it}=num2str(ST(j));
%      hold on
%  end
%  set(gca,'yscale','log')
%  set(gca,'xscale','log')
%  xlabel('A')
%  ylabel('t_{doc}')
%  set(gca,'FontSize',fsize)
%  xlim([10^(-4) 3*10^(-2)])
%  ylim([2*10^(2) 2*10^(5)])
%  a=legend(leg);
%  a.Title.String='St';
%  a.Title.FontSize=fsize-2;
%  a.FontSize=fsize-8;
%  hold off
 
 % figure(2b) 
% close all
% figure
% set(gcf,'Position', [640, 300, 2*560, 2*420 ],...
%     'paperunits','centimeters',...
%     'papersize',[width,height],...
%     'InvertHardCopy','off')
% 
% it=0;
% wybrane=2:4:numel(ST);
% for j=wybrane
%     rozn=(AA-ST(j)/(16*pi^2));
%     [val,~]=max(rozn(rozn<0));
%     if isempty(val)==0
%         it=it+1;
%         k=find(rozn==val);
%         plot(A2(j,1:k),real(texit2(j,1:k)),'Color',[it/numel(wybrane),1-it/numel(wybrane),0],'LineWidth',2)
%         leg{it}=num2str(ST(j));
%         hold on
%     end
% end
%  %set(gca,'yscale','log')
%  set(gca,'xscale','log')
%  xlabel('A')
%  ylabel('t_{doc}')
%  set(gca,'FontSize',fsize)
%  xlim([10^(-4) 7*10^(-3)])
%  ylim([0 2*10^(6)])
%  a=legend(leg);
%  a.Title.String='St';
%  a.Title.FontSize=fsize-2;
%  a.FontSize=fsize-8;
%  hold off
 
%% figure(3)
% it=0;
% for j=15:numel(A2(1,:))
%     it=it+1;
%     plot(St2(:,j),real(texit2(:,j))-exp(1)^2./A2(:,j),'Color',[it/numel(15:15:numel(A2(1,:))),0,0])
%     leg{2*it-1}=num2str(A2(1,j));
%     leg{2*it}=char('Fit');
%     hold on
%     fit=100*(-log(St2(:,j))+2).*St2(:,j).^(1)./A2(:,j); %./A2(:,j).^(1.5)
%     plot(St2(:,j),fit,'Color',[0,1-it/numel(15:15:numel(A2(1,:))),0] )
%     hold on
%     czyn(j)=real(texit2(end,j))/fit(end);
% end
% xlabel('St')
% ylabel('t_{ex}')
% legend(leg)
% hold off

% plot(St2(:,15),real(texit2(:,15))-exp(1)^2./A2(:,15),'Color',[1,0,0],'LineWidth',4)


%% figure(4)
% it=0;
% for j=1:10:numel(St2(:,1))
%     it=it+1;
%     plot(A2(j,15:end),real(texit2(j,15:end))-exp(1)^2./A2(j,15:end),'Color',[it/numel(1:10:numel(A2(:,1))), 0 ,1-it/numel(1:10:numel(A2(:,1)))])
%     leg{it}=num2str(St2(j,1));
%     hold on
% end
% xlabel('log A')
% ylabel('log t_{ex}')
% legend(leg)
% %fit=;
% %plot(A2(j,15:end),fit)
% hold off


%%  figure(5)
%  it=0;
%  for j=15:10:numel(A2(1,:))
%      it=it+1;
%  plot(log(St2(:,j)),log(real(texit2(:,j))),'Color',[it/numel(15:10:numel(A2(1,:))), 0 ,1-it/numel(15:10:numel(A2(1,:)))])
%  leg{it}=num2str(A2(1,j));
%  hold on
%  end
%  
% xlabel('log St')
%    ylabel('log t_{ex}')
%  legend(leg)
 
%   xlabel('A')
%   ylabel('St')
%   zlabel('t_{ex}')
%   colorbar

%% St/A
% clf
% figure(6)
% set(gcf,'Position', [640, 300, 2*560, 2*420 ],...
%      'paperunits','centimeters',...
%      'papersize',[width,height],...
%      'InvertHardCopy','off')
% par=(St./A);
% %-(exp(1)^2./A(2675:end))
% scatter(par(par>(16*pi^2)),A(par>(16*pi^2)).*texit(par>(16*pi^2))',25,A(par>(16*pi^2)))
% xlabel('St/A')
% set(gca, 'YScale', 'log')
% %ylim([3*10^3,5*10^6])
% ylabel('t_{doc 2}*A')
% c=colorbar;
% c.Title.String='A';
% set(gca,'FontSize',fsize)
% c.Title.FontSize=fsize-2;
% c.FontSize=fsize-5;

%hold on
%fit=log(1.1.^par(2675:end)); %
%scatter(par(2675:end),fit,25);%St(2675:end)/(max(St(2675:end))))

