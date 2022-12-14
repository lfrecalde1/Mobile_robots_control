classdef controller_robot < matlab.mixin.SetGet
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Controller parameters
        K1
        K2
        
        % Robot system
        Robot
        
    end
    
    methods
        function obj = controller_robot(k1, k2, robot)
            
            % Propierties definition of the controller
            obj.K1 = k1;
            obj.K2 = k2;
            
            % Robot system
            obj.Robot = robot;
            
        end
        
        function xe = get_error(obj, xd)
           x = obj.Robot.get_states();
           xe = xd - x(1:2);
        end
        
        function ve = get_velocity_error(obj, vd)
            x = obj.Robot.get_states();
            v = x(4:5);
            ve = vd - v;
            
        end
        
        function u = kinematic_controller(obj, xd, xdp)
            
            % Get Jacobian Matrix
            J =  obj.Robot.get_J_matrix_control();
            v = obj.get_operator(xd, xdp);
            u = inv(J)*(v);
        end
        
        function u = Dynamic_controller(obj, vd, vdp)
            
            % Get Jacobian Matrix
            M =  obj.Robot.get_M_matrix();
            C = obj.Robot.get_C_matrix();
            v = obj.get_operator_velocity(vd, vdp);
            u = M*v + C;
        end
        
        
        function v = get_operator(obj, xd, xdp)
           
           % Auxiliar signal
           xe = obj.get_error(xd);
           v =  (xdp + obj.K2*tanh(inv(obj.K2)*obj.K1*xe));
        end
        
         function v = get_operator_velocity(obj, vd, vdp)
           
           % Auxiliar signal
           ve = obj.get_velocity_error(vd);
           v =  (vdp + obj.K2*tanh(inv(obj.K2)*obj.K1*ve));
        end
        
    end
    
end