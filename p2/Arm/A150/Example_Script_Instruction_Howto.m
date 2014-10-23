% Instruction on how to use the arm in the Computer Vision lab.
%
% Script to instantiate and run the robot arm using the A150.m class
% Each block provide the method by which each step can be taken. The
% sequence of running the first three block is important.
% 1- create an instance of the A150 class.
% 2- Home the robot arm. this will calibrate the arm.
% 3- Put the arm in the ready position. Running this code always bring the
% arm back to this state.
% 4- Now the running the following steps will chaneg the arm state
% accoriding to each joint angle and open or close the grip.
% 5- at the end you need to quit the instance and release the handle to the
% arm.
%
%
% Author: Mahdi



%% Instantiate the robot arm

r = A150.instance();    % r is now the robot object



disp('Robot arm instantiated, press any key when ready to home.');

pause;



%% Home the robot arm

r.home();

isHomed = input('Is the robot correctly homed? Press "y" to continue, any key to re-home.', 's');


while(~strcmp(isHomed, 'y'))

    r.home();

    isHomed = input('Is the robot correctly homed? Press "y" to continue, any key to re-home.', 's');

end



%% Run the robot arm

r.ready();  % This puts the robot arm into the ready position so it can do other commands

disp('Robot arm is set to the ready position, press any key when ready to proceed.');

pause;

%% Rotate the arm


isRotated = input('Do you like to move the arm? Press "y" to process or any key to skip.', 's');



if(strcmp(isRotated, 'y'))

    J = [0 45 -45 -60 60];

    r.madeg(J);

end




%% Close the grip


GripAction = input('Do you like to close the grip? Press "y" to process or any key to skip.', 's');

if(strcmp(GripAction, 'y'))

    r.close();

end

disp('grip is close, press any key to open it.');

pause;

r.open();


%% Quit using the arm

r.quit();













