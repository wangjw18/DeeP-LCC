% =========================================================================
%               Analysis for simulation results under same data sample               
% =========================================================================

clc; clear; close all;

% Data set
data_str         = '3';  % 1. random ovm  2. manual ovm  3. homogeneous ovm
% Mix or not
mix              = 0;    % 0. all HDVs; 1. mix
% Type of the controller
controller_type  = 1;    % 1. DeePC  2. MPC  3.SPC  4. SPC without Regulation
% Type for HDV car-following model
hdv_type         = 1;    % 1. OVM   2. IDM
% Uncertainty for HDV behavior
acel_noise       = 0.1;  % A white noise signal on HDV's original acceleration
% Perturbation amplitude
per_type         = 1;   % 1. sinuoid perturbation 2. brake perturbation 3. ngsim simulation
per_amp          = 5;
% Whether there exists constraints
constraint_bool  = 0;

% Simulation Time
begin_time       = 10;
end_time         = 40;              

i_data           = 1;     % Data set number

weight_v     = 1;        % weight coefficient for velocity error
weight_s     = 0.5;      % weight coefficient for spacing error   
weight_u     = 0.1;      % weight coefficient for control input

lambda_g     = 100;      % penalty on ||g||_2^2 in objective
lambda_y     = 1e4;      % penalty on ||sigma_y||_2^2 in objective



if mix
switch controller_type
    case 1
        if per_type ~= 3
            if constraint_bool
            load(['_data\simulation_data\DeePC\constrained_simulation\simulation_data',data_str,'_',num2str(i_data),'_perType_',num2str(per_type),'_noiseLevel_',num2str(acel_noise),...
                '_hdvType_',num2str(hdv_type),'_lambdaG_',num2str(lambda_g),'_lambdaY_',num2str(lambda_y),'.mat']);
            controller_str = 'DeePC';
        else
            load(['_data\simulation_data\DeePC\simulation_data',data_str,'_',num2str(i_data),'_perType_',num2str(per_type),'_noiseLevel_',num2str(acel_noise),...
                '_hdvType_',num2str(hdv_type),'_lambdaG_',num2str(lambda_g),'_lambdaY_',num2str(lambda_y),'.mat']);
            controller_str = 'DeePC';
        end
        else % ngsim simulation
            load(['_data\simulation_data\DeePC\ngsim_simulation\simulation_data',data_str,'_',num2str(i_data),'_ngsim_',ngsim_id,'_noiseLevel_',num2str(acel_noise),...
                '_hdvType_',num2str(hdv_type),'_lambdaG_',num2str(lambda_g),'_lambdaY_',num2str(lambda_y),'.mat']);
            controller_str = 'DeePC';
        end
    case 2
        load(['_data\simulation_data\MPC\simulation_data',data_str,'_',num2str(i_data),'_perType_',num2str(per_type),'_noiseLevel_',num2str(acel_noise),'_hdvType_1.mat']);
        controller_str = 'MPC';
    case 3
%         load(['_data\simulation_data\SPC\simulation_data2_',num2str(i_data),'_noiseLevel_',num2str(acel_noise),...
%             '_hdvType_',num2str(hdv_type),'_lambdaY_',num2str(lambda_y),'.mat']);
        load(['_data\simulation_data\SPC\simulation_data',data_str,'_',num2str(i_data),'_perturbationAmp_',num2str(per_amp),'_noiseLevel_',num2str(acel_noise),...
            '_hdvType_',num2str(hdv_type),'_lambdaY_',num2str(lambda_y),'.mat']);
        controller_str = 'SPC';
    case 4
        load(['_data\simulation_data\SPC_withoutRegulation\simulation_data',data_str,'_',num2str(i_data),'_perturbationAmp_',num2str(per_amp),'_noiseLevel_',num2str(acel_noise),...
            '_hdvType_',num2str(hdv_type),'_lambdaY_',num2str(lambda_y),'.mat']);
        controller_str = 'SPC without Regulation';
end
else
    if per_type ~= 3
        if constraint_bool
            load(['_data\simulation_data\HDV\constrained_simulation\simulation_data',data_str,'_',num2str(i_data),'_perType_',num2str(per_type),'_noiseLevel_',num2str(acel_noise),...
                '_hdvType_',num2str(hdv_type),'.mat']);
            controller_str = 'DeePC';
        else
            load(['_data\simulation_data\HDV\simulation_data',data_str,'_',num2str(i_data),'_perType_',num2str(per_type),'_noiseLevel_',num2str(acel_noise),...
                '_hdvType_',num2str(hdv_type),'.mat']);
            controller_str = 'DeePC';
        end
    else 
        load(['_data\simulation_data\HDV\simulation_data',data_str,'_',num2str(i_data),'_perType_',num2str(per_type),'_noiseLevel_',num2str(acel_noise),...
            '_hdvType_',num2str(hdv_type),'.mat']);
        controller_str = 'HDV';
    end
