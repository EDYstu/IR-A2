classdef RanimateTests< handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here

    properties (Constant)
        steps = 50;
        %%REPLACE WITH CAN STUFF
        rcaniPos = [0.8,0,0.625];
        rcaniMpos = [0.8,0,0.625];
        rcanfMpos = [0.165,0,0.625];
        
        
    end

    properties
        r;
        redCan;
        redCanV;
       

    end

    methods
        function self = RanimateTests()

            self.envCrea();
            self.r = Thor(transl(0.5,0,0.5)); 
            self.moveTrash();
            
        end

        function envCrea(self)
            clc
            clf
            
    
            hold on
            axis equal
            % workspace = [-4 4 -4 4 -4 4]; 
            scale = 0.5;
            view(3)
    
            %Turn textures on
            camlight

            %table
            table = PlaceObject('tableBrown2.1x1.4x0.5m.ply');
            vertices = get(table,'Vertices');
            transformedVertices = [vertices,ones(size(vertices,1),1)] * transl(0,0,0)';
            set(table,'Vertices',transformedVertices(:,1:3));
                    
            %         %barriers
            % barrier1 = PlaceObject('fenceAssemblyGreenRectangle4x8x2.5m.ply');
            % vertices1 = get(barrier1,'Vertices');
            % transformedVertices1 = [vertices1,ones(size(vertices1,1),1)] * transl(0,1,-1)';
            % set(barrier1,'Vertices',transformedVertices1(:,1:3));
                    
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
            transformedsEstopVertices1 = [estopV,ones(size(estopV,1),1)] * trotx(-pi/2) *transl(0.8,0.6,0.55)';
            set(estop,'Vertices',transformedsEstopVertices1(:,1:3));
        
            %RedCan
            self.redCan = PlaceObject('soda can- 350ml.ply'); 
            self.redCanV = get(self.redCan,'Vertices');
            transformedRedCanVertices = [self.redCanV,ones(size(self.redCanV,1),1)] * transl(self.rcaniPos)';
            set(self.redCan,'Vertices',transformedRedCanVertices(:,1:3));
        
            %Milkcarton
            mcarton = PlaceObject('milkcarton.ply'); 
            mcartonV = get(mcarton,'Vertices');
            transformedmcartonVertices = [mcartonV,ones(size(mcartonV,1),1)] * transl(0.8,-0.2,0.715)';
            set(mcarton,'Vertices',transformedmcartonVertices(:,1:3)); %%Error upon this line
        
            % zlim([0, 3]); % limit the figure
            % xlim([-2, 2]);
            % ylim([-1.5, 1.5]);
        
            %Apple
            Apple = PlaceObject('Apple.ply'); 
            AppleV = get(Apple,'Vertices');
            transformedAppleVertices = [AppleV,ones(size(AppleV,1),1)] * transl(0.8,0.2,0.575)';
            set(Apple,'Vertices',transformedAppleVertices(:,1:3)); 
        
            %RedBin
            redBin = PlaceObject('RedDeskTrashBin.ply'); 
            redBinV = get(redBin,'Vertices');
            transformedRedBinVertices = [redBinV,ones(size(redBinV,1),1)]* trotz(pi/2) * transl(-1.2,0,0.5)';
            set(redBin,'Vertices',transformedRedBinVertices(:,1:3));
        
            %BlueBin
            BlueBin = PlaceObject('BlueDeskTrashBin.ply'); 
            BlueBinV = get(BlueBin,'Vertices');
            transformedBlueBinVertices = [BlueBinV,ones(size(BlueBinV,1),1)]* trotz(pi/2) * transl(-1.2,0.4,0.5)';
            set(BlueBin,'Vertices',transformedBlueBinVertices(:,1:3));
        
            %GreenBin
            GreenBin = PlaceObject('GreenDeskTrashBin.ply'); 
            GreenBinV = get(GreenBin,'Vertices');
            transformedGreenBinVertices = [GreenBinV,ones(size(GreenBinV,1),1)]* trotz(pi/2) * transl(-1.2,-0.4,0.5)';
            set(GreenBin,'Vertices',transformedGreenBinVertices(:,1:3));
        
            % % Cone
            % Cone = PlaceObject('cone.ply'); 
            % ConeV = get(Cone,'Vertices');
            % transformedConeVertices = [ConeV,ones(size(ConeV,1),1)] * transl(-0.6,0,0.515)';
            % set(Cone,'Vertices',transformedConeVertices(:,1:3)); 
        
            % LightCone
            LC = PlaceObject('updatedLC.ply'); 
            LCV = get(LC,'Vertices');
            LCVertices = [LCV,ones(size(LCV,1),1)]* trotz(pi) * transl(0,-1,0)';
            set(LC,'Vertices',LCVertices(:,1:3)); 
        
            % LightCone2
            LC2 = PlaceObject('updatedLC.ply'); 
            LC2V = get(LC2,'Vertices');
            LC2Vertices = [LC2V,ones(size(LC2V,1),1)] * transl(0,1,0)';
            set(LC2,'Vertices',LC2Vertices(:,1:3)); 

        end


        function moveTrash(self)
            qstart = self.r.model.getpos();

            % T1 = transl(self.rcaniMpos) * trotx(pi); %"where brick1 is"
            T1 = transl(self.rcaniMpos) * trotx(pi); %"where brick1 is"
            q1=  self.r.model.ikcon(T1); %q1 = r.model.ikcon(T1);

            %%TESTING SOMETHING
            T2 = transl(self.rcanfMpos); %* trotx(pi) * trotz(pi/2);
            q2 = self.r.model.ikcon(T2); %"Where to drop brick1



            %spawn to b1
            qMatrix1 = jtraj(qstart,q1,self.steps);
            %b1
            qMatrix2 = jtraj(q1,q2,self.steps);

            for i = 1:self.steps
            self.r.model.animate(qMatrix1(i,:));
            drawnow();
            pause(0.02);
            end
            
            %brick1 placement
            for i = 1:self.steps
                q1=  self.r.model.ikcon(T1, q1);
                qMatrix2 = jtraj(q1,q2,self.steps);
                self.r.model.animate(qMatrix2(i,:));
                % p2.base = r.model.fkine(qMatrix(i,:)).T;
                %p2.animate(0);
                %p2.plot(qz);
                tr = self.r.model.fkine(qMatrix2(i,:));
                tvbrick1 = [self.redCanV,ones(size(self.redCanV,1),1)]* trotx(pi)  * tr.T'; %
                set(self.redCan,'Vertices',tvbrick1(:,1:3));
            
                drawnow();
                pause(0.02);
            end
            

        end


    end
   %
end