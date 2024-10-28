classdef FinalDemo < handle

    properties
        %table Models Heights
        tableHeight = 0.54; 
        
        %trash brick starting locations
        rcaniPos = [0.8,0,0.625];
        rcaniMpos = [0.8,0,0.625];
        rcanr2fMpos = [-0.75,0,0.7];
        rcanDropPos = [-0.75,0,0.4];

        mcartoniPos = [0.8,-0.2,0.715];

        %trash model vertices
        redCanV;
        mcartonV;
        
        %trash Models
        redCan;
        mcarton;
            
        %DropOff Locations
        rcanfMpos = [0.165,0,0.625];


        %robot
        thor
        ur3
    end

    methods 
        function self = FinalDemo()
            clc
            clf

            %set the brick starting locations
            %self.trash1Location = [-0.6, -0.4, self.tableHeight];

			input('Press enter to begin')
			self.placeObjects(); %places all the objects in the enviorment
       
            self.thor = Thor(transl(0.5,0,0.5)); 
            self.ur3 = UR3e(transl(-0.4,0,0.5));
            
            input('Press enter to begin moving')
            self.move() %movex brick to locations 
           
           

		end

        function placeObjects(self)
            hold on;
            grid on
            axis equal
            
            %Using the method from Tutorial 4
            %table
            table = PlaceObject('tableBrownModified.ply');
            vertices = get(table,'Vertices');
            transformedVertices = [vertices,ones(size(vertices,1),1)] * transl(0.2,0,0)';
            set(table,'Vertices',transformedVertices(:,1:3));

            fireEx = PlaceObject('fireExtinguisher.ply');
            verticesFire = get(fireEx,'Vertices');
            transformedVerticesFire = [verticesFire,ones(size(verticesFire,1),1)] * transl(2,-1,0)';
            set(fireEx,'Vertices',transformedVerticesFire(:,1:3));

            person = PlaceObject('personMaleConstruction.ply');
            verticesPerson = get(person,'Vertices');
            transformedVerticesPerson = [verticesPerson,ones(size(verticesPerson,1),1)]* trotz(pi) * transl(2,0,0)';
            set(person,'Vertices',transformedVerticesPerson(:,1:3));

                    %estop
            estop = PlaceObject('emergencyStopWallMounted.ply'); %use the wall moutned one as its an appropriate scale
            estopV = get(estop,'Vertices');
            transformedsEstopVertices1 = [estopV,ones(size(estopV,1),1)] * trotx(-pi/2) *transl(1.92,0.55,0.68)';
            set(estop,'Vertices',transformedsEstopVertices1(:,1:3));

            %Round Table for Estop
            rtable = PlaceObject('tableRoundModified.ply'); 
            rtableV = get(rtable,'Vertices');
            transformedrtableVertices = [rtableV,ones(size(rtableV,1),1)] * transl(2,0.5,0)';
            set(rtable,'Vertices',transformedrtableVertices(:,1:3));

            %RedBin
            redBin = PlaceObject('RedDeskTrashBin.ply'); 
            redBinV = get(redBin,'Vertices');
            transformedRedBinVertices = [redBinV,ones(size(redBinV,1),1)] * transl(-0.83,0,0.5)';
            set(redBin,'Vertices',transformedRedBinVertices(:,1:3));

            %BlueBin
            BlueBin = PlaceObject('BlueDeskTrashBin.ply'); 
            BlueBinV = get(BlueBin,'Vertices');
            transformedBlueBinVertices = [BlueBinV,ones(size(BlueBinV,1),1)] * transl(-0.83,0.2,0.5)';
            set(BlueBin,'Vertices',transformedBlueBinVertices(:,1:3));

            %GreenBin
            GreenBin = PlaceObject('GreenDeskTrashBin.ply'); 
            GreenBinV = get(GreenBin,'Vertices');
            transformedGreenBinVertices = [GreenBinV,ones(size(GreenBinV,1),1)]* transl(-0.83,-0.2,0.5)';
            set(GreenBin,'Vertices',transformedGreenBinVertices(:,1:3));

            % LightCone
            LC = PlaceObject('updatedLC.ply'); 
            LCV = get(LC,'Vertices');
            LCVertices = [LCV,ones(size(LCV,1),1)]* trotz(pi) * transl(1.1,-1,0)';
            set(LC,'Vertices',LCVertices(:,1:3)); 

            % LightCone2
            LC2 = PlaceObject('updatedLC.ply'); 
            LC2V = get(LC2,'Vertices');
            LC2Vertices = [LC2V,ones(size(LC2V,1),1)] * transl(1.1,1,0)';
            set(LC2,'Vertices',LC2Vertices(:,1:3));

            %RedCan
            self.redCan = PlaceObject('soda can- 350ml.ply'); 
            self.redCanV = get(self.redCan,'Vertices');
            transformedRedCanVertices = [self.redCanV,ones(size(self.redCanV,1),1)] * transl(self.rcaniPos)';
            set(self.redCan,'Vertices',transformedRedCanVertices(:,1:3));
        
            %Milkcarton
            self.mcarton = PlaceObject('milkcarton.ply'); 
            self.mcartonV = get(self.mcarton,'Vertices');
            transformedmcartonVertices = [self.mcartonV,ones(size(self.mcartonV,1),1)] * transl(self.mcartoniPos)';
            set(self.mcarton,'Vertices',transformedmcartonVertices(:,1:3)); %%Error upon this line

            %Apple
            Apple = PlaceObject('Apple.ply'); 
            AppleV = get(Apple,'Vertices');
            transformedAppleVertices = [AppleV,ones(size(AppleV,1),1)] * transl(0.8,0.2,0.575)';
            set(Apple,'Vertices',transformedAppleVertices(:,1:3)); 


        




            zlim([0, 4]); % limit the figure
            xlim([-5, 5]);
            ylim([-3, 3]);

        end

    end
end