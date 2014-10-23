classdef A150 < Singleton
% A150 Controller for the CRS A150 robotic arm
%
% A150 Methods:
%   instance - Get an instance of the A150 arm.
%   home     - Home the arm.
%   ready    - Move the arm the ready position.
%   ma       - Set the joint angles of the arm in radians.
%   madeg    - Set the joint angles of the arm in degrees.
%   dhmadeg  - Set the joint angles of the arm in degrees (DH convention).
%   open     - Open the gripper.
%   close    - Close the gripper.
%   w0       - Get the commanded joint angles and robot position.
%   finish   - Finish a motion command.
%   quit     - Quit using the arm.
    
    properties (Access = private)
        serialPort = [];
    end
    
    methods(Access=private)
        % Guard the constructor against external invocation.  We only want
        % to allow a single instance of this class.  See description in
        % Singleton superclass.
        function newObj = A150()
            fd = initA150();
            if fd == -1
                error('Error initializing serial port');
            end
            newObj.serialPort = fd;
            newObj.sendCommand('NOHELP');
        end
        
        function delete(obj)
            quitA150(obj.serialPort);
        end
        
        function result = sendCommand(obj, cmd)
            %SENDCOMMAND Send a command string
            result = sendA150(obj.serialPort, cmd);
            if strcmp('>>', result(end-1:end))
                %cmd is probably ok
                %results from the A150 that can be ignored are
                %6 characters long (?)
                if length(result) == 6
                    result = '';
                else
                    result = strtrim(result);
                end
            else
                result = strtrim(result);
                %strip off NACK character
                result(end) = [];
            end
        end
        
    end
    
    methods(Static)
        % Concrete implementation.  See Singleton superclass.
        function obj = instance()
            %INSTANCE Get an instance of the A150 arm.
            %R = A150.INSTANCE() returns an instance of the A150
            %arm. Use this static method instead of a constructor
            %to create an arm controller.
            
            persistent uniqueInstance
            if isempty(uniqueInstance) | ~isvalid(uniqueInstance)
                obj = A150();
                uniqueInstance = obj;
            else
                obj = uniqueInstance;
            end
        end
    end
    
    methods
        function quit(obj)
            %QUIT Quit using the arm.
            %Use R.QUIT() to quit using the arm R.
            
            obj.delete();
        end
        
        function home(obj)
            %HOME Home the arm.
            %R.HOME() will home R.
            x = obj.sendCommand('HOME');
        end
           
        function ready(obj)
            %READY Move the arm the ready position.
            %R.READY() will move R to the ready position.
            obj.sendCommand('READY');
        end
        
        function result = ma(obj, J)
            %MA Set the joint angles of the arm in radians.
            %R.MA(J) will set the joint angles of R to the angles in
            %radians given by J.
            %
            %Example
            %    J = [0 pi/4 -pi/4 -pi/3 pi/3];
            %    r.ma(J);
            %will set the joint angles of r to:
            %    joint  angle (radians)
            %      1         0
            %      2        pi/4
            %      3       -pi/4
            %      4       -pi/3
            %      5        pi/3
            %
            %RESULT = R.MA(J) will also return a result string that will
            %be empty if the command succeeded; otherwise an error message
            %will be returned.
            if length(J) ~= 5
                error('MA:invalidArg', 'Requires 5 joint angles');
            end
            s = sprintf('%s %f %f %f %f %f', 'MA', J);
            result = obj.sendCommand(s);
        end
        
        function result = madeg(obj, J)
            %MADEG Set the joint angles of the arm in degrees.
            %R.MADEG(J) will set the joint angles of R to the angles in
            %degrees given by J.
            %
            %Example
            %    J = [0 45 -45 -60 60];
            %    r.madeg(J);
            %will set the joint angles of r to:
            %    joint  angle (radians)
            %      1         0
            %      2        45
            %      3       -45
            %      4       -60
            %      5        60
            %
            %RESULT = R.MADEG(J) will also return a result string that will
            %be empty if the command succeeded; otherwise an error message
            %will be returned.
            if length(J) ~= 5
                error('MADEG:invalidArg', 'Requires 5 joint angles');
            end
            result = obj.ma(J*pi/180);
        end
        
        function result = dhmadeg(obj, J)
            %DHMADEG Set the joint angles of the arm in degrees.
            %R.DHMADEG(J) will set the joint angles of R to the angles in
            %degrees given by J in a manner consistent with the
            %Denavit-Hartenberg convention.
            %(i.e., the shoulder, elbow, and wrist angles are given relative
            %to the previous link as in the Denavit-Hartenberg convention).
            %
            %Example
            %    J = [0 45 -45 -60 60];
            %    r.dhmadeg(J);
            %will set the joint angles of r to:
            %    joint  angle (degrees)
            %      1         0
            %      2        45
            %      3       -45
            %      4       -60
            %      5        60
            %
            %RESULT = R.DHMADEG(J) will also return a result string that will
            %be empty if the command succeeded; otherwise an error message
            %will be returned.
            if length(J) ~= 5
                error('DHMADEG:invalidArg', 'Requires 5 joint angles');
            end

            % convert the joint angles from simulator angles to robot angles
            J(4) = J(2) + J(3) + J(4);
            J(3) = J(2) + J(3);
            result = obj.madeg(J);
        end
        
        
        function open(obj, force)
            %OPEN Open the gripper.
            %R.OPEN(F) opens the gripper using F percent opening force.
            %F has an upper limit of 70.
            %
            %R.OPEN() opens the gripper using 50 percent opening force.
            if nargin == 1
                force = 50;
            elseif force > 70
                force = 70;
            end
            s = sprintf('%s %d', 'OPEN', force);
            obj.sendCommand(s);
        end
        
        function close(obj, force)
            %CLOSE Close the gripper.
            %R.CLOSE(F) closes the gripper using F percent closing force.
            %F has an upper limit of 70.
            %
            %R.CLOSE() closes the gripper using 50 percent closing force.
            if nargin == 1
                force = 50;
            elseif force > 70
                force = 70;
            end
            s = sprintf('%s %d', 'CLOSE', force);
            obj.sendCommand(s);
        end
        
        function [J, P, T, result] = w0(obj)
            %W0 Get the commanded joint angles and robot position.
            %J = R.W0() returns the commanded joint angles J in degrees.
            %
            %[J, P] = R.W0() also returns the world position P of the end
            %plate.
            %
            %[J, P, T] = R.W0() also returns the yaw, pitch, and roll
            %angles T of the end effector in degrees.
            %
            %[J, P, T, RESULT] = R.W0() also returns the raw text
            %RESULT.
            %
            %W0 has the side effect of forcing a motion command to
            %complete.
            
            %the serial port is not very good on the A150 and
            %it tends to drop characters; we loop until we get
            %two identical responses
            while 1
                result = obj.sendCommand('W0');
                pause(0.5);  % slow serial port; must pause here
                confirm = obj.sendCommand('W0');
                szres = size(result);
                szcon = size(confirm);
                if all(szres == szcon) && all(result == confirm)
                    break;
                end
            end

            %easiest way to parse result is to use textscan
            C = textscan(result, '%s');
            %cells 23-27 hold the joint angles in degrees
            for a = 23:27
                J(a-22) = str2num(cell2mat(C{1}(a)));
            end
            %cells 36-38 hold the position of the end plate
            for a = 36:38
                P(a-35) = str2num(cell2mat(C{1}(a)));
            end
            %cells 39-41 hold the RPY angles of the tool
            for a = 39:41
                T(a-38) = str2num(cell2mat(C{1}(a)));
            end
        end
        
        function finish(obj)
            %FINISH Finish a motion command.
            
            %The implementation has the side effect of forcing
            %a motion command to complete.
            obj.w0();
        end
        
        % ADD YOUR OWN FUNCTIONS BELOW
        
    end
end

