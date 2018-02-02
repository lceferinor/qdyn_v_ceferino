%sp = FSEM3D_snapshot(0);
%figure,scatter(sp.X,sp.Z,[],sp.Tz)

function [maxqdy,dtimelabel]=Plot_event_log(snap,snap0,units,cbar)
if nargin<2, cbar='off'; snap0=20001;units='s'; end
if nargin<3, cbar='off';units='s'; end
km=1000;
%snap=1015;
qdynfile=['fort.' num2str(snap)];
qdynfile0=['fort.' num2str(snap0)];

qdynsnap= Qdyn_read_ox_seq(qdynfile);
qdynsnap0= Qdyn_read_ox_seq(qdynfile0);
qdypar=qdynsnap.v;
maxqdy=max(qdynsnap.v);
%qdypar=qdynsnap.d;

fig=figure(1);scatter(qdynsnap.X/km,qdynsnap.Z/km,[],log(qdypar))

FigHandle = fig;
set(FigHandle, 'Position', [100, 100, 1000, 500]);

year = 3600*24*365;

dtime_second=qdynsnap.t-qdynsnap0.t;
dtime_year=(qdynsnap.t-qdynsnap0.t)/year;

if (units=='s')
title([num2str(dtime_second) ' seconds']);
dtimelabel=dtime_second;
end;
if (units=='y')
dtimelabel=dtime_year;
title([num2str(dtime_year) ' years']);
end;

if (strcmp(cbar,'on'))
c=colorbar;
c.Location ='eastoutside';
%c.Location ='northoutside';
c.Label.String = 'log(Slip velocity-m/s)';
%c.Label.String = 'Slip (m)';
end
%caxis([0 max(log(qdypar))])
%caxis([0 0.1]);
%caxis([0 0.01]);
%caxis([0 1]);

%axis equal
%axis tight
xlim([min(qdynsnap.X/km) max(qdynsnap.X/km)]);
ylim([min(qdynsnap.Z/km) max(qdynsnap.Z/km)])
xlabel('X (km)','FontSize',25)
ylabel('Z (km)','FontSize',25)
set(gca,'FontSize',25);
%set(h1,'PaperSize',[500 1500]);
%set(h1,'PaperSize',[500 1500]);
set(gcf,'color','w')
%figname=['fig_sliprate' num2str(snap)];
%print(figname,'-djpeg','-r300')




end

