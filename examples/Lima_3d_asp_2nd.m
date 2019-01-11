%%%%%%%% File for evaluating the earthquake rupture cycles in Lima %%%%%%%%
% Adapted from "test_3dfft.m": Prof. Ampuero, Dr. Galvez
% Modified on: 06/22/17
% By: Luis Ceferino
% Notes: same as 7.23, but changing the location of the northernmost
% asperity, so that the section 8 ruptures
% 7.25.1: p.A times 10, and p.DC times 10. It helps increasing the
% potential stress drop and keeping Lb and Linf controlled

clear;
clc;

%addpath ~/Documents/QDYN/qdyn_developer/src
addpath('/scratch/users/ceferino/qdyn_collaboration/src');
%addpath ~/qdyn-read-only/src 
%------------------------------
rand(1,floor(sum(100*clock)));
%------------------------------
year = 3600*24*365; % Should we put a longer timeframe? Would this timeline
                    % allow us to see the big events (Mw>8.5)?(Luis)
                    % PG: this is only a unit.

display('hola bb');
load('part1.mat');

clearvars -except p ox1 year;
twm=700; %Three parts         %warmup time in years (what is this? (Luis))

t_buf = 0;
p_next = p;
p_next.TMAX=twm*year;
p_next.SIGMA = ox1.sigma(:,end-t_buf)';
p_next.V_0 = ox1.v(:,end-t_buf)';
p_next.TH_0 = ox1.th(:,end-t_buf)';
display(ox1.t(end-t_buf));
clearvars -except p_next p t_buf;

[p_next,ot1_next,ox1_next]  = qdyn('run',p_next);


filename = ['LC_3D','L',num2str(p.L/1000.),'nx',num2str(p.NX),'W',num2str(p.W/1000.),'nw',num2str(p.NW),'.mat'];

save([filename,'part2only.mat'],'-v7.3');
save('part2.mat','p_next','ot1_next','ox1_next','-v7.3');

clearvars -except p_next ot1_next ox1_next t_buf;
load('part1.mat');
clearvars -except p_next ot1_next ox1_next p ox1 ot1 year t_buf;



%%% Time variable
steps1 = length(ot1.t) - t_buf;
steps2 = length(ot1_next.t);
steps_t = steps1+ steps2;

ot1.t(steps1+1:steps_t) = ot1_next.t+ot1.t(steps1);
ot1.locl(steps1+1:steps_t) = ot1_next.locl;
ot1.cl(steps1+1:steps_t) = ot1_next.cl;
ot1.p(steps1+1:steps_t) = ot1_next.p;
ot1.pdot(steps1+1:steps_t) = ot1_next.pdot;
ot1.vc(steps1+1:steps_t) = ot1_next.vc;
ot1.thc(steps1+1:steps_t) = ot1_next.thc;
ot1.omc(steps1+1:steps_t) = ot1_next.omc;
ot1.tauc(steps1+1:steps_t) = ot1_next.tauc;
ot1.dc(steps1+1:steps_t) = ot1_next.dc;
ot1.xm(steps1+1:steps_t) = ot1_next.xm;
ot1.v(steps1+1:steps_t) = ot1_next.v;
ot1.th(steps1+1:steps_t) = ot1_next.th;
ot1.om(steps1+1:steps_t) = ot1_next.om;
ot1.tau(steps1+1:steps_t) = ot1_next.tau;
ot1.d(steps1+1:steps_t) = ot1_next.d;
ot1.sigma(steps1+1:steps_t) = ot1_next.sigma;



%%% Space variable
steps1 = length(ox1.t) - t_buf;
steps2 = length(ox1_next.t);
steps_t = steps1+ steps2;


ox1.t(1,steps1+1:steps_t) = ox1_next.t+ot1.t(steps1);
ox1.v(:,steps1+1:steps_t) = ox1_next.v;
ox1.th(:,steps1+1:steps_t) = ox1_next.th;
ox1.vd(:,steps1+1:steps_t) = ox1_next.vd;
ox1.dtau(:,steps1+1:steps_t) = ox1_next.dtau;
ox1.dtaud(:,steps1+1:steps_t) = ox1_next.dtaud;
ox1.d(:,steps1+1:steps_t) = ox1_next.d;
ox1.sigma(:,steps1+1:steps_t) = ox1_next.sigma;

V_0 = ox1.v(:,end);
TH_0= ox1.th(:,end);


figure;
semilogy(ot1.t/year,ot1.v);
xlabel('Time (years)');
ylabel('Vmax');
saveas(gcf,'velocity_Lima.png');


save('part1-2both','p','ot1','ox1', 'V_0', 'TH_0','-v7.3');




