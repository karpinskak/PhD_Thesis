clear
close all
clc
delete(gcp('nocreate'))
tic

%% Declare constants, load functions and data
DIR ='/home/pracownicy/karpinska/Dokumenty/Praca_doktorska_analizy/Monodisperse_particles/';
spec='Results_dock_time/Initial_vel_fluid/';
name='Dock_time_eps_00001_full.mat';
namesave='tau_d1_fit_r_notscal_eps_00001_full_no_b.mat';

loadDIR=[DIR spec];
Const = Constants;
fDIR=[DIR 'Functions/'];
addpath(fDIR)

load([loadDIR name])

%% choose type
n=1; %n=1:r, n=2: fi, n=3: r', n=4: fi'
typ=1;  % 0- z eps do r_orb
% 1- z r_s do eps,

dopas=3;
%
poolnr=14;

%% plot r' or fi'

switch typ
    case 1
        r0=1.58499;
    case 0
        r0=0;
end

wybor=[];
for p=1:numel(A)
    param(p)=part(p).par.A^(-1)*part(p).par.St;
    if abs(part(p).init.r0_bez-r0)<=eps && imag(texit(p))==0 && isnan(texit(p))==0
        wybor=[wybor,p];
    end
end
param_wyb=param(wybor);
parmax=max(param_wyb);

%parpool('local',poolnr)
%% calculate regression
for k=1:numel(wybor)
    
    xplot=part(wybor(k)).traj.t;
    yplot= part(wybor(k)).traj.X(:,n);
    % cutting off some false points
    
    if typ==1 && n==3
        [rad_vel_field,~,~]=velocity_field(part(wybor(k)).par.A,Const.rs-eps,0);
        
        yplot= yplot./rad_vel_field;
        options=optimset('MaxFunEvals',100000000);
        switch dopas
            case 1
                % 1) xplot=-a*log(yplot)+b
                fun = @(x)sseval2(x,yplot,xplot);
                x0=[part(wybor(k)).par.A/part(wybor(k)).par.St,0];
                [wyn,~,exitflag] = fminsearch(fun,x0,options);
                if exitflag==0
                    fun_param(k)=NaN;
                    wolny_param(k)=NaN;
                    Rsq(k)=NaN;
                else
                    fun_param(k)=wyn(1);
                    wolny_param(k)=wyn(2);
                    xplot2=-fun_param(k)*log(yplot)+wolny_param(k);
                    Rsq(k) = 1 - sum((xplot - xplot2).^2)/sum((xplot2 - mean(xplot2)).^2);
                end
            case 2
                % 2) yplot=a*exp(-xplot/b)+c
                fun = @(x)sseval3(x,xplot,yplot);
                x0=[1,part(wybor(k)).par.St/part(wybor(k)).par.A,0];
                [wyn,~,exitflag] = fminsearch(fun,x0,options);
                if exitflag==0
                    fun_param(k)=NaN;
                    mnoz_param(k)=NaN;
                    wolny_param(k)=NaN;
                    Rsq(k)=NaN;
                else
                    fun_param(k)=wyn(2);
                    mnoz_param(k)=wyn(1);
                    wolny_param(k)=wyn(3);
                    yplotlog2=wyn(1)*exp(-xplot/wyn(2))+wyn(3);
                    Rsq(k) = 1 - sum((yplot - yplotlog2).^2)/sum((yplotlog2 - mean(yplotlog2)).^2);
                end
            case 3
                %xplot=xplot/texitt(wybor(k));
                % obciecie zakresu dopasowania
                xplot(1:round(numel(xplot)/8))=[];
                yplot(1:round(numel(yplot)/8))=[];
                
                options=optimset('MaxFunEvals',10^10);
                fun = @(x)sseval2b(x,xplot,log(yplot));
                x0=-exp(2);
                [wyn,~,exitflag] = fminsearch(fun,x0,options);
                if exitflag==0
                    
                    fun_param(k)=NaN;
                    wolny_param(k)=NaN;
                    Rsq(k)=NaN;
                else
                    fun_param(k)=wyn(1);
                    if numel(wyn)>1
                        wolny_param(k)=wyn(2);
                    else
                        wolny_param(k)=0;
                    end
                    
                    yplotlog2=fun_param(k)*xplot+wolny_param(k);
                    Rsq(k) = 1 - sum((log(yplot) - yplotlog2).^2)/sum((yplotlog2 - mean(yplotlog2)).^2);
                end
        end
        
    elseif typ==1 && n==1
        %xplot=xplot/texitt(wybor(k));
        yplot= yplot/(Const.rs-eps);
        % obciecie zakresu dopasowania
        xplot(1:round(numel(xplot)/8))=[];
        yplot(1:round(numel(yplot)/8))=[];
        
        options=optimset('MaxFunEvals',10^10);
        %fun = @(x)sseval2(x,yplot,xplot);
        %fun = @(x)sseval2a(x,xplot,log(yplot));
        %x0=[-param_wyb(k),eps+param_wyb(k)];
        fun = @(x)sseval2b(x,xplot,log(yplot));
        x0=-exp(2);
        
        [wyn,~,exitflag] = fminsearch(fun,x0,options);
        if exitflag==0
            
            fun_param(k)=NaN;
            wolny_param(k)=NaN;
            Rsq(k)=NaN;
        else
            fun_param(k)=wyn(1);
            if numel(wyn)>1
                wolny_param(k)=wyn(2);
            else
                wolny_param(k)=0;
            end
            
            yplotlog2=fun_param(k)*xplot+wolny_param(k);
            Rsq(k) = 1 - sum((log(yplot) - yplotlog2).^2)/sum((yplotlog2 - mean(yplotlog2)).^2);
            % if you want to plot current fits and data fitted, uncomment this block
            %            %clf
            %             if mod(k,20)==0
            %             curfig=plot(xplot,log(yplot));
            %             hold on
            %             plot(xplot,yplotlog2,'--','Color',get(curfig,'Color'))
            %             %hold off
            %             %pause(0.5)
            %             end
        end
        
    end
    
