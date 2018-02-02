clc;
clear;
name='Dc005to007_QDYN_cmp_revt';
name2='run1';

year = 365*24*3600;

iplot = [1431:5:1500];
% iplot = 20001;

iskip=1;       % # ponits skipped while plotting
i_time_r = 1 ;  %plot time relative to first plot
icaxis_const=1; % 1 for constant caxis of slip rate  
vmin=1e-15;
vmax=0.1;        %m/s
icaxis_const_d=1; % 1 for constant caxis of slip
dmin=0;
dmax=8;        %m
icaxis_d_auto=1;    % =1 for auto setting dmax

X_int_plot = 200;   %plotting interval for X in m
Z_int_plot = 200;   %plotting interval for Z in m


i_gif = 1; % =1 to plot gif

iend_auto=0;        %=1 for auto end plotting while vmax< vth_plot;
vth_plot=0.001;     %m/s

iaxis_equal=1;	% 1 for equal axis  
% vvmin=0;  %min (v)
% vvmax=2;   %max (v)
% ddmin=0;  %min slip
% ddmax=60;   %max slip
fps=12;  %framerate for movie, FPS
ppw=1200;    %figure width
pph=200;    %figure height

if i_time_r == 1
    d = Qdyn_read_ox_seq(['fort.' num2str(iplot(1))]);
    tt0 = d.t;
end



isnap=max(iplot);
display(['Processsing Snapshot # ', num2str(isnap),'...']);
d = Qdyn_read_ox_seq(['fort.' num2str(isnap)]);

if icaxis_d_auto == 1
    dmax=max(d.d);
end 

[XR,ZR] = meshgrid(min(d.X):X_int_plot:max(d.X),min(d.Z):Z_int_plot:max(d.Z));

h1=figure(1);
set(h1,'Position',[100 100 ppw pph])
set(h1,'Color',[1 1 1]);
DxR = griddata(d.X,d.Z,d.d,XR,ZR);
contourf(XR/1000,ZR/1000,DxR,40,'LineStyle','none');colorbar;
if iaxis_equal == 1
    axis equal;
end
axis tight;
if icaxis_const_d == 1
    caxis([dmin dmax]);
end
set(gca,'FontSize',16);
title('Slip (m)','FontSize',16);
xlabel('Along-strike: (km)','FontSize',16);
ylabel('Along-dip: (km)','FontSize',16);
 if i_time_r == 1
        text(max(d.X)/1000,min(d.Z)/1000,['time = ', num2str(d.t-tt0,'%15.1f'),'s'],...
          'color','White','HorizontalAlignment','Right','VerticalAlignment','Bottom','FontSize',16); 
    else
        text(max(d.X)/1000,min(d.Z)/1000,['time = ', num2str(d.t/year,'%15.5f'),' Years'],...
          'color','White','HorizontalAlignment','Right','VerticalAlignment','Bottom','FontSize',16);
 end
 clf(h1);
  
h2=figure(2);
set(h2,'Position',[100 300+pph ppw pph])
set(h2,'Color',[1 1 1]);
VxR = griddata(d.X,d.Z,d.v,XR,ZR);
contourf(XR/1000,ZR/1000,log10(VxR),40,'LineStyle','none');colorbar;
if iaxis_equal == 1
    axis equal;
end
axis tight;
if icaxis_const == 1
    caxis([log10(vmin) log10(vmax)]);
end
set(gca,'FontSize',16);
title('Log10 slip rate (m/s)','FontSize',16);
xlabel('Along-strike: (km)','FontSize',16);
ylabel('Along-dip: (km)','FontSize',16);
 if i_time_r == 1
        text(max(d.X)/1000,min(d.Z)/1000,['time = ', num2str(d.t-tt0,'%15.1f'),'s'],...
          'color','White','HorizontalAlignment','Right','VerticalAlignment','Bottom','FontSize',16); 
    else
        text(max(d.X)/1000,min(d.Z)/1000,['time = ', num2str(d.t/year,'%15.5f'),' Years'],...
          'color','White','HorizontalAlignment','Right','VerticalAlignment','Bottom','FontSize',16);
    end 
