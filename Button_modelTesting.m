clc
clf
clear

global emergencyStopFlag resumeFlag buttonPressed waitingForResume;
emergencyStopFlag = false;  % Initial state is off
resumeFlag = false;
buttonPressed = false;
waitingForResume = false;

%% Arduino Button Setup
port = 'COM6';
buttonPin = 'D2';
a = arduino(port, 'Uno');
configurePin(a, buttonPin, 'DigitalInput');

debounceDelay = 0.05; % 50 ms debounce delay

% Timer for monitoring the e-stop button
t = timer('ExecutionMode', 'fixedRate', 'Period', 0.1, ...
          'TimerFcn', @(~,~)checkEmergencyStop(a, buttonPin, debounceDelay));

start(t);

function checkEmergencyStop(a, buttonPin, debounceDelay)
    global emergencyStopFlag resumeFlag buttonPressed waitingForResume;
    
    % Read the button state
    buttonState = readDigitalPin(a, buttonPin);
    
    % Check if buttonState is a scalar
    if ~isscalar(buttonState)
        disp("Error: Button state is not a scalar.");
        return;
    end

    % Handle button press with debounce
    if buttonState == 0 && ~buttonPressed
        if ~emergencyStopFlag && ~waitingForResume
            % First press: Engage e-stop
            emergencyStopFlag = true;
            waitingForResume = false; % Reset waiting for resume
            resumeFlag = false; % Ensure resume needs confirmation
            disp('Emergency Stop Engaged');
        elseif emergencyStopFlag && ~waitingForResume
            % Second press: Disengage e-stop but wait for resume command
            emergencyStopFlag = false;
            waitingForResume = true; % Set waiting for resume
            disp('Emergency Stop Disengaged. Waiting for Resume Command.');
        elseif waitingForResume
            % Third press: Resume robot motion
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

%% Main Loop with E-stop and Resume Logic
for trajectory = {qMatrix2, qMatrix3, qMatrix4}
    qMatrix = trajectory{1};  % Get the current trajectory

    for i = 1:steps
        if emergencyStopFlag
            % Pause robot and wait for resume command
            disp('Robot Motion Paused');
            while emergencyStopFlag
                pause(0.1); % Check periodically if e-stop has been disengaged
            end

            % Wait for resume command (user must set resumeFlag separately)
            disp('Awaiting Resume Command');
            while ~resumeFlag
                pause(0.1); % Wait for user to issue the resume command
            end
            disp('Resuming Robot Motion');
        end

        % Continue robot motion when not stopped
        r.model.animate(qMatrix(i,:));
        drawnow();
        pause(0.01);
    end
end