end
delete(gcp('nocreate'))
toc
save([DIR 'Results_dock_approx/' namesave],'fun_param','wolny_param','Rsq','wybor','param_wyb','n','typ','dopas','name')
%% plot results

figure
fsize=16;
width=16;
height=20;
set(gcf,'Visible','on')
set(gcf,'Position', [640, 300, 2*560, 2*420 ],...
    'paperunits','centimeters',...
    'papersize',[width,height],...
    'InvertHardCopy','off')
 set(gca,'FontSize',fsize)

do_plot=(Rsq<=1).*(Rsq>0.5);
Awyb=A(wybor)';
Stwyb=St(wybor)';
figure(1)
texwyb=texitt(wybor);
scatter(param_wyb(do_plot==1),-fun_param(do_plot==1)./(Awyb(do_plot==1)),'k')
ylim([0 1.1])
grid on
xlabel('$St/A$','interpreter','latex')
ylabel('$a(St,A)/A$','interpreter','latex')
set(gca,'FontSize',fsize)
box on
%scatter(param_wyb(do_plot==1),-fun_param(do_plot==1)./texwyb(do_plot==1)./(Awyb(do_plot==1)))
%scatter(log(16*pi^2-param_wyb(do_plot==1)),log(-fun_param(do_plot==1)))
%scatter(param_wyb(do_plot==1),-fun_param(do_plot==1)./texwyb(do_plot==1)./(Stwyb(do_plot==1)./(16*pi^2)+Awyb(do_plot==1)))
%scatter(log(16*pi^2-param_wyb(do_plot==1)),log(Awyb(do_plot==1).*texwyb(do_plot==1)))
%scatter(log(16*pi^2-param_wyb(do_plot==1)),log(-fun_param(do_plot==1)./texwyb(do_plot==1)./(-16*pi^2*Stwyb(do_plot==1)./Awyb(do_plot==1)+1)))
%scatter(param_wyb(do_plot==1),-fun_param(do_plot==1)*exp(-7))
%scatter(16*pi^2-param_wyb(do_plot==1),-fun_param(do_plot==1)./texwyb(do_plot==1))
%xp=param_wyb(do_plot==1)/(16*pi^2);
%scatter(xp,(Awyb(do_plot==1).*texwyb(do_plot==1).*xp./(log(Const.rs/eps-1))).^(-1))





