% =========================================================================
%               Analysis for simulation results under same data sample               
% =========================================================================

clc; clear; close all;

% Data set
data_str        = '2';  % 1. random ovm  2. manual ovm  3. homogeneous ovm
% Mix or not
mix             = 0;    % 0. all HDVs; 1. mix
% Type of the controller
controller_type = 1;    % 1. DeePC  2. MPC  3.SPC  4. SPC without Regulation
% Type for HDV car-following model
hdv_type        = 1;    % 1. OVM   2. IDM
% Uncertainty for HDV behavior
acel_noise      = 0.1;  % A white noise signal on HDV's original acceleration
% Head vehicle trajectory
ngsim_id_collected  = [2131,2067,1351,1336,1648,1469];
end_time_collected  = [62.6,56.9,49.1,50.0,65.9,64.8];

ngsim_i         = 6;
ngsim_id        = ngsim_id_collected(ngsim_i);
end_time        = end_time_collected(ngsim_i);


initialization_time = 30;
total_time          = initialization_time + end_time;  % Total Simulation Time
begin_time          = 30;

weight_v     = 1;        % weight coefficient for velocity error
weight_s     = 0.5;      % weight coefficient for spacing error   
weight_u     = 0.1;      % weight coefficient for control input

lambda_g     = 100;      % penalty on ||g||_2^2 in objective
lambda_y     = 1e4;      % penalty on ||sigma_y||_2^2 in objective

i_data          = 1;

if mix
    load(['_data\simulation_data\DeePC\ngsim_simulation\simulation_data',data_str,'_',num2str(i_data),'_ngsim_',num2str(ngsim_id),'_noiseLevel_',num2str(acel_noise),...
        '_hdvType_',num2str(hdv_type),'_lambdaG_',num2str(lambda_g),'_lambdaY_',num2str(lambda_y),'.mat']);
    controller_str = 'DeePC';
else % ngsim simulation
    load(['_data\simulation_data\HDV\ngsim_simulation\simulation_data',data_str,'_',num2str(i_data),'_ngsim_',num2str(ngsim_id),'_noiseLevel_',num2str(acel_noise),...
        '_hdvType_',num2str(hdv_type),'.mat']);
    controller_str = 'HDV';
    
end


n_vehicle   = length(ID);           % number of vehicles


% -------------------------------------------------------------------------
%   Plot Results
%--------------------------------------------------------------------------

figure;
plot(begin_time:Tstep:total_time,S(begin_time/Tstep:round(total_time/Tstep),1,2),'Color',[0.5,0.5,0.5]); hold on;
for i = 1:n_vehicle
   if ID(i) == 1
        plot(begin_time:Tstep:total_time,S(begin_time/Tstep:round(total_time/Tstep),i+1,2),'Color','r'); hold on; % line for velocity of CAVs
    else
        plot(begin_time:Tstep:total_time,S(begin_time/Tstep:round(total_time/Tstep),i+1,2),'Color','b'); hold on; % line for velocity of HDVs
    end 
end
grid on;
title(controller_str,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','fontsize',14);
set(gca,'XLim',[begin_time,total_time]);

set(gcf,'Position',[250 150 500 350]);
fig = gcf;
fig.PaperPositionMode = 'auto';

figure;

for i = 1:n_vehicle
   if ID(i) == 1
        plot(begin_time:Tstep:total_time,S(begin_time/Tstep:round(total_time/Tstep),i,1)-S(begin_time/Tstep:round(total_time/Tstep),i+1,1),'Color','r'); hold on; % line for velocity of CAVs
    else
        plot(begin_time:Tstep:total_time,S(begin_time/Tstep:round(total_time/Tstep),i,1)-S(begin_time/Tstep:round(total_time/Tstep),i+1,1),'Color','b'); hold on; % line for velocity of HDVs
    end 
end
grid on;
title(controller_str,'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex','fontsize',14);
set(gca,'XLim',[begin_time,total_time]);

set(gcf,'Position',[750 150 500 350]);
fig = gcf;
fig.PaperPositionMode = 'auto';
