classdef FinalDemo < handle

    properties
        steps = 50;

        %table Models Heights
        tableHeight = 0.54; 
        
        %trash brick starting locations
        rcanIpos = [0.8,0,0.625];
        

        mcartoniPos = [0.8,-0.2,0.715];

        %middle location
        rcanMpos = [0.165,0,0.625];

        %DropOff Locations
        rcanFpos = [-0.75,0,0.7];

        %Disposal locations
        rcanDropPos = [-0.75,0,0.4];

        %trash model vertices
        redCanV;
        mcartonV;
        
        %trash Models
        redCan;
        mcarton;
           


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
            self.moveTrash() %movex brick to locations 
           
           

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
            transformedRedCanVertices = [self.redCanV,ones(size(self.redCanV,1),1)] * transl(self.rcanIpos)';
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


        




            scale = 0.5;
            view(3)

        end

        function moveTrash(self)

            %%Thor Transforms
            qr1start = self.thor.model.getpos();

            % T1 = transl(self.rcaniMpos) * trotx(pi);
            T1 = transl(self.rcanIpos) * trotx(pi); %"where red can is"
            q1=  self.thor.model.ikcon(T1); %q1 = r.model.ikcon(T1);

            T2 = transl(self.rcanMpos); %* trotx(pi) * trotz(pi/2);
            q2 = self.thor.model.ikcon(T2); %"Where to place can for pick up

            T3 = transl((self.mcartoniPos) + [0.02,-0.02,0.03])* trotx(pi) * trotz(pi/2);
            q3=  self.thor.model.ikcon(T3);


            %spawn to red can
            qMatrix1 = jtraj(qr1start,q1,self.steps);
            %drop off
            qMatrix2 = jtraj(q1,q2,self.steps);
            %to Mcarton
            qMatrix3 = jtraj(q2,q3,self.steps);

            

            %%UR3e Transforms.
            qr2start = self.ur3.model.getpos();
            
            %0.165,0,0.625 [self.rcanfMpos] 
            %%0.02 offset (x axis) from the object origin will work.
            T1r2 = transl(self.rcanMpos + [-0.02, 0, 0])* trotx(pi/2) * troty(pi/2); %"where red can is"
            q1r2=  self.ur3.model.ikcon(T1r2, qr2start); %q1 = r.model.ikcon(T1);
            
            qr2Matrix1 = jtraj(qr2start,q1r2,self.steps);

            T2r2 = transl(self.rcanFpos + [-0.02, 0, 0])* trotx(pi/2) * troty(pi/2); %
            q2r2=  self.ur3.model.ikcon(T2r2, self.ur3.model.getpos());

            qr2Matrix2 = jtraj(q1r2,q2r2,self.steps);


            %%Object Drop Transforms::
            T_start = transl(self.rcanFpos);       % Initial Cartesian position
            T_end = transl(self.rcanDropPos); % Final Cartesian position
            T_trajectory = ctraj(T_start, T_end, self.steps);  % Cartesian trajectory for steps




            %%Animate Transofrms.

            %%Thor to Red Can
            for i = 1:self.steps
            self.thor.model.animate(qMatrix1(i,:));
            drawnow();
            pause(0.02);
            end
            
            %Red Can placement THOR
            for i = 1:self.steps
                q1=  self.thor.model.ikcon(T1, q1);
                qMatrix2 = jtraj(q1,q2,self.steps);
                self.thor.model.animate(qMatrix2(i,:));

                tr = self.thor.model.fkine(qMatrix2(i,:));
                tvredCanV = [self.redCanV,ones(size(self.redCanV,1),1)]* trotx(pi)  * tr.T'; %
                set(self.redCan,'Vertices',tvredCanV(:,1:3));
            
                drawnow();
                pause(0.02);
            end

            %%Thor to Carton + UR3e to Can.
            for i = 1:self.steps
                self.thor.model.animate(qMatrix3(i,:)); %Thor to mcarton
                %%Ur3e movement:
                self.ur3.model.animate(qr2Matrix1(i,:));
                q1r2=  self.ur3.model.ikcon(T1r2, self.ur3.model.getpos());
                qr2Matrix1 = jtraj(self.ur3.model.getpos(),q1r2,self.steps);
                drawnow();
                pause(0.02);
            
            end

            %UR3e drop can off.
            for i = 1:self.steps
                q2r2=  self.ur3.model.ikcon(T2r2, self.ur3.model.getpos());
                qr2Matrix2 = jtraj(self.ur3.model.getpos(),q2r2,self.steps);
                self.ur3.model.animate(qr2Matrix2(i,:));
                

                tr = self.ur3.model.fkine(qr2Matrix2(i,:));
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
end