% subplot(3,3,1)
% scatter(param_wyb(do_plot==1),-fun_param(do_plot==1).*Awyb(do_plot==1))
% ylabel('*A')
% subplot(3,3,2)
% scatter(param_wyb(do_plot==1),-fun_param(do_plot==1).*Stwyb(do_plot==1))
% ylabel('*St')
% subplot(3,3,3)
% scatter(param_wyb(do_plot==1),-fun_param(do_plot==1))
% ylabel('*1')
% subplot(3,3,4)
% scatter(param_wyb(do_plot==1),-fun_param(do_plot==1)./Awyb(do_plot==1))
% ylabel('/A')
% subplot(3,3,5)
% scatter(param_wyb(do_plot==1),-fun_param(do_plot==1)./Stwyb(do_plot==1))
% ylabel('/St')
% subplot(3,3,6)
% scatter(param_wyb(do_plot==1),-fun_param(do_plot==1).*Stwyb(do_plot==1).*(Awyb(do_plot==1)))
% subplot(3,3,7)
% scatter(param_wyb(do_plot==1),-fun_param(do_plot==1).*Stwyb(do_plot==1)./Awyb(do_plot==1))
% ylabel('*St/A')
% subplot(3,3,8)
% scatter(param_wyb(do_plot==1),-fun_param(do_plot==1).*(Awyb(do_plot==1)./Stwyb(do_plot==1)).^(1))
% ylabel('*A/St')
% subplot(3,3,9)
% scatter(param_wyb(do_plot==1),-fun_param(do_plot==1)./Stwyb(do_plot==1)./Awyb(do_plot==1))


%% plot approximation
% figure
%
% for k=1:10:numel(wybor)
%     if Rsq(k)<=1 && Rsq(k)>0
%         xplot=part(wybor(k)).traj.t;
%         yplot= part(wybor(k)).traj.X(:,n);
%
%         if typ==0 && n==4
%             yplot=yplot/sqrt(param_wyb(k)^(-1));
%             xplot=xplot/texit(wybor(k));
%         elseif typ==1 && n==4
%             xplot=xplot/texit(wybor(k));
%         elseif typ==1 && n==3
%             [rad_vel_field,~,~]=velocity_field(part(wybor(k)).par.A,Const.rs-eps,0);
%             yplot= yplot./rad_vel_field;
%             %xplot=xplot./texit(wybor(k));
%
%             if dopas==1
%                 yplot2=unique(yplot);
%                 yplot2(yplot2<0)=[];
%                 xplot2=-fun_param(k)*log(yplot2)+wolny_param(k);
%
%             elseif dopas==2
%                 yplot2=mnoz_param(k)*exp(-xplot/fun_param(k))+wolny_param(k);
%                 xplot2=xplot;
%             end
%             plot(xplot,yplot,'Color',[param(wybor(k))/parmax 1-param(wybor(k))/parmax 0])
%             hold on
%             plot(xplot2,yplot2,'--','Color',[param(wybor(k))/parmax 1-param(wybor(k))/parmax 0],'Linewidth',3)
%             hold off
%             pause(0.5)
%             clf
%         elseif typ==0 && n==3
%             [rad_vel_field,~,~]=velocity_field(part(wybor(k)).par.A,part(wybor(k)).traj.X(:,1),0);
%             yplot= yplot./rad_vel_field;
%             xplot=xplot/texit(wybor(k));
%         elseif typ==1 && n==1
%             yplot= yplot/Const.rs;
%             % sseval2(x,yplot,xplot)-a*log(tdata))+b
%             xplot2=-fun_param(k)*log(yplot)+wolny_param(k);
%             %         plot(xplot,yplot,'Color',[param(p)/parmax 1-param(p)/parmax 0])
%             %         hold on
%             %         plot(xplot2,yplot,'Color','k')
%
%             plot(xplot,log(yplot),'Color',[param(p)/parmax 1-param(p)/parmax 0])
%             hold on
%             plot(xplot2,log(yplot),'Color','k')
%             pause(1)
%             clf
%         end
%     end
% end

function sse = sseval1(x,tdata,ydata)
a = x(1);
sse = sum((ydata - (-a*log(tdata))).^2);
end

function sse = sseval2(x,tdata,ydata)
a = x(1);
b = x(2);
sse = sum((ydata - (-a*log(tdata))+b).^2);
end

function sse = sseval2a(x,tdata,rdata)
a = x(1);
b = x(2);
sse = sum((rdata - (a*tdata+b)).^2);
end

function sse = sseval2b(x,tdata,rdata)
a = x(1);
sse = sum((rdata - (a*tdata)).^2);
end

function sse = sseval3(x,tdata,ydata)
a = x(1);
b = x(2);
c= x(3);
sse = sum((ydata - (a*exp(-tdata/b)+c)).^2);
end
%sse = sum((ydata - (a*log(b-d*tdata)+c)).^2);