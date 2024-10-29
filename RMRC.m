% Load UR3e Model
robot = Thor();

% Define parameters for RMRC
steps = 50;
deltaT = 0.05;  % Discrete time step

% Define start and end positions in Cartesian space (x, y, z)
x1 = [0.3, 0.2, 0.1]';  % Start position
x2 = [0.5, 0.2, 0.15]';  % End position

% Define the desired fixed orientation matrix (-y, -z, +x)
R_desired = [0, 0, 1; -1, 0, 0; 0, -1, 0];  % Columns represent -y, -z, +x axes

% Initialize Cartesian pose trajectory (position and fixed orientation)
x = zeros(3, steps);
s = lspb(0, 1, steps);  % Create interpolation scalar

% Interpolate position in Cartesian space while keeping orientation constant
for i = 1:steps
    % Position interpolation
    x(:, i) = x1 * (1 - s(i)) + x2 * s(i);  % Linear interpolation in (x, y, z)
end

% Create a 4x4 homogeneous transformation matrix with transl and R_desired
T_init = transl(x1(1), x1(2), x1(3)) * [R_desired, [0; 0; 0]; 0, 0, 0, 1];

% Solve IK for the initial pose
q_init = robot.model.ikcon(T_init, zeros(1, robot.model.n));  % Initial joint angles

% Initialize joint trajectory matrix
qMatrix = nan(steps, robot.model.n);
qMatrix(1, :) = q_init;  % Set initial joint configuration

% RMRC loop for generating joint trajectory with fixed orientation
for i = 1:steps-1
    % Calculate the linear velocity in Cartesian space
    xdot_linear = (x(:, i+1) - x(:, i)) / deltaT;  % Linear velocity (x, y, z)

    % Calculate the angular velocity to maintain the desired orientation
    R_current = robot.model.fkine(qMatrix(i, :)).R;  % Current rotation matrix
    Rdot = (R_desired - R_current) / deltaT;  % Rate of change of rotation matrix
    omega_skew = R_current' * Rdot;  % Skew-symmetric form of angular velocity
    omega = [omega_skew(3, 2); omega_skew(1, 3); omega_skew(2, 1)];  % Angular velocity vector

    % Combine linear and angular velocities
    xdot = [xdot_linear; omega];  % 6x1 velocity vector

    % Get the full 6x6 Jacobian for the current joint configuration
    J = robot.model.jacob0(qMatrix(i, :));  % Full Jacobian (6x6)

    % Compute joint velocities using RMRC
    qdot = pinv(J) * xdot;  % Use pseudo-inverse to solve for joint velocities

    % Update the joint configuration for the next step
    qMatrix(i+1, :) = qMatrix(i, :) + deltaT * qdot';
end

% Plot the trajectory of the UR3e robot
robot.model.plot(qMatrix, 'trail', 'r-');