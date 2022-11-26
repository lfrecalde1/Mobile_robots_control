%% Simulation fo the mobile Robot %%

% Clear variables
clc, clear all, close all;

% Time definition variables
t_s = 0.05;
t_final = 30;
t = (0:t_s:t_final);

% System Geometric Parameters
a = 0.2;

% Genearl vector parameters
L1 = [a];

% Initial conditions of the system
x_i = 0;
y_i = 0;
theta = 0*pi/180;
u_l = 0;
w = 0;

% Initial conditions of the system general vector
q = zeros(5, length(t)+1);

q(:, 1) = [x_i + a*cos(theta);...
           y_i + a*sin(theta);...
           theta;
           u_l;...
           w];

% Dynamic parameters
chi = [0.3037;0.2768;-0.0004018;0.9835;0.003818;1.0725];

% Robot mobile definitition
mobile_1 = mobile_robot_dynamic(L1, chi, q(:,1), t_s);

% Control Signal
u = [0.1*ones(1, length(t));...
       0*ones(1, length(t))];
   
% Derivative Kinematics 
up = [0*ones(1, length(t));...
      0*ones(1, length(t))];
   
[xd,yd,zd,psid,xdp,ydp,zdp,psidp] = Trajectory(t, t_s, 3);   
% Desired Trajectory
qd = [xd;...
      yd];
  
qdp = [xdp;...
       ydp];
 
% Control gains
K1 = 2*eye(2);
K2 = 1*eye(2);

% Controller Definition
controller = controller_robot(K1, K2, mobile_1);

% Loop Simulation
for k = 1:length(t)
    
    % error vector
    states = mobile_1.get_states();
    qe(:, k) = qd(:, k) - states(1:2);
    
    % Control Kinematics
    u(:, k) = controller.kinematic_controller(qd(:, k), qdp(:, k));
    
    % Derivative Desired
    if k > 1
        up(: ,k) = (u(:, k) - u(:, k-1))/t_s;
    else
        up(:, k) = [0;0];
    end
    
    u_ref(:, k ) = controller.Dynamic_controller(u(:, k), up(:, k));
    % System Evolution
    q(:, k+1) = mobile_1.system_f(u_ref(:, k));
end

largo = 0.4;
ancho = 0.3;
SIMULACION(a,largo,ancho,q(1,:),q(2,:),qd(1, :),qd(2, :),q(3, :),t_s);
% Save Data
save("Mobile_Dynamics_Compensation.mat", "t", "q", "u_ref", "qd", "qe", "t_s");
