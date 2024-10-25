classdef RanimateTests< handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here

    properties (Constant)
        steps = 50;
        %%REPLACE WITH CAN STUFF
        rcaniPos = [0.8,0,0.625];
        rcaniMpos = [0.8,0,0.625];
        rcanfMpos = [0.165,0,0.625];
        rcanr2fMpos = [-0.75,0,0.7];
        rcanDropPos = [-0.75,0,0.4];

        mcartoniPos = [0.8,-0.2,0.715];
        
        
    end

    properties
        r;
        r2;
        redCan;
        redCanV;
        mcarton;
        mcartonV;
       

    end

    methods
        function self = RanimateTests()

            self.envCrea();
            self.r = Thor(transl(0.5,0,0.5)); 
            self.r2 = UR3e(transl(-0.4,0,0.5));
            self.moveTrash();
            % self.r2.model.teach();
            
            
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
            table = PlaceObject('tableBrownModified.ply');
            vertices = get(table,'Vertices');
            transformedVertices = [vertices,ones(size(vertices,1),1)] * transl(0.2,0,0)';
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
        
            % % Cone
            % Cone = PlaceObject('cone.ply'); 
            % ConeV = get(Cone,'Vertices');
            % transformedConeVertices = [ConeV,ones(size(ConeV,1),1)] * transl(-0.6,0,0.515)';
            % set(Cone,'Vertices',transformedConeVertices(:,1:3)); 
        
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




            %%Objects to be moved/Animated.
        
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
        
            % zlim([0, 3]); % limit the figure
            % xlim([-2, 2]);
            % ylim([-1.5, 1.5]);
        
            %Apple
            Apple = PlaceObject('Apple.ply'); 
            AppleV = get(Apple,'Vertices');
            transformedAppleVertices = [AppleV,ones(size(AppleV,1),1)] * transl(0.8,0.2,0.575)';
            set(Apple,'Vertices',transformedAppleVertices(:,1:3)); 
        
             

        end


        function moveTrash(self)

            %%Thor Transforms
            qr1start = self.r.model.getpos();

            % T1 = transl(self.rcaniMpos) * trotx(pi);
            T1 = transl(self.rcaniMpos) * trotx(pi); %"where red can is"
            q1=  self.r.model.ikcon(T1); %q1 = r.model.ikcon(T1);

            T2 = transl(self.rcanfMpos); %* trotx(pi) * trotz(pi/2);
            q2 = self.r.model.ikcon(T2); %"Where to place can for pick up

            T3 = transl((self.mcartoniPos) + [0.02,-0.02,0.03])* trotx(pi) * trotz(pi/2);
            q3=  self.r.model.ikcon(T3);


            %spawn to red can
            qMatrix1 = jtraj(qr1start,q1,self.steps);
            %drop off
            qMatrix2 = jtraj(q1,q2,self.steps);
            %to Mcarton
            qMatrix3 = jtraj(q2,q3,self.steps);

            

            %%UR3e Transforms.
            qr2start = self.r2.model.getpos();
            
            %0.165,0,0.625 [self.rcanfMpos] 
            %%0.02 offset (x axis) from the object origin will work.
            T1r2 = transl(self.rcanfMpos + [-0.02, 0, 0])* trotx(pi/2) * troty(pi/2); %"where red can is"
            q1r2=  self.r2.model.ikcon(T1r2, qr2start); %q1 = r.model.ikcon(T1);
            
            qr2Matrix1 = jtraj(qr2start,q1r2,self.steps);

            T2r2 = transl(self.rcanr2fMpos + [-0.02, 0, 0])* trotx(pi/2) * troty(pi/2); %
            q2r2=  self.r2.model.ikcon(T2r2, self.r2.model.getpos());

            qr2Matrix2 = jtraj(q1r2,q2r2,self.steps);


            %%Object Drop Transforms::
            T_start = transl(self.rcanr2fMpos);       % Initial Cartesian position
            T_end = transl(self.rcanDropPos); % Final Cartesian position
            T_trajectory = ctraj(T_start, T_end, self.steps);  % Cartesian trajectory for steps




            %%Animate Transofrms.

            %%Thor to Red Can
            for i = 1:self.steps
            self.r.model.animate(qMatrix1(i,:));
            drawnow();
            pause(0.02);
            end
            
            %Red Can placement THOR
            for i = 1:self.steps
                q1=  self.r.model.ikcon(T1, q1);
                qMatrix2 = jtraj(q1,q2,self.steps);
                self.r.model.animate(qMatrix2(i,:));

                tr = self.r.model.fkine(qMatrix2(i,:));
                tvredCanV = [self.redCanV,ones(size(self.redCanV,1),1)]* trotx(pi)  * tr.T'; %
                set(self.redCan,'Vertices',tvredCanV(:,1:3));
            
                drawnow();
                pause(0.02);
            end

            %%Thor to Carton + UR3e to Can.
            for i = 1:self.steps
            self.r.model.animate(qMatrix3(i,:)); %Thor to mcarton
            %%Ur3e movement:
            self.r2.model.animate(qr2Matrix1(i,:));
            q1r2=  self.r2.model.ikcon(T1r2, self.r2.model.getpos());
            qr2Matrix1 = jtraj(self.r2.model.getpos(),q1r2,self.steps);
            drawnow();
            pause(0.02);
            
            end

            %UR3e drop can off.
            for i = 1:self.steps
                q2r2=  self.r2.model.ikcon(T2r2, self.r2.model.getpos());
                qr2Matrix2 = jtraj(self.r2.model.getpos(),q2r2,self.steps);
                self.r2.model.animate(qr2Matrix2(i,:));
                

                tr = self.r2.model.fkine(qr2Matrix2(i,:));
                tvredCanV = [self.redCanV,ones(size(self.redCanV,1),1)]* trotx(pi/2) * troty(pi/2) * tr.T'; %
                set(self.redCan,'Vertices',tvredCanV(:,1:3));

                drawnow();
                pause(0.02);
            end
            %Can falling into bin
            for i = 1:self.steps
                % Update can's position based on the trajectory
                trCan = T_trajectory(:,:,i);  % Get the transformation at each step
                transformedRedCanVertices = [self.redCanV, ones(size(self.redCanV,1), 1)] * trCan';
                
                set(self.redCan, 'Vertices', transformedRedCanVertices(:, 1:3));  % Update can's position
                drawnow();
                pause(0.02);  % Adjust speed if needed
            end

            
            

        end


    end
   %
end