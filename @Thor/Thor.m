classdef Thor < RobotBaseClass
    %% Thor on a non-standard linear rail created by a student

    properties(Access = public)              
        plyFileNameStem = 'Thor';
    end
    
    methods
%% Define robot Function 
        function self = Thor(baseTr)
			self.CreateModel();
            if nargin < 1			
				baseTr = eye(4);				
            end
            self.model.base = self.model.base.T * baseTr * trotx(pi/2) * troty(pi/2);
            
            self.PlotAndColourRobot();         
        end

%% Create the robot model
        function CreateModel(self)   
            % Create the Thor model
            %ALL LENGTH VALUES NEED TO BE FOUND.
            link(1) = Link([pi     0       0       pi/2    1]); % PRISMATIC Link
            link(2) = Link('d',0.202,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]), 'offset',0);
            link(3) = Link('d',0,'a',0.16,'alpha',0,'qlim', deg2rad([-360 360]), 'offset',0);
            link(4) = Link('d',0,'a',0,'alpha',pi/2,'qlim', deg2rad([-360 360]), 'offset', 0);
            link(5) = Link('d',0.195,'a',0,'alpha',-pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
            link(6) = Link('d',0,'a',0,'alpha',pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
            link(6) = Link('d',0,'a',0,'alpha',0,'qlim',deg2rad([-360,360]), 'offset',0);
           
            
            % Incorporate joint limits
            link(1).qlim = [-0.8 -0.01];
            link(2).qlim = [-180 180]*pi/180; 
            link(3).qlim = [-90 90]*pi/180; 
            link(4).qlim = [-170 170]*pi/180; 
            link(5).qlim = [-360 360]*pi/180; 
            link(6).qlim = [-360 360]*pi/180; 
            
        
            % link(3).offset = -pi/2;
            % link(5).offset = -pi/2;
            
            self.model = SerialLink(link,'name',self.name);
        end
     
    end
end