end


n_vehicle   = length(ID);           % number of vehicles
% if ~mix
%     ID(find(ID==1)) = 0;
% end

% -------------------------------------------------------------------------
%   Plot Results
%--------------------------------------------------------------------------
color_gray  = [190 190 190]/255;
color_red   = [244, 53, 124]/255;
color_blue  = [67, 121, 227]/255;
color_black = [0 0 0];
color_orange = [255,132,31]/255;
label_size  = 18;
total_size  = 14;
line_width  = 2;


% Velocity
figure;
id_cav = 1;
plot(begin_time:Tstep:end_time,S(begin_time/Tstep:end_time/Tstep,1,2),'Color',color_black,'linewidth',line_width-0.5); hold on;
for i = 1:n_vehicle
    if ID(i) == 0
        plot(begin_time:Tstep:end_time,S(begin_time/Tstep:end_time/Tstep,i+1,2),'Color',color_gray,'linewidth',line_width-0.5); hold on; % line for velocity of HDVs
    end
end
for i = 1:n_vehicle
    if ID(i) == 1
        if id_cav == 1
            plot(begin_time:Tstep:end_time,S(begin_time/Tstep:end_time/Tstep,i+1,2),'Color',color_red,'linewidth',line_width); hold on; % line for velocity of CAVs
            id_cav  = id_cav+1;
        elseif id_cav == 2
            plot(begin_time:Tstep:end_time,S(begin_time/Tstep:end_time/Tstep,i+1,2),'Color',color_blue,'linewidth',line_width); hold on; % line for velocity of CAVs
        end
    end 
end
grid on;
set(gca,'TickLabelInterpreter','latex','fontsize',total_size);
set(gca,'YLim',[4 26]);
set(gca,'XLim',[10 40]);

xl = xlabel('$t$ [$\mathrm{s}$]','fontsize',label_size,'Interpreter','latex','Color','k');
yl = ylabel('Velocity [$\mathrm{m/s}$]','fontsize',label_size,'Interpreter','latex','Color','k');

set(gcf,'Position',[250 150 400 300]);
fig = gcf;
fig.PaperPositionMode = 'auto';

if mix
    print(gcf,['.\figs\SinusoidPerturbation_VelocityProfile_Controller_',num2str(controller_type)],'-painters','-depsc2','-r300');
else
    print(gcf,'.\figs\SinusoidPerturbation_VelocityProfile_AllHDVs','-painters','-depsc2','-r300');    
end

% Spacing
% figure;
% for i = 1:n_vehicle
%     if ID(i) == 0
%         plot(begin_time:Tstep:end_time,S(begin_time/Tstep:end_time/Tstep,i,1)-S(begin_time/Tstep:end_time/Tstep,i+1,1),'Color',color_blue,'linewidth',line_width); hold on; % line for velocity of HDVs
%     end
% end
% for i = 1:n_vehicle
%     if ID(i) == 1
%         if id_cav == 1
%             plot(begin_time:Tstep:end_time,S(begin_time/Tstep:end_time/Tstep,i,1)-S(begin_time/Tstep:end_time/Tstep,i+1,1),'Color',color_red,'linewidth',line_width); hold on; % line for velocity of CAVs
%             id_cav  = id_cav+1;
%         elseif id_cav == 2
%             plot(begin_time:Tstep:end_time,S(begin_time/Tstep:end_time/Tstep,i,1)-S(begin_time/Tstep:end_time/Tstep,i+1,1),'Color',color_orange,'linewidth',line_width); hold on; % line for velocity of CAVs
%         end
%     end 
% end
% 
% grid on;
% set(gca,'TickLabelInterpreter','latex','fontsize',total_size);
% % set(gca,'YLim',[3 25]);
% 
% xl = xlabel('$t$ [$\mathrm{s}$]','fontsize',label_size,'Interpreter','latex','Color','k');
% yl = ylabel('Spacing [$\mathrm{m}$]','fontsize',label_size,'Interpreter','latex','Color','k');
% 
% set(gcf,'Position',[650 150 400 300]);
% fig = gcf;
% fig.PaperPositionMode = 'auto';