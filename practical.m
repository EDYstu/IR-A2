rosinit('192.168.27.1'); % If unsure, please ask a tutor

jointStateSubscriber = rossubscriber('/ur/joint_states','sensor_msgs/JointState');
pause(2); % Pause to give time for a message to appear

input("Press enter to start using claw")

openService = rossvcclient("/onrobot/open", "std_srvs/Trigger");
closeService = rossvcclient("/onrobot/close", "std_srvs/Trigger");

input("Press enter to open")
openService.call();

input("Press enter to continue and start moving")
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]


jointStateSubscriber.LatestMessage
jointNames = {'shoulder_pan_joint','shoulder_lift_joint', 'elbow_joint', 'wrist_1_joint', 'wrist_2_joint', 'wrist_3_joint'};

[client, goal] = rosactionclient('/ur/scaled_pos_joint_traj_controller/follow_joint_trajectory');
goal.Trajectory.JointNames = jointNames;
goal.Trajectory.Header.Seq = 1;
goal.Trajectory.Header.Stamp = rostime('Now','system');
goal.GoalTimeTolerance = rosduration(0.05);
bufferSeconds = 1; % This allows for the time taken to send the message. If the network is fast, this could be reduced.
durationSeconds = 1; % This is how many seconds the movement will take

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);     

input("Press enter to send to can 1")
endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = [1.443,-1.480,1.359,-1.449,-1.568,-0.020];
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend];

goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
sendGoal(client,goal);


input("Press enter to grab can")
closeService.call();

input("Press enter to continue to dropoff")
currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);     

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = [1.423, -2.603, 1.908,-1.574, -1.534, -0.077];
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend];

goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
sendGoal(client,goal);


input("Press enter to continue to dropoff")

currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);     

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = [0.332,-1.996, 1.508,-1.573, -1.534, -0.077];
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend];

goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
sendGoal(client,goal);


input("Press enter to open")
openService.call();

durationSeconds = 1;

currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);     

input("Press enter to continue to can2")
endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = [0.946, -1.379, 1.224, -1.419, -1.569, -0.035];
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend];

goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
sendGoal(client,goal);

input("Press enter to close")
closeService.call();


currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);     

input("Press enter to continue to dropoff")
endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = [0.782, -0.944, 0.482, -1.485,-1.569, -0.035];
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend];

goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
sendGoal(client,goal);


input("Enter to drop can")
openService.call()

input("Move to can 3")

currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);     

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = [1.748, -1.189, 0.493, -1.241, -1.569, -0.035];
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend];

goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
sendGoal(client,goal);

input("Move to can 3")

currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);     

endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = [1.748, -0.967, 0.493, -1.241, -1.569, -0.035];
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend];

goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
sendGoal(client,goal);

input("Enter to collect can")
closeService.call()


input("Move to can 3 dropoff")

currentJointState_321456 = (jointStateSubscriber.LatestMessage.Position)'; % Note the default order of the joints is 3,2,1,4,5,6
currentJointState_123456 = [currentJointState_321456(3:-1:1),currentJointState_321456(4:6)]

startJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
startJointSend.Positions = currentJointState_123456;
startJointSend.TimeFromStart = rosduration(0);     


endJointSend = rosmessage('trajectory_msgs/JointTrajectoryPoint');
nextJointState_123456 = [-0.037, -1.991, 1.177, -1.241, -1.569, -0.035];
endJointSend.Positions = nextJointState_123456;
endJointSend.TimeFromStart = rosduration(durationSeconds);

goal.Trajectory.Points = [startJointSend; endJointSend];

goal.Trajectory.Header.Stamp = jointStateSubscriber.LatestMessage.Header.Stamp + rosduration(bufferSeconds);
sendGoal(client,goal);

input("Dropoff")
openService.call(); 






