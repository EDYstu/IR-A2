classdef UR3e < RobotBaseClass
    %% UR3e Universal Robot 3kg payload robot model
    %
    % WARNING: This model has been created by UTS students in the subject
    % 41013. No guarentee is made about the accuracy or correctness of the
    % of the DH parameters of the accompanying ply files. Do not assume
    % that this matches the real robot!

    properties(Access = public)   
        plyFileNameStem = 'UR3e';
    end
    
    methods
%% Constructor
        function self = UR3e(baseTr,useTool,toolFilename)
            if nargin < 3
                if nargin == 2
                    error('If you set useTool you must pass in the toolFilename as well');
                elseif nargin == 0 % Nothing passed
                    baseTr = transl(0,0,0);  
                end             
            else % All passed in 
                self.useTool = useTool;
                toolTrData = load([toolFilename,'.mat']);
                self.toolTr = toolTrData.tool;
                self.toolFilename = [toolFilename,'.ply'];
            end
          
            self.CreateModel();
			self.model.base = self.model.base.T * baseTr;
            self.model.tool = self.toolTr;
			warning('The DH parameters are correct. But as of July 2023 the ply files for this UR3e model are definitely incorrect, since we are using the UR3 ply files renamed as UR3e. Once replaced remove this warning.')  
            self.PlotAndColourRobot();

            drawnow
        end

%% CreateModel
        function CreateModel(self)
            link(1) = Link('d',0.15185,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]), 'offset',0);
            link(2) = Link('d',0,'a',-0.24355,'alpha',0,'qlim', deg2rad([-180 0]), 'offset',0);
            link(3) = Link('d',0,'a',-0.2132,'alpha',0,'qlim', deg2rad([-360 360]), 'offset', 0);
            link(4) = Link('d',0.13105,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
            link(5) = Link('d',0.08535,'a',0,'alpha',-pi/2,'qlim',deg2rad([-360 360]), 'offset',0);
            link(6) = Link('d',	0.0921,'a',0,'alpha',0,'qlim',deg2rad([-360 360]), 'offset', 0);
             
            self.model = SerialLink(link,'name',self.name);
        end      
    end
end
