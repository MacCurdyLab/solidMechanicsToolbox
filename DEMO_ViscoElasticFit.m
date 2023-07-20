%% Demo: Fitting ViscoElastic Model to Raw Data

clear; clc; close all

%import raw data
load dependencies/RawUniaxialData.mat

%visualize raw data from ramp-hold-ramp to failure test
plot(t(1:t1i),S(1:t1i),'linewidth',2,'displayname','Ramp'); hold on
plot(t(t1i:t2i),S(t1i:t2i),'linewidth',2,'displayname','Hold'); hold on
plot(t(t2i:end),S(t2i:end),'linewidth',2,'displayname','Ramp'); hold on
legend('location','northwest')
set(gca,'fontsize',16)

%create decimated datasets for fitting
time = linspace(0,t(end),80);
strain = interp1(t,s,time);
stress = interp1(t,S,time);

plot(time,stress,'k.','markersize',10); hold on
plot(time)