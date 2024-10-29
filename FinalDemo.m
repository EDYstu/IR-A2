classdef FinalDemo < handle

    properties
        steps = 50;

        %table Models Heights
        tableHeight = 0.54; 
        
        %trash brick starting locations
        rcanIpos = [0.8,0,0.625];
        

        mcartonIPos = [0.8,-0.2,0.715];

        appleIpos = [0.8,0.2,0.575];

        %middle location
        rcanMpos = [0.165,0,0.625];
        mcartonMpos = [0.160,-0.1,0.715];

        appleMpos = [0.165,0.2,0.527];

        %DropOff Locations
        rcanFpos = [-0.75,0,0.7];
        mcartonFpos = [-0.75,0.2,0.7];
        appleFpos = [-0.75,-0.2,0.7];

        %Disposal locations
        rcanDropPos = [-0.75,0.05,0.4];
        mcartonDropPos = [-0.75,0.2,0.4];
        appleDropPos = [-0.75,-0.2,0.4];

        %trash model vertices
        redCanV;
        mcartonV;
        AppleV;
        
        %trash Models
        redCan;
        mcarton;
        Apple;

        person
        personV

        %Safety Flag & Physical Estop
        SafetyFlag = false;
        resumeFlag = false;
        buttonPressed = false;
        waitingForResume = false;
        currentStep = 1;                 % Track the current animation step for estop to resume

        %% Arduino Button Setup
        % port = 'COM6';
        % buttonPin = 'D2';
        % a = arduino('COM6', 'Uno');
        % debounceDelay = 0.05; % 50 ms debounce delay
        


        %robot
        thor
        ur3
    end

    methods 
        function self = FinalDemo()
            clc
            clf

            %self.trash1Location = [-0.6, -0.4, self.tableHeight];
            %configurePin(self.a, self.buttonPin, 'DigitalInput');
            % Timer for monitoring the e-stop button
            % t = timer('ExecutionMode', 'fixedRate', 'Period', 0.1, ...
            %           'TimerFcn', @(~,~)self.checkEmergencyStop());  % Call checkEmergencyStop as a method of self
            % 
            % start(t);
           

		end

        function placeObjects(self)
            hold on;
            grid on
            axis equal
            
            %Using the method from Tutorial 4
            %Textures floor:
            floortxtrsz = 2;
            negfloortxtrsz = -2;
            surf([negfloortxtrsz,negfloortxtrsz;floortxtrsz,floortxtrsz] ...
            ,[negfloortxtrsz,floortxtrsz;negfloortxtrsz,floortxtrsz] ...
            ,[0.01,0.01;0.01,0.01] ...
            ,'CData',imread('concrete.jpg') ...
            ,'FaceColor','texturemap');

            %table
            table = PlaceObject('tableBrownModified.ply');
            vertices = get(table,'Vertices');
            transformedVertices = [vertices,ones(size(vertices,1),1)] * transl(0.2,0,0)';
            set(table,'Vertices',transformedVertices(:,1:3));

            fireEx = PlaceObject('fireExtinguisher.ply');
            verticesFire = get(fireEx,'Vertices');
            transformedVerticesFire = [verticesFire,ones(size(verticesFire,1),1)] * transl(2,-1,0)';
            set(fireEx,'Vertices',transformedVerticesFire(:,1:3));

            self.person = PlaceObject('personMaleConstruction.ply');
            self.personV = get(self.person,'Vertices');
            transformedVerticesPerson = [self.personV,ones(size(self.personV,1),1)]* trotz(pi) * transl(2,0,0)';
            set(self.person,'Vertices',transformedVerticesPerson(:,1:3));

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
            transformedmcartonVertices = [self.mcartonV,ones(size(self.mcartonV,1),1)] * transl(self.mcartonIPos)';
            set(self.mcarton,'Vertices',transformedmcartonVertices(:,1:3)); %%Error upon this line

            %Apple
            self.Apple = PlaceObject('Apple.ply'); 
            self.AppleV = get(self.Apple,'Vertices');
            transformedAppleVertices = [self.AppleV,ones(size(self.AppleV,1),1)] * transl(0.8,0.2,0.575)';
            set(self.Apple,'Vertices',transformedAppleVertices(:,1:3)); 


            self.thor = Thor(transl(0.5,0,0.5)); 
            self.ur3 = UR3e(transl(-0.4,0,0.5));


            view(3)

        end

        function teach(self, jointAngles)

            % Ensure the input is valid (6 joints for a 6-DOF robot)
            if length(jointAngles) == 6
                % Use inverse kinematics to compute the new positions
                q = self.thor.model.ikcon(self.thor.model.fkine(jointAngles)); 

                % Animate the robot to the new joint configuration
                self.thor.model.animate(q);
            end
        end

        function moveTrash(self)

            %Generate Q matrix for the Thor robot for the first movement
            qr1start = self.thor.model.getpos();

            T1 = transl(self.rcanIpos) * trotx(pi); %"where red can is"
            q1=  self.thor.model.ikcon(T1); 

            qMatrix1 = jtraj(qr1start,q1,self.steps);

            %%Thor to Red Can
            for i = 1:self.steps
                if self.SafetyFlag == false
                    self.thor.model.animate(qMatrix1(i,:));
                    drawnow();
                    pause(0.02);
                elseif self.SafetyFlag == true
                    input("press enter to reset system")
                     
                end
            end
            
            T2 = transl(self.rcanMpos); %* trotx(pi) * trotz(pi/2);
            q2 = self.thor.model.ikcon(T2); %"Where to place can for pick up

            %%can Drop Transforms:
            T_start = transl([2,0,0]);       % Initial Cartesian position
            T_end = transl(1.4,0,0); % Final Cartesian position
            T_trajectory = ctraj(T_start, T_end, self.steps);  % Cartesian trajectory for steps
            
            %Red Can placement THOR
            for i = 1:self.steps
                if self.SafetyFlag == false
                    q1=  self.thor.model.ikcon(T1, q1);
                    qMatrix2 = jtraj(q1,q2,self.steps);
                    self.thor.model.animate(qMatrix2(i,:));
    
                    tr = self.thor.model.fkine(qMatrix2(i,:));
                    tvredCanV = [self.redCanV,ones(size(self.redCanV,1),1)]* trotx(pi)  * tr.T'; %
                    set(self.redCan,'Vertices',tvredCanV(:,1:3));

                    trPer = T_trajectory(:,:,i);  % Get the transformation at each step
                    transformedPersonVertices = [self.personV, ones(size(self.personV,1), 1)]* trotz(pi) * trPer';
                    set(self.person, 'Vertices', transformedPersonVertices(:, 1:3));  % Update can's position
                    personLocationX = trPer(1:3, 4)';
                    if personLocationX <=1.5
                       disp("LIGHT CURTAIN TRIGGERED --- PLEASE MOVE BACK")
                       self.SafetyFlag = true
                       input("press enter to move back")
                       T_start = transl(trPer(1:3, 4)');       % Initial Cartesian position
                       T_end = transl(2,0,0); % Final Cartesian position
                       T_trajectory = ctraj(T_start, T_end, self.steps);  % Cartesian trajectory for steps
                       for f = 1:self.steps
                           trPer = T_trajectory(:,:,f);  % Get the transformation at each step
                           transformedPersonVertices = [self.personV, ones(size(self.personV,1), 1)]* trotz(pi) * trPer';
                           set(self.person, 'Vertices', transformedPersonVertices(:, 1:3));  % Update can's position
                           personLocationX = trPer(1:3, 4)';
                           drawnow();
                           pause(0.02);
                       end

                    elseif  personLocationX > 1.5
                        self.SafetyFlag = false
                    end
                
                    drawnow();
                    pause(0.02);
                elseif self.SafetyFlag == true
                    
                    input("press enter to reset system")
                    self.SafetyFlag = false
                     
                end
            end
            
            T3 = transl((self.mcartonIPos) + [0.02,-0.02,0.03])* trotx(pi) * trotz(pi/2); %added an offset due to the model 
            q3=  self.thor.model.ikcon(T3);

            %thor to Milk carton Q matrix
            qMatrix3 = jtraj(q2,q3,self.steps);

            %%UR3e Transforms.
            qur3start = self.ur3.model.getpos();
            
            %%0.02 offset (x axis) from the object origin will work.
            T1ur3 = transl(self.rcanMpos + [-0.02, 0, 0])* trotx(pi/2) * troty(pi/2); %"where red can is"
            q1ur3=  self.ur3.model.ikcon(T1ur3, qur3start); %q1 = r.model.ikcon(T1);
            
            % UR3 qmatrix
            qur3Matrix1 = jtraj(qur3start,q1ur3,self.steps);

            %%Thor to Carton + UR3e to Can.
            for i = 1:self.steps
                if self.SafetyFlag == false
                    %Thor to milk carton
                    self.thor.model.animate(qMatrix3(i,:)); 
                    %%Ur3e movement:
                    self.ur3.model.animate(qur3Matrix1(i,:));
                    drawnow();
                    pause(0.02);

                elseif self.SafetyFlag == true
                    input("press enter to reset system")
                     
                end
            
            end

            T4 = transl((self.mcartonMpos) + [0.02,-0.02,0.03])* trotx(pi) * trotz(pi/2); %added an offset due to the model 
            q4=  self.thor.model.ikcon(T4);

            %thor to Milk carton Q matrix
            qMatrix4 = jtraj(q3,q4,self.steps);

            T2ur3 = transl(self.rcanFpos + [-0.02, 0, 0])* trotx(pi/2) * troty(pi/2); %
            q2ur3=  self.ur3.model.ikcon(T2ur3, self.ur3.model.getpos());
            qur3Matrix2 = jtraj(self.ur3.model.getpos(),q2ur3,self.steps)

            %UR3e drop can off and thor pickup carton
            for i = 1:self.steps
                if self.SafetyFlag == false
                    self.ur3.model.animate(qur3Matrix2(i,:));
                    self.thor.model.animate(qMatrix4(i,:));

                    tr = self.thor.model.fkine(qMatrix4(i,:));
                    tvmcartonV = [self.mcartonV,ones(size(self.mcartonV,1),1)]* trotx(pi) * tr.T'; %
                    set(self.mcarton,'Vertices',tvmcartonV(:,1:3));
                    
                    tr = self.ur3.model.fkine(qur3Matrix2(i,:));
                    tvredCanV = [self.redCanV,ones(size(self.redCanV,1),1)]* trotx(pi/2) * troty(pi/2) * tr.T'; %
                    set(self.redCan,'Vertices',tvredCanV(:,1:3));
    
                    drawnow();
                    pause(0.02);
                elseif self.SafetyFlag == true
                    input("press enter to reset system")
                     
                end
            end
            
            %thor to Apple Q matrix generation
            T5 = transl((self.appleIpos)+ [0,0,0.03])* trotx(pi) * trotz(pi/2); %added an offset due to the model 
            q5=  self.thor.model.ikcon(T5); 
            qMatrix5 = jtraj(q4,q5,self.steps);


            %UR3 to Milk carton
            % Define the position for mcartonFpos (first intermediate position)
            T3dot5ur3 = transl(self.mcartonFpos) * trotx(pi/2) * troty(pi/2);  
            q3dot5ur3 = self.ur3.model.ikcon(T3dot5ur3, self.ur3.model.getpos());  
            qur3dot5Matrix3 = jtraj(self.ur3.model.getpos(), q3dot5ur3, 5);  
            
            % Define the position for mcartonMpos (final target position)
            T3ur3 = transl(self.mcartonMpos + [-0.02, 0, 0]) * trotx(pi/2) * troty(pi/2);  
            q3ur3 = self.ur3.model.ikcon(T3ur3, q3dot5ur3);  
            qur3Matrix3 = jtraj(q3dot5ur3, q3ur3, self.steps - 5);  
            
            % Combine the two trajectories into a single matrix
            qur3Matrix3 = [qur3dot5Matrix3; qur3Matrix3];

            %%can Drop Transforms:
            T_start = transl(self.rcanFpos);       % Initial Cartesian position
            T_end = transl(self.rcanDropPos); % Final Cartesian position
            T_trajectory = ctraj(T_start, T_end, self.steps);  % Cartesian trajectory for steps

            %Can falling into bin, Thor moving to Apple and UR3 moving to
            %the Milk Carton 
            for i = 1:self.steps
                if self.SafetyFlag == false
                    self.thor.model.animate(qMatrix5(i,:));
                    self.ur3.model.animate(qur3Matrix3(i,:));
                    % Update can's position based on the trajectory
                    trCan = T_trajectory(:,:,i);  % Get the transformation at each step
                    transformedRedCanVertices = [self.redCanV, ones(size(self.redCanV,1), 1)] * trCan';
                    set(self.redCan, 'Vertices', transformedRedCanVertices(:, 1:3));  % Update can's position
                    drawnow();
                    pause(0.02);  % Adjust speed if needed
                elseif self.SafetyFlag == true
                    input("press the enter button to reset system")

                end
            end
            
            %thor Apple to middle Q matrix
            T6 = transl((self.appleMpos)+ [0,0,0.03])* trotx(pi) * trotz(pi/2); %added an offset due to the model 
            q6=  self.thor.model.ikcon(T6);
            qMatrix4 = jtraj(q5,q6,self.steps);

            %UR3 Milk Carton to Bin Q matrix

            T4ur3 = transl(self.mcartonFpos + [-0.02, 0, 0])* trotx(pi/2) * troty(pi/2); %
            q4ur3=  self.ur3.model.ikcon(T4ur3, self.ur3.model.getpos());
            qur3Matrix4 = jtraj(self.ur3.model.getpos(),q4ur3,self.steps);

            %UR3e drop can off and thor pickup carton
            for i = 1:self.steps
                if self.SafetyFlag == false
                    self.ur3.model.animate(qur3Matrix4(i,:));
                    self.thor.model.animate(qMatrix4(i,:));

                    tr = self.thor.model.fkine(qMatrix4(i,:));
                    tvAppleV = [self.AppleV,ones(size(self.AppleV,1),1)]* trotx(pi)  * tr.T'; %
                    set(self.Apple,'Vertices',tvAppleV(:,1:3));
                    
                    tr = self.ur3.model.fkine(qur3Matrix4(i,:));
                    tvmcartonV = [self.mcartonV,ones(size(self.mcartonV,1),1)]* trotx(pi/2) * troty(pi/2) * tr.T'; %
                    set(self.mcarton,'Vertices',tvmcartonV(:,1:3));
    
                    drawnow();
                    pause(0.02);
                elseif self.SafetyFlag == true
                    
                   input("press enter to reset system")
                     
                end
            end

            %thor to start
            qMatrix5 = jtraj(q6,qr1start,self.steps);


            %UR3 to Milk carton
            T5ur3 = transl(self.appleMpos)* trotx(pi/2) * troty(pi/2); %
            q5ur3=  self.ur3.model.ikcon(T5ur3, self.ur3.model.getpos());
            qur3Matrix5 = jtraj(self.ur3.model.getpos(),q5ur3,self.steps)

            %%milk carton Drop Transforms:
            T_start = transl(self.mcartonFpos);       % Initial Cartesian position
            T_end = transl(self.mcartonDropPos); % Final Cartesian position
            T_trajectory = ctraj(T_start, T_end, self.steps);  % Cartesian trajectory for steps

            %Can falling into bin, Thor moving to Apple and UR3 moving to
            %the Milk Carton 
            for i = 1:self.steps
                if self.SafetyFlag == false
                    self.thor.model.animate(qMatrix5(i,:));
                    self.ur3.model.animate(qur3Matrix5(i,:));
                    % Update can's position based on the trajectory
                    trMcarton = T_trajectory(:,:,i);  % Get the transformation at each step
                    tvmcartonV = [self.mcartonV, ones(size(self.mcartonV,1), 1)] * trMcarton';
                    set(self.mcarton, 'Vertices', tvmcartonV(:, 1:3));  % Update can's position
                    drawnow();
                    pause(0.02);  % Adjust speed if needed
                elseif self.SafetyFlag == true
                    input("press enter to reset system")
                    self.SafetyFlag = false;
                end
            end

                        %UR3 to Milk carton
            T6ur3 = transl(self.appleFpos)* trotx(pi/2) * troty(pi/2); %
            q6ur3=  self.ur3.model.ikcon(T6ur3, self.ur3.model.getpos());
            qur3Matrix6 = jtraj(self.ur3.model.getpos(),q6ur3,self.steps);


            %Apple going to the bin with UR3
            for i = 1:self.steps
                if self.SafetyFlag == false
                    self.ur3.model.animate(qur3Matrix6(i,:));
                    tr = self.ur3.model.fkine(qur3Matrix6(i,:));
                    tvAppleV = [self.AppleV,ones(size(self.AppleV,1),1)]* trotx(pi)  * tr.T'; %
                    set(self.Apple,'Vertices',tvAppleV(:,1:3));

                    drawnow();
                    pause(0.02);  % Adjust speed if needed
                elseif self.SafetyFlag == true
                    input("press enter to reset system")
                    self.SafetyFlag = false;
                end
            end

            %Apple dropping into bin
            T_start = transl(self.appleFpos);       % Initial Cartesian position
            T_end = transl(self.appleDropPos); % Final Cartesian position
            T_trajectory = ctraj(T_start, T_end, self.steps);  % Cartesian trajectory for steps

            %Apple falling into bin
            for i = 1:self.steps
                if self.SafetyFlag == false
                    trApple= T_trajectory(:,:,i);  % Get the transformation at each step
                    tvAppleV = [self.AppleV, ones(size(self.AppleV,1), 1)] * trApple';
                    set(self.Apple, 'Vertices', tvAppleV(:, 1:3));  % Update can's position
                    drawnow();
                    pause(0.02);  % Adjust speed if needed
                elseif self.SafetyFlag == true
                    input("press enter to reset system")
                    self.SafetyFlag = false;
                end
            end



           
            

        end

        function checkEmergencyStop(self)
            % Read the button state
            buttonState = readDigitalPin(self.a, self.buttonPin);
        
            % Handle button press with debounce
            if buttonState == 0 && ~self.buttonPressed
                if ~self.SafetyFlag && ~self.waitingForResume
                    self.SafetyFlag = true;
                    self.waitingForResume = false;
                    self.resumeFlag = false;
                    disp('Emergency Stop Engaged');
                elseif self.SafetyFlag && ~self.waitingForResume
                    self.SafetyFlag = false;
                    self.waitingForResume = true;
                    disp('Emergency Stop Disengaged. Waiting for Resume Command.');
                elseif self.waitingForResume
                    self.resumeFlag = true;
                    self.waitingForResume = false;
                    disp('Resume Command Issued');
                end
                self.buttonPressed = true;
                pause(self.debounceDelay); % Debounce delay
            elseif buttonState == 1
                self.buttonPressed = false;
            end
        end

        function triggeredEstopGui(self)
            self.SafetyFlag = true;
            disp("Estop clicked")
        end

    end
end