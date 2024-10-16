%% Collision detection using IsCollision function

% Load the robot arms
UR3; 
Thor;

% Assign robot models to a variable
robot1 = UR3;
robot2 = thor;

% EXAMPLE: Define the starting and ending configurations (joint angles in radians)
%
% Not necessary in full implementation (movement already defined)
q1 = [pi/3,pi/3,0];
q2 = [-pi/3,-pi/3,0];

% EXAMPLE: Create a 50-step trajectory from q1 to q2 using jtraj
%
% Not necessary in full implementation (movemnet already defined)
steps = 50;
qMatrix = jtraj(q1, q2, steps);

% EXAMPLE: Define the rectangular prism using its vertices and faces
% 
% Environment artifacts, extra obstacles added
[v,f,fn] = RectangularPrism([2,-1.1,-1], [3,1.1,1]);

% EXAMPLE: Define workspace and scale for visualization
%
% Not necessary in full implementation (environment already defined)
workspace = [-3 3 -3 3 -0.05 2];                                       
scale = 0.5;

% EXAMPLE: Plot the initial configuration of the robot
%
% Not necessary in full implementation (environment already defined)
robot1.plot(q1, 'workspace', workspace, 'scale', scale);

% Initialize collision result array
result = true(steps, 1);

% Check for collisions along the trajectory
for i = 1:steps
    % Display current configuration (optional for debugging)
    disp(['Checking configuration ', num2str(i), ' of ', num2str(steps)]);

    % Check for collision at the current configuration
    result(i) = IsCollision(robot1, qMatrix(i,:), f, v, fn, false);

    % Display the robot's animation at the current configuration
    robot1.animate(qMatrix(i,:));

    % If a collision is detected, print the pose and break the loop
    if result(i) == true
        disp(['Collision detected at step: ', num2str(i)]);
        disp(['Joint configuration at collision: ', num2str(qMatrix(i,:))]);
        break;
    end
end

% Display the first configuration that is in collision, if any
firstCollisionIndex = find(result, 1);
if ~isempty(firstCollisionIndex)
    disp(['The first collision is at step: ', num2str(firstCollisionIndex)]);
    disp(['Joint configuration at the first collision: ', num2str(qMatrix(firstCollisionIndex,:))]);
else
    disp('No collision detected along the trajectory.');
end


%% IsCollision Function

% Given a robot model (robot), and trajectory (i.e. joint state vector) (qMatrix)
% and triangle obstacles in the environment (faces,vertex,faceNormals)
function result = IsCollision(robot,qMatrix,faces,vertex,faceNormals,returnOnceFound)
if nargin < 6
    returnOnceFound = true;
end
result = false;

for qIndex = 1:size(qMatrix,1)
    % Get the transform of every joint (i.e. start and end of every link)
    tr = GetLinkPoses(qMatrix(qIndex,:), robot);

    % Go through each link and also each triangle face
    for i = 1 : size(tr,3)-1    
        for faceIndex = 1:size(faces,1)
            vertOnPlane = vertex(faces(faceIndex,1)',:);
            [intersectP,check] = LinePlaneIntersection(faceNormals(faceIndex,:),vertOnPlane,tr(1:3,4,i)',tr(1:3,4,i+1)'); 
            if check == 1 && IsIntersectionPointInsideTriangle(intersectP,vertex(faces(faceIndex,:)',:))
                plot3(intersectP(1),intersectP(2),intersectP(3),'g*');
                display('Intersection');
                result = true;
                if returnOnceFound
                    return
                end
            end
        end    
    end
end
end

function [ transforms ] = GetLinkPoses( q, robot)

links = robot.links;
transforms = zeros(4, 4, length(links) + 1);
transforms(:,:,1) = robot.base;

for i = 1:length(links)
    L = links(1,i);
    
    current_transform = transforms(:,:, i);
    
    current_transform = current_transform * trotz(q(1,i) + L.offset) * ...
    transl(0,0, L.d) * transl(L.a,0,0) * trotx(L.alpha);
    transforms(:,:,i + 1) = current_transform;
end
end

%% IsIntersectionPointInsideTriangle
% Given a point which is known to be on the same plane as the triangle
% determine if the point is 
% inside (result == 1) or 
% outside a triangle (result ==0 )
function result = IsIntersectionPointInsideTriangle(intersectP,triangleVerts)

u = triangleVerts(2,:) - triangleVerts(1,:);
v = triangleVerts(3,:) - triangleVerts(1,:);

uu = dot(u,u);
uv = dot(u,v);
vv = dot(v,v);

w = intersectP - triangleVerts(1,:);
wu = dot(w,u);
wv = dot(w,v);

D = uv * uv - uu * vv;

% Get and test parametric coords (s and t)
s = (uv * wv - vv * wu) / D;
if (s < 0.0 || s > 1.0)        % intersectP is outside Triangle
    result = 0;
    return;
end

t = (uv * wu - uu * wv) / D;
if (t < 0.0 || (s + t) > 1.0)  % intersectP is outside Triangle
    result = 0;
    return;
end

result = 1;                      % intersectP is in Triangle
end


