classdef Submission < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        %table Models Heights
        tableHeight = 0.54; 
        
        %adjustable brick starting locations
        brick1Location 
        brick2Location 
        brick3Location 
        brick4Location
        brick5Location
        brick6Location
        brick7Location
        brick8Location 
        brick9Location

        %brick model vertices
        brick1V;
        brick2V;
        brick3V;
        brick4V;
        brick5V;
        brick6V;
        brick7V;
        brick8V;
        brick9V; 
        
        %brick Models
        brick1;
        brick2;
        brick3;
        brick4;
        brick5;
        brick6;
        brick7;
        brick8;
        brick9;

            
        %DropOff Locations to form the wall
        dropOff1 = [-0.15, 0.3, 0.54];
        dropOff2 = [0, 0.3, 0.54];
        dropOff3 = [0.15, 0.3, 0.54];
        dropOff4 = [0.15, 0.3, 0.58];
        dropOff5 = [0, 0.3, 0.58];
        dropOff6 = [-0.15, 0.3, 0.58];
        dropOff9 = [-0.15, 0.3, 0.62];
        dropOff8 = [0, 0.3, 0.62];
        dropOff7 = [0.15, 0.3, 0.62];

        %robot
        r
    end

    methods 
        function self = Submission()
            clc
            clf

            %set the brick starting locations
            self.brick1Location = [-0.6, -0.4, self.tableHeight];
            self.brick2Location = [-0.45, -0.4, self.tableHeight];
            self.brick3Location = [-0.3, -0.4, self.tableHeight];
            self.brick4Location = [-0.15, -0.4, self.tableHeight];
            self.brick5Location = [0, -0.4, self.tableHeight];
            self.brick6Location = [0.15, -0.4, self.tableHeight];
            self.brick7Location = [0.3, -0.4, self.tableHeight];
            self.brick8Location = [0.45, -0.4, self.tableHeight];
            self.brick9Location = [0.45, -0.55, self.tableHeight];

			input('Press enter to begin')
			self.placeObjects(); %places all the objects in the enviorment
       
            self.r = LinearUR3e(transl(0.5,0,0.5)); %places the LinearUR3e on the table

            input('Press enter to begin pointCloud calculations')
            %self.pointCloud() %point cloud and volume calculation
            
            input('Press enter to begin moving')
            self.move() %movex brick to locations 
           
           

		end

        function placeObjects(self)
            hold on;
            grid on
            axis equal
            
            %Using the method from Tutorial 4

            %table
            table = PlaceObject('tableBrown2.1x1.4x0.5m.ply');
            vertices = get(table,'Vertices');
            transformedVertices = [vertices,ones(size(vertices,1),1)] * transl(0,0,0)';
            set(table,'Vertices',transformedVertices(:,1:3));
            
            %barriers
            %barrier1 = PlaceObject('fenceAssemblyGreenRectangle4x8x2.5m.ply');
           % vertices1 = get(barrier1,'Vertices');
           % transformedVertices1 = [vertices1,ones(size(vertices1,1),1)] * transl(0,1,-1)';
           % set(barrier1,'Vertices',transformedVertices1(:,1:3));
            
           % fireEx = PlaceObject('fireExtinguisher.ply');
           % verticesFire = get(fireEx,'Vertices');
           % transformedVerticesFire = [verticesFire,ones(size(verticesFire,1),1)] * transl(3,-1,0)';
           % set(fireEx,'Vertices',transformedVerticesFire(:,1:3));
            
            %person = PlaceObject('personMaleConstruction.ply');
           % verticesPerson = get(person,'Vertices');
            %transformedVerticesPerson = [verticesPerson,ones(size(verticesPerson,1),1)] * transl(3,0,0)';
           % set(person,'Vertices',transformedVerticesPerson(:,1:3));

            %estop
            estop = PlaceObject('emergencyStopWallMounted.ply'); %use the wall moutned one as its an appropriate scale
            estopV = get(estop,'Vertices');
            transformedsEstopVertices1 = [estopV,ones(size(estopV,1),1)] * trotx(-pi/2) *transl(0.8,0.6,0.55)';
            set(estop,'Vertices',transformedsEstopVertices1(:,1:3));
            
            %brick1
            self.brick1 = PlaceObject('HalfSizedRedGreenBrick.ply');
            self.brick1V = get(self.brick1,'Vertices');
            transformedsBrickVertices = [self.brick1V,ones(size(self.brick1V,1),1)] * trotz(-pi/2) * trotx(pi) * transl(self.brick1Location)'; %Rotated to be the correct orientation and location
            set(self.brick1,'Vertices',transformedsBrickVertices(:,1:3));
            
            %brick2
            self.brick2 = PlaceObject('HalfSizedRedGreenBrick.ply');
            self.brick2V = get(self.brick2,'Vertices');
            transformedsBrickVertices = [self.brick2V,ones(size(self.brick2V,1),1)] * trotz(-pi/2) * trotx(pi) * transl(self.brick2Location)';
            set(self.brick2,'Vertices',transformedsBrickVertices(:,1:3));
            
            %brick3
            self.brick3 = PlaceObject('HalfSizedRedGreenBrick.ply');
            self.brick3V = get(self.brick3,'Vertices');
            transformedsBrickVertices = [self.brick3V,ones(size(self.brick3V,1),1)] * trotz(-pi/2) * trotx(pi) *transl(self.brick3Location)';
            set(self.brick3,'Vertices',transformedsBrickVertices(:,1:3));
            
            %brick4
            self.brick4 = PlaceObject('HalfSizedRedGreenBrick.ply');
            self.brick4V = get(self.brick4,'Vertices');
            transformedsBrickVertices = [self.brick4V,ones(size(self.brick4V,1),1)] * trotz(-pi/2) * trotx(pi) *transl(self.brick4Location)';
            set(self.brick4,'Vertices',transformedsBrickVertices(:,1:3));
            
            %brick5
            self.brick5 = PlaceObject('HalfSizedRedGreenBrick.ply');
            self.brick5V = get(self.brick5,'Vertices');
            transformedsBrickVertices = [self.brick5V,ones(size(self.brick5V,1),1)] * trotz(-pi/2) * trotx(pi) *transl(self.brick5Location)';
            set(self.brick5,'Vertices',transformedsBrickVertices(:,1:3));
            
            
            %brick6
            self.brick6 = PlaceObject('HalfSizedRedGreenBrick.ply');
            self.brick6V = get(self.brick6,'Vertices');
            transformedsBrickVertices = [self.brick6V,ones(size(self.brick6V,1),1)] * trotz(-pi/2) * trotx(pi) *transl(self.brick6Location)';
            set(self.brick6,'Vertices',transformedsBrickVertices(:,1:3));
            
            
            %brick7
            self.brick7 = PlaceObject('HalfSizedRedGreenBrick.ply');
            self.brick7V = get(self.brick7,'Vertices');
            transformedsBrickVertices = [self.brick7V,ones(size(self.brick7V,1),1)] * trotz(-pi/2) * trotx(pi) *transl(self.brick7Location)';
            set(self.brick7,'Vertices',transformedsBrickVertices(:,1:3));
            
            
            %brick8
            self.brick8 = PlaceObject('HalfSizedRedGreenBrick.ply');
            self.brick8V = get(self.brick8,'Vertices');
            transformedsBrickVertices = [self.brick8V,ones(size(self.brick8V,1),1)] * trotz(-pi/2) * trotx(pi) *transl(self.brick8Location)';
            set(self.brick8,'Vertices',transformedsBrickVertices(:,1:3));
            
            
            %brick9
            self.brick9 = PlaceObject('HalfSizedRedGreenBrick.ply');
            self.brick9V = get(self.brick9,'Vertices');
            transformedsBrickVertices = [self.brick9V,ones(size(self.brick9V,1),1)] * trotz(-pi/2) * trotx(pi) *transl(self.brick9Location)';
            set(self.brick9,'Vertices',transformedsBrickVertices(:,1:3));

            zlim([0, 4]); % limit the figure
            xlim([-3, 3]);
            ylim([-3, 3]);

        end

        function pointCloud(self)

            % Wait for the user to press Enter
            input('Press Enter to continue...', 's');
            
            % Define parameters for point cloud generation
            stepRads = deg2rad(90);  % Step for revolute joints
            stepPrismatic = 0.1;    % Step size for the prismatic joint
            qlim = self.r.model.qlim; % Get joint limits
            
            
            pointCloud = [];
            counter = 1;

            % Generate point cloud
            for q1 = qlim(1,1):stepPrismatic:qlim(1,2)  % Prismatic joint q1 - 
                for q2 = qlim(2,1):stepRads:qlim(2,2)   % Revolute joint q2
                    for q3 = qlim(3,1):stepRads:qlim(3,2)  % Revolute joint q3
                        for q4 = qlim(4,1):stepRads:qlim(4,2)  % Revolute joint q4
                            for q5 = qlim(5,1):stepRads:qlim(5,2)  % Revolute joint q5
                                for q6 = qlim(6,1):stepRads:qlim(6,2)  % Revolute joint q6
                                    q7 = 0; % Joint 7 fixed at 0 as it does not affect point cloud
                                    q = [q1, q2, q3, q4, q5, q6, q7];  
                                    tr = self.r.model.fkineUTS(q);
                                    if tr(3, 4) >= 0.5 %filtering Z values below the table height
                                        pointCloud(counter, :) = tr(1:3, 4)';  % Save end-effector position/point
                                        counter = counter + 1;
                                    end

                                end
                            end
                        end
                    end
                end
            end
            
            hold on;
            cloud = plot3(pointCloud(:,1), pointCloud(:,2), pointCloud(:,3), 'r.');  % Plot the point cloud
            grid on;
            hold off;
            input("Click enter to show the volume of the Point cloud")

            % Compute the convex hull of the point cloud - 
            [K,V]= convhull(pointCloud(:,1), pointCloud(:,2), pointCloud(:,3));
        
            % Plot the convex hull
            hold on;
            conv = trisurf(K, pointCloud(:,1), pointCloud(:,2), pointCloud(:,3), 'FaceColor', 'magenta'); % plot it
            grid on;
            hold off;
        
        
            % Display the volume
            fprintf('The volume is %f meter cubed.\n', V);
            input("Click enter to clear Point cloud")
            delete(conv)
            delete(cloud); 
        end

        function move(self)

            steps = 50;

            %-----BRICK ONE MOVEMENT ----- 
            q = self.r.model.getpos();%get the current joint angles
            T2 = transl(self.brick1Location)* trotz(-pi/2)* trotx(pi); %calculate the target/goal matrix         
            q2 = self.r.model.ikcon(T2); %Calculate the joint angles for the goal based ont the target matrix
            qMatrix = jtraj(q,q2,steps); %generate a Q matrix

            %iterate over the Q matrix 
            for i = 1:steps
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            
            %Checking it reached the location based on the goal (brick
            %location) and the actual location of the end effector
            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.brick1Location); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)%Display the current T matrix for the end effector to check its locaiton
            
            %input('Press enter to continue')
            

            T2 = transl(self.dropOff1)* trotz(-pi/2)* trotx(pi);%calculate the target/goal matrix                                        
            q2 = self.r.model.ikcon(T2);  %Calculate the joint angles for the goal based ont the target matrix
            qMatrix = jtraj(q,q2,steps); %generate a Q matrix
            for i = 1:steps
                tr = self.r.model.fkine(qMatrix(i,:)); %generate the T matrix for the current pose
                transformedsBrickVertices = [self.brick1V,ones(size(self.brick1V,1),1)] * tr.T';%move vertices to the new location based on the endeffector 
                set(self.brick1,'Vertices',transformedsBrickVertices(:,1:3)); %move the brick to the current end effector pose
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.dropOff1); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)
            %input('Press enter to continue')

            %-----BRICK TWO MOVEMENT ----- 
            T2 = transl(self.brick2Location)*  trotz(-pi/2)* trotx(pi);                                           
            % Define a translation matrix            
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            
            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.brick2Location); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)
            %input('Press enter to continue')



            T2 = transl(self.dropOff2)* trotz(-pi/2) * trotx(pi);                                           
            % Define a translation matrix            
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                tr = self.r.model.fkine(qMatrix(i,:));
                transformedsBrickVertices = [self.brick2V,ones(size(self.brick2V,1),1)] * tr.T';
                set(self.brick2,'Vertices',transformedsBrickVertices(:,1:3));
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end

            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.dropOff2); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)
            %input('Press enter to continue')

             %-----BRICK THREE MOVEMENT ----- 

            T2 = transl(self.brick3Location)*  trotz(-pi/2)* trotx(pi);                                           
            % Define a translation matrix            
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.brick3Location); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)


            T2 = transl(self.dropOff3)* trotz(-pi/2) * trotx(pi);                                           
            % Define a translation matrix            
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                tr = self.r.model.fkine(qMatrix(i,:));
                transformedsBrickVertices = [self.brick3V,ones(size(self.brick3V,1),1)] * tr.T';
                set(self.brick3,'Vertices',transformedsBrickVertices(:,1:3));
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.dropOff3); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q);

            %-----BRICK FOUR MOVEMENT ----- 

            T2 = transl(self.brick4Location)*  trotz(-pi/2)* trotx(pi);                                           
            % Define a translation matrix            
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end

            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.brick4Location); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)
        
            T2 = transl(self.dropOff4)* trotz(-pi/2) * trotx(pi);                                                    
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                tr = self.r.model.fkine(qMatrix(i,:));
                transformedsBrickVertices = [self.brick4V,ones(size(self.brick4V,1),1)] * tr.T';
                set(self.brick4,'Vertices',transformedsBrickVertices(:,1:3));
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.dropOff4); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)

            %-----BRICK FIVE MOVEMENT ----- 

            T2 = transl(self.brick5Location)*  trotz(-pi/2)* trotx(pi);                                           
            % Define a translation matrix            
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.brick5Location); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)

            T2 = transl(self.dropOff5)* trotz(-pi/2) * trotx(pi);                                                   
            q2 = self.r.model.ikcon(T2);
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                tr = self.r.model.fkine(qMatrix(i,:));
                transformedsBrickVertices = [self.brick5V,ones(size(self.brick5V,1),1)] * tr.T';
                set(self.brick5,'Vertices',transformedsBrickVertices(:,1:3));
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end

            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.dropOff5); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)

            %-----BRICK SIX MOVEMENT ----- 
            T2 = transl(self.brick6Location)*  trotz(-pi/2)* trotx(pi); %rotate around X axis so that the point of refrence is on the top face (avoids endeffector going "UNDER")                                                      
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end

            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.brick6Location); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)


            T2 = transl(self.dropOff6)* trotz(-pi/2) * trotx(pi);                                           
            % Define a translation matrix            
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                tr = self.r.model.fkine(qMatrix(i,:));
                transformedsBrickVertices = [self.brick6V,ones(size(self.brick6V,1),1)] * tr.T';
                set(self.brick6,'Vertices',transformedsBrickVertices(:,1:3));
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end

            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.dropOff6); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)

            %-----BRICK SEVEN MOVEMENT ----- 

            T2 = transl(self.brick7Location)*  trotz(-pi/2)* trotx(pi); %rotate around X axis so that the point of refrence is on the top face (avoids endeffector going "UNDER")                                                      
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end

            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.brick7Location); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)


            T2 = transl(self.dropOff7)* trotz(-pi/2) * trotx(pi);                                           
            % Define a translation matrix            
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                tr = self.r.model.fkine(qMatrix(i,:));
                transformedsBrickVertices = [self.brick7V,ones(size(self.brick7V,1),1)] * tr.T';
                set(self.brick7,'Vertices',transformedsBrickVertices(:,1:3));
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.dropOff7); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)

            %-----BRICK EIGHT MOVEMENT ----- 
 
            T2 = transl(self.brick8Location)*  trotz(-pi/2)* trotx(pi); %rotate around X axis so that the point of refrence is on the top face (avoids endeffector going "UNDER")                                                      
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end

            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.brick8Location); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)


            T2 = transl(self.dropOff8)* trotz(-pi/2) * trotx(pi);                                           
            % Define a translation matrix            
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                tr = self.r.model.fkine(qMatrix(i,:));
                transformedsBrickVertices = [self.brick8V,ones(size(self.brick8V,1),1)] * tr.T';
                set(self.brick8,'Vertices',transformedsBrickVertices(:,1:3));
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.dropOff8); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q);

            %-----BRICK NINE MOVEMENT ----- 
            T2 = transl(self.brick9Location)*  trotz(-pi/2)* trotx(pi); %rotate around X axis so that the point of refrence is on the top face (avoids endeffector going "UNDER")                                                      
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end

            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.brick9Location); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)

            T2 = transl(self.dropOff9)* trotz(-pi/2) * trotx(pi);                                           
            % Define a translation matrix            
            q2 = self.r.model.ikcon(T2);  
            qMatrix = jtraj(q,q2,steps);
            for i = 1:steps
                tr = self.r.model.fkine(qMatrix(i,:));
                transformedsBrickVertices = [self.brick9V,ones(size(self.brick9V,1),1)] * tr.T';
                set(self.brick9,'Vertices',transformedsBrickVertices(:,1:3));
                self.r.model.animate(qMatrix(i, :));
                drawnow();   
                pause(0.01);
            end
            q = self.r.model.getpos();
            disp('Desired Position (end-effector):');
            disp(self.dropOff9); % Print x, y, z coordinates of the desired point
            T1 = self.r.model.fkine(q)
           
        end

    end
end