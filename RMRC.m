%% Joint Interpolation
clear all
close all
clc
set(0,'DefaultFigureWindowStyle','docked');

% Steps
steps = 50;

% Load robot arms
 mdl_planar2;                                       % Example 2-Link Planar Robot for tests
% thor;
% UR3e;

% Transformation matrices
T1 = [eye(3) [1.5 1 0]'; zeros(1,3) 1];              % First pose
T2 = [eye(3) [1.5 -1 0]'; zeros(1,3) 1];             % Second pose

% Use Inverse Kinematics to solve the joint angles required to achieve each pose
M = [1 1 zeros(1,4)];                                % Masking Matrix
q1 = p2.ikine(T1,'q0', [0 0], 'mask', M);            % Solve for joint angles
q2 = p2.ikine(T2, 'q0', [0 0], 'mask', M);           % Solve for joint angles
p2.plot(q1,'trail','r-');
pause(3)

% Joint interpolation to move between the two poses
qMatrix = jtraj(q1,q2,steps);
p2.plot(qMatrix,'trail','r-');                       % plot path



%% Resolved Motion Rate Control

clear all
close all
clc
set(0,'DefaultFigureWindowStyle','docked');

% Load robot arms
 mdl_planar2;                                       % Example 2-Link Planar Robot for tests
% thor;
% UR3e;

steps = 50;

% Transformation matrices
T1 = [eye(3) [1.5 1 0]'; zeros(1,3) 1];              % First pose
T2 = [eye(3) [1.5 -1 0]'; zeros(1,3) 1];             % Second pose

M = [1 1 zeros(1,4)];                                % Masking Matrix

% Two sets of points in the X-Y plane
x1 = [1.5 1]';
x2 = [1.5 -1]';
deltaT = 0.05;                                       % Discrete time step

% Matrix of waypoints
x = zeros(2,steps);
s = lspb(0,1,steps);                                 % Create interpolation scalar
for i = 1:steps
    x(:,i) = x1*(1-s(i)) + s(i)*x2;                  % Create trajectory in x-y plane
end

% Matrix of joint angles
qMatrix = nan(steps,2);

% Set the Transformation for the 1st point, and solve for the joint angles
qMatrix(1,:) = p2.ikine(T1, 'q0', [0 0], 'mask', M);

% Use RMRC to move the end-effector from x1 to x2
for i = 1:steps-1
    xdot = (x(:,i+1) - x(:,i))/deltaT;               % Calculate velocity at discrete time step
    J = p2.jacob0(qMatrix(i,:));                     % Get the Jacobian at the current state
    J = J(1:2,:);                                    % Take only first 2 rows
    qdot = inv(J)*xdot;                              % Solve velocitities via RMRC
    qMatrix(i+1,:) =  qMatrix(i,:) + deltaT*qdot';   % Update next joint state
end

p2.plot(qMatrix,'trail','r-');                       % Plot