clf(h2);  
 

ifm=0;



for iii = 1:1:numel(iplot)
     
    isnap = iplot(iii);

    display(['Processsing Snapshot # ', num2str(isnap),'...']);
    d = Qdyn_read_ox_seq(['fort.' num2str(isnap)]);
   
    if (iend_auto ==1) && (max(d.v) <= vth_plot) && (isnap > 10)
        disp(['Event end at t = ', num2str(d.t/year,'%15.5f'),' Years', '  Snapshot # ', num2str(isnap)]);
        break
    end
    
    ifm=ifm+1;  

    h1=figure(1);
    set(h1,'Position',[100 100 ppw pph])
    set(h1,'Color',[1 1 1]);
    DxR = griddata(d.X,d.Z,d.d,XR,ZR);
    contourf(XR/1000,ZR/1000,DxR,40,'LineStyle','none');colorbar;    
    if iaxis_equal == 1
        axis equal;
    end
    axis tight;
    if icaxis_const_d == 1
        caxis([dmin dmax]);
    end
    set(gca,'FontSize',16);
    title('Slip (m)','FontSize',16);
    xlabel('Along-strike: (km)','FontSize',16);
    ylabel('Along-dip: (km)','FontSize',16);
    if i_time_r == 1
        text(max(d.X)/1000,min(d.Z)/1000,['time = ', num2str(d.t-tt0,'%15.1f'),'s'],...
          'color','White','HorizontalAlignment','Right','VerticalAlignment','Bottom','FontSize',16); 
    else
        text(max(d.X)/1000,min(d.Z)/1000,['time = ', num2str(d.t/year,'%15.5f'),' Years'],...
          'color','White','HorizontalAlignment','Right','VerticalAlignment','Bottom','FontSize',16);
    end
    fD=getframe(h1);
    imwrite(fD.cdata,['D_',name,name2,'_',num2str(isnap), '.jpg'],'jpg');    
    frameD(ifm)=fD;
    clf(h1); 

    h2=figure(2);
    set(h2,'Position',[100 300+pph ppw pph])
    set(h2,'Color',[1 1 1]);
    VxR = griddata(d.X,d.Z,d.v,XR,ZR);
    contourf(XR/1000,ZR/1000,log10(VxR),40,'LineStyle','none');colorbar;
    
    if iaxis_equal == 1
        axis equal;
    end
    axis tight;
    if icaxis_const == 1
        caxis([log10(vmin) log10(vmax)]);
    end
    set(gca,'FontSize',16);
    title('Log10 slip rate (m/s)','FontSize',16);
    xlabel('Along-strike: (km)','FontSize',16);
    if i_time_r == 1
        text(max(d.X)/1000,min(d.Z)/1000,['time = ', num2str(d.t-tt0,'%15.1f'),'s'],...
          'color','White','HorizontalAlignment','Right','VerticalAlignment','Bottom','FontSize',16); 
    else
        text(max(d.X)/1000,min(d.Z)/1000,['time = ', num2str(d.t/year,'%15.5f'),' Years'],...
          'color','White','HorizontalAlignment','Right','VerticalAlignment','Bottom','FontSize',16);
    end
%    print(h2,'-djpeg',['V_',name,name2,'_',num2str(isnap), '.jpg']);
%    print(h2,'-depsc2', ['V_',name,name2,'_',num2str(isnap), '.eps']);
    fV=getframe(h2);
    imwrite(fV.cdata,['V_',name,name2,'_',num2str(isnap), '.jpg'],'jpg');    
    frameV(ifm)=fV;
    clf(h2); 

end

if i_gif ==1
    writegif('V.gif',frameV,1/fps);
    writegif('V_d.gif',frameV(1:ceil(numel(frameV)/240):end),1/12);
    writegif('D.gif',frameD,1/fps);
    writegif('D_d.gif',frameD(1:ceil(numel(frameD)/240):end),1/12);
end
