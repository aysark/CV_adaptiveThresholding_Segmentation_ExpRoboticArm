% Using the sim150 Matlab class.

% You always need to create an instance of the robot before you
% use it; it is implemented as a singleton so that there is only
% ever one valid instance.
% r is the robot
r = sim150.instance()

% You can get a summary of the available methods by asking for help
help sim150

% Unlike the actual A150, you do not need to home the robot.

help A150.ready
r.ready()

% You can use getpose to get the pose matrix and joint values.
% This is different from the controller (where you use w0).
help sim150.getpose
[T, J, dh] = r.getpose()

% It is important to note that the robot does not use the
% Denavit-Hartenberg convention in its native API. Joints
% 2, 3, and 4 are measured relative to the horizon.
help sim150.madeg
Jdeg = [0 45 -45 -60 60];
r.madeg(Jdeg);

% If you want the DH convention then you must use the dhmadeg
% command.
help sim150.dhmadeg
Jdeg = [0 45 -45 -60 60];
r.dhmadeg(Jdeg);

% Opening and closing the gripper
r.open()
r.close()

r.ready()

% Always quit
help sim150.quit
r.quit()


% There are a lot of functions you might want to use that are
% not implemented. You can add your own implementations to
% A150.m
%
% If you edit A150.m make sure you issue the quit command to
% to the robot, save your edits, and then get a new instance.
% Otherwise you run the risk of tying up the serial port.
% If you run into this problem, type

out = instrfind

% And find the open serial port. Let's assume the open port is
% out(5); close it by typing
%
% out(5).close()


