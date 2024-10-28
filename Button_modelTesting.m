clc
clf
clear

global emergencyStopFlag resumeFlag buttonPressed waitingForResume currentStep animationTimer;
emergencyStopFlag = false;       % Initial state is off
resumeFlag = false;
buttonPressed = false;
waitingForResume = false;
currentStep = 1;                 % Track the current animation step

%% Arduino Button Setup
port = 'COM6';
buttonPin = 'D2';
a = arduino(port, 'Uno');
configurePin(a, buttonPin, 'DigitalInput');

debounceDelay = 0.05; % 50 ms debounce delay

% Timer for monitoring the e-stop button
t = timer('ExecutionMode', 'fixedRate', 'Period', 0.1, ...
          'TimerFcn', @(~,~)checkEmergencyStop(a, buttonPin, debounceDelay));

% Start the button monitoring timer
start(t);

%% Robot Setup
r = Thor;
workspace = [-0.8 0.8 -0.8 0.8 -0.5 0.8];
axis(workspace);
view(3);

steps = 50;
qinitialG = zeros(1,7);

% Define transformations and joint trajectories
T1 = transl(-0.2, -0.3, 0.1) * trotx(pi);
q1 = r.model.ikcon(T1);
T2 = transl(0.3, 0.3, 0.1) * trotx(pi);
q2 = r.model.ikcon(T2);
T3 = transl(0.3, 0, 0.1) * trotx(pi);
q3 = r.model.ikcon(T3);
T4 = transl(-0.2, -0.3, 0.2) * trotx(pi);
q4 = r.model.ikcon(T4);

qMatrix2 = jtraj(q1, q2, steps);
qMatrix3 = jtraj(q2, q3, steps);
qMatrix4 = jtraj(q3, q4, steps);

%% Main Animation Timer for E-Stop Control
trajectoryList = {qMatrix2, qMatrix3, qMatrix4};
global animationTimer;
animationTimer = timer('ExecutionMode', 'fixedRate', 'Period', 0.01, ...
                       'TimerFcn', @(~,~)animateRobot(r, trajectoryList, steps));

% Start the animation timer
start(animationTimer);

%% Emergency Stop and Resume Function
function checkEmergencyStop(a, buttonPin, debounceDelay)
    global emergencyStopFlag resumeFlag buttonPressed waitingForResume;

    % Read the button state
    buttonState = readDigitalPin(a, buttonPin);

    % Handle button press with debounce
    if buttonState == 0 && ~buttonPressed
        if ~emergencyStopFlag && ~waitingForResume
            emergencyStopFlag = true;
            waitingForResume = false;
            resumeFlag = false;
            disp('Emergency Stop Engaged');
        elseif emergencyStopFlag && ~waitingForResume
            emergencyStopFlag = false;
            waitingForResume = true;
            disp('Emergency Stop Disengaged. Waiting for Resume Command.');
        elseif waitingForResume
            resumeFlag = true;
            waitingForResume = false;
            disp('Resume Command Issued');
        end
        buttonPressed = true;
        pause(debounceDelay); % Debounce delay
    elseif buttonState == 1
        buttonPressed = false;
    end
end

%% Animation Function with E-Stop Check
function animateRobot(r, trajectoryList, steps)
    global emergencyStopFlag resumeFlag currentStep animationTimer;

    persistent currentTrajectoryIndex;
    if isempty(currentTrajectoryIndex)
        currentTrajectoryIndex = 1;  % Start with the first trajectory
    end

    % Check if e-stop is active
    if emergencyStopFlag
        stop(animationTimer);
        disp('Robot Motion Paused Due to Emergency Stop');
        return;
    end

    % Proceed with animation if not stopped
    qMatrix = trajectoryList{currentTrajectoryIndex};
    if currentStep <= steps
        % Animate the robot to the next position in the trajectory
        r.model.animate(qMatrix(currentStep, :));
        drawnow();
        currentStep = currentStep + 1;  % Increment the step
    else
        % Move to the next trajectory
        currentTrajectoryIndex = currentTrajectoryIndex + 1;
        if currentTrajectoryIndex > numel(trajectoryList)
            stop(animationTimer);  % Stop the animation timer if done
            disp('Animation completed.');
            return;
        end
        currentStep = 1;  % Reset step counter for the new trajectory
    end
end

%% Resume Timer Function
resumeTimer = timer('ExecutionMode', 'fixedRate', 'Period', 0.1, ...
                    'TimerFcn', @(~,~)checkResume());

start(resumeTimer);

function checkResume()
    global resumeFlag animationTimer

    % If the resume command has been issued, restart the animation
    if resumeFlag
        resumeFlag = false;  % Clear the flag
        start(animationTimer);  % Resume the animation
        disp('Resuming Robot Motion');
    end
end
