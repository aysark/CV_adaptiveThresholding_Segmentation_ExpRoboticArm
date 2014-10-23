% Using the A150 Matlab class.

% Turn on the robot and make sure its markers are aligned for
% homing; do not start minicom or home the robot!

% You always need to create an instance of the robot before you
% use it; it is implemented as a singleton so that there is only
% ever one valid instance.
% r is the robot
r = A150.instance()

% You can get a summary of the available methods by asking for help
help A150

% You can also get help for a specific command
% (uncomment next two lines if you want to home the robot)
% help A150.home
% r.home()

help A150.ready
r.ready()

% The A150 has a crappy serial port; getting data from the serial
% port is sometimes unreliable. w0 will fail if you call it
% repeatedly in a loop. You've been warned.

help A150.w0
[J, P, T] = r.w0()

% It is important to note that the robot does not use the
% Denavit-Hartenberg convention in its native API. Joints
% 2, 3, and 4 are measured relative to the horizon.
help A150.madeg
Jdeg = [0 45 -45 -60 60];
r.madeg(Jdeg);

% If you want the DH convention then you must use the dhmadeg
% command.
help A150.dhmadeg
Jdeg = [0 45 -45 -60 60];
r.dhmadeg(Jdeg);

% A major difference between the simulator and the actual robot
% is that the actual robot does not always complete a motion
% before starting the next motion. In particular, if you open
% or close the gripper and then issue a motion command the robot
% will start moving before the gripper has completed opening
% or closing. You can use the finish command to tell the robot
% to wait before the next motion command.
% Warning: finish is implemented using w0; it's pretty flaky.
r.finish();
[J, P, T] = r.w0()

help A150.open
r.open()

% Alternatively, you can just use pause
pause(3)

help A150.close
r.close()
pause(3)

r.ready()

% Always quit
help A150.quit
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


