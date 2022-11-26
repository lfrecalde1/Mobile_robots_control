%% PD Results

% clean variables of the system 
clc, clear all, close all;

% Load Data of the system
load("Mobile_Dynamics_Compensation.mat")

% Change dimentions in the variables
q_compensation = q(:, 1:end-1);
q_e_compensation = qe(:,:);
qe(:,end)
clear qe q;

load("Mobile_Dynamics.mat")
q_kinematics = q(:, 1:end-1);
q_e_kinematics = qe(:,:);

qe(:,end)
%Error Ise
xe_kinematics =  trapz(t_s,q_e_kinematics(1,:).^2);
ye_kinematics =  trapz(t_s,q_e_kinematics(2,:).^2);

xe_dynamics =  trapz(t_s,q_e_compensation(1,:).^2);
ye_dynamics =  trapz(t_s,q_e_compensation(2,:).^2);

ERROR = [xe_kinematics, xe_dynamics;...
         ye_kinematics, ye_dynamics];
% Colors and size of the letters
lw = 1.5; % linewidth 1
lwV = 2; % linewidth 2
fontsizeLabel = 11; %11
fontsizeLegend = 11;
fontsizeTicks = 11;
fontsizeTitel = 11;
sizeX = 1250; % size figure
sizeY = 550; % size figure

% color propreties
c1 = [80, 81, 79]/255;
c2 = [244, 213, 141]/255;
c3 = [242, 95, 92]/255;
c4 = [112, 141, 129]/255;

C18 = [0 0 0];

figure('Position', [500 500 sizeX sizeY])
set(gcf, 'Position', [500 500 sizeX sizeY]);
fig1_comps.fig = gcf;

x = [0:1:2];

axes('Position',[0.12 0.1 .5 .4]);

bar(ERROR);
legend({'$\textrm{Inverse Kinematics}$','$\textrm{Inverse Dynamics}$'},'fontsize',10,'interpreter','latex','Color',[255 255 255]/255,'TextColor','black')

set(gca,'ticklabelinterpreter','latex',...
        'fontsize',fontsizeTicks)
set(gca,'XTick',[1 2],'XTickLabel',{'$\tilde{x}$','$\tilde{y}$'});

hYLabel_1 = ylabel('$\textrm{ISE}$','fontsize',10,'interpreter','latex', 'Color',C18);

% Figure properties
ax_1 = gca;
ax_1.Box = 'on';
ax_1.BoxStyle = 'full';
ax_1.TickLength = [0.005;0.005];
ax_1.TickDirMode = 'auto';
ax_1.YMinorTick = 'on';
ax_1.XMinorTick = 'on';
% ax_2.XTickLabel = [];
ax_1.XMinorGrid = 'on';
ax_1.YMinorGrid = 'on';
%ax_2.MinorGridColor = '#8f8f8f';
ax_1.MinorGridAlpha = 0.15;
ax_1.YLabel = hYLabel_1;
ax_1.XLim = [0.8 4.2];
ax_1.LineWidth = 0.8;
set(gcf, 'Color', 'w'); % Sets axes background
export_fig Comparative_results.pdf -q101
