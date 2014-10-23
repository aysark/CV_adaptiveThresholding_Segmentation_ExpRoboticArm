classdef sim150 < Singleton
    %SIM150 A150 robotic arm simulator.
    %
    %SIM150 Methods:
    %   instance - Get an instance of the simulator.
    %   home     - Home the arm; does nothing in the simulator.
    %   ready    - Move the arm the ready position.
    %   madeg    - Set the joint angles of the arm in degrees.
    %   dhmadeg  - Set the joint angles of the arm in degrees (DH convention).
    %   open     - Open the gripper.
    %   close    - Close the gripper.
    %   getpose  - Get the pose of the end-effector and joint angles of the arm.
    %   speed    - Set the movement speed of the arm.
    %   quit     - Quit using the simulator.
    
    properties(Access = private)
        %The figure to be used to render the model of the robot
        fig = [];
        
        %The data for the model of the robot
        baseC = [];
        baseF = [];
        baseNV = [];
        baseV = [];
        basep = [];
        endeffC = [];
        endeffF = [];
        endeffNV = [];
        endeffV = [];
        endeffp = [];
        link1C = [];
        link1F = [];
        link1NV = [];
        link1V = [];
        link1p = [];
        link2C = [];
        link2F = [];
        link2NV = [];
        link2V = [];
        link2p = [];
        gbaseC = [];
        gbaseF = [];
        gbaseNV = [];
        gbaseV = [];
        gbasep = [];
        ggC = [];
        ggF = [];
        ggV = [];
        gg1NV = [];
        gg2NV = [];
        gg1p = [];
        gg2p = [];
        
       
        
        %Properties of the pose of the robot
        waist = [];
        shoulder = [];
        elbow = [];
        wrist = [];
        twist = [];
        gSpread = [];
        
        %Properties of the movement of the robot
        speedStep = 1;
    end
    
    methods(Access = private)
        

       function newObj = sim150()
            newObj.fig = figure();
            
            newObj.waist = 0;
            newObj.shoulder = -90;
            newObj.elbow = 0;
            newObj.wrist = 0;
            newObj.twist = 0;
            newObj.speedStep = 1;
            newObj.gSpread = 1.5;
            
            
            
            initGraphics(newObj);
       end
     
       function delete(obj)
            try
                close(obj.fig);
            catch exceptions
                
            end
       end
       
       function initGraphics(obj)
            %Load the Modesl of each piece of the robot
            load('sim150');
            
            figure(obj.fig);
            
            
            %Create the Base of the robot
            obj.baseC = baseC;
            obj.baseF = baseF;
            obj.baseNV = baseNV;
            obj.baseV = baseV;
            obj.basep = patch('faces', obj.baseF, 'vertices' , obj.baseV);
            set(obj.basep, 'facec', 'flat');
            set(obj.basep, 'EdgeColor','none');
            set(obj.basep, 'FaceVertexCData', obj.baseC);
            
            %Create the first link of the robot
            obj.link1C = link1C;
            obj.link1F = link1F;
            obj.link1NV = link1NV;
            obj.link1V = link1V;
            obj.link1p = patch('faces', obj.link1F, 'vertices' , obj.link1V);
            set(obj.link1p, 'facec', 'flat');
            set(obj.link1p, 'EdgeColor','none');
            set(obj.link1p, 'FaceVertexCData', obj.link1C);
            
            %Create the second link of the robot
            obj.link2C = link2C;
            obj.link2F = link2F;
            obj.link2NV = link2NV;
            obj.link2V = link2V;
            obj.link2p = patch('faces', obj.link2F, 'vertices' , obj.link2V);
            set(obj.link2p, 'facec', 'flat');
            set(obj.link2p, 'EdgeColor','none');
            set(obj.link2p, 'FaceVertexCData', obj.link2C);
            
            %Create the end effector link of the robot arm
            obj.endeffC = endeffC;
            obj.endeffF = endeffF;
            obj.endeffNV = endeffNV;
            obj.endeffV = endeffV;
            obj.endeffp = patch('faces', obj.endeffF, 'vertices' , obj.endeffV);
            set(obj.endeffp, 'facec', 'flat');
            set(obj.endeffp, 'EdgeColor','none');
            set(obj.endeffp, 'FaceVertexCData', obj.endeffC);
            
            %Create the base of the gripper of the robot arm
            obj.gbaseC = gbaseC;
            obj.gbaseF = gbaseF;
            obj.gbaseNV = gbaseNV;
            obj.gbaseV = gbaseV;
            obj.gbasep = patch('faces', obj.gbaseF, 'vertices' , obj.gbaseV);
            set(obj.gbasep, 'facec', 'flat');
            set(obj.gbasep, 'EdgeColor','none');
            set(obj.gbasep, 'FaceVertexCData', obj.gbaseC);
            
            %Create the grips of the gripper
            obj.ggC = ggC;
            obj.ggF = ggF;
            obj.ggV = ggV;
            obj.gg1NV = gg1NV;
            obj.gg2NV = gg2NV;
            obj.gg1p = patch('faces', obj.ggF, 'vertices' , obj.ggV);
            set(obj.gg1p, 'facec', 'flat');
            set(obj.gg1p, 'EdgeColor','none');
            set(obj.gg1p, 'FaceVertexCData', obj.ggC);
            obj.gg2p = patch('faces', obj.ggF, 'vertices' , obj.ggV);
            set(obj.gg2p, 'facec', 'flat');
            set(obj.gg2p, 'EdgeColor','none');
            set(obj.gg2p, 'FaceVertexCData', obj.ggC);
            
            %Set properties of the figure being used
            light;
            daspect([1 1 1]);
            view(3);
            axis([-30 30 -30 30 0 40]);
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            axis on;
            grid on;
            
            %Draw the robot in the ready position
         
            changePose(obj);
            
       end
       
       function [ out ] = trans(obj, x, y, z, xt, yt, zt)

            Rx = x*pi/180;
            Ry = y*pi/180;
            Rz = z*pi/180;

            out = [cos(Ry)*cos(Rz), -cos(Rx)*sin(Rz)+sin(Rx)*sin(Ry)*cos(Rz), sin(Rx)*sin(Rz)+cos(Rx)*sin(Ry)*cos(Rz),  xt; ...
            cos(Ry)*sin(Rz), cos(Rx)*cos(Rz)+sin(Rx)*sin(Ry)*sin(Rz), -sin(Rx)*cos(Rz)+cos(Rx)*sin(Ry)*sin(Rz),         yt; ...
             -sin(Ry),               sin(Rx)*cos(Ry),                       cos(Rx)*cos(Ry),                            zt; ...
             0,                             0,                                      0,                                  1];
       end
       
       function changePose(obj)
           
           
           try
                figure(obj.fig);
               
           
                T0 = trans(obj, 0, 0, obj.waist, 0, 0, 0);
                T1 = T0*trans(obj, 0, obj.shoulder, 0, 0, 0, 10);
                T2 = T1*trans(obj, 0, obj.elbow - obj.shoulder, 0, 10, 0, 0);
                T3 = T2*trans(obj, 0, obj.wrist - obj.elbow, 0, 10, 0, 0);
                T4 = T3*trans(obj, obj.twist, 0, 0, 2, 0, 0);
                T5 = T4*trans(obj, 0,0,0,4,-obj.gSpread,0);
                T6 = T4*trans(obj, 0,0,0,4,obj.gSpread,0);
           
                basenv = T0*obj.baseNV;
                set(obj.basep,'Vertices',basenv(1:3,:)'); 

                link1nv = T1*obj.link1NV;
                set(obj.link1p,'Vertices',link1nv(1:3,:)');

                link2nv = T2*obj.link2NV;
                set(obj.link2p,'Vertices',link2nv(1:3,:)'); 

                endeffnv = T3*obj.endeffNV;
                set(obj.endeffp,'Vertices',endeffnv(1:3,:)');
           
                gbasenv = T4*obj.gbaseNV;
                set(obj.gbasep,'Vertices',gbasenv(1:3,:)');
                
                gg1nv = T5*obj.gg1NV;
                set(obj.gg1p,'Vertices',gg1nv(1:3,:)');
                
                gg2nv = T6*obj.gg2NV;
                set(obj.gg2p,'Vertices',gg2nv(1:3,:)');
                
                drawnow;
                
           catch exceptions
                initGraphics(obj);
           end
       end
       
    end
    
    methods(Static)
                
        function obj = instance()
            persistent uniqueInstance
            if isempty(uniqueInstance) || ~isvalid(uniqueInstance)
                obj = sim150();
                uniqueInstance = obj;
            else
                obj = uniqueInstance;
            end
        end
    end
    
    methods
       
        function quit(obj)
            obj.delete();
        end
        
        function home(obj)
            %HOME Home the arm.
            %R.HOME() will home R.
                %Do Nothing, Not needed by simulator.
        end
           
        function ready(obj)
            %READY Move the arm the ready position.
            %R.READY() will move R to the ready position.

            madeg(obj, [0,90,0,0,0]);
        end
        
        function open(obj)
            %OPEN Open the gripper.
            %R.OPEN() will open the gripper.
         
            if obj.gSpread == 0
                for x = 0:obj.speedStep/100:1.5
                    obj.gSpread = x;
                    changePose(obj);
                end
            end
        end
        
        function close(obj)
            %CLOSE Close the gripper.
            %R.CLOSE() will close the gripper.
         
            if obj.gSpread == 1.5
                for x = 1.5:-obj.speedStep/100:0
                    obj.gSpread = x;
                    changePose(obj);
                end
            end
        end
        
        function ma(obj, J)
            madeg(obj, [J(1)*180/pi, J(2)*180/pi, J(3)*180/pi, J(4)*180/pi, J(5)*180/pi]);
        end
        
        
        function [isvalid, K] = checkrange(obj, J)
            isvalid = 1;
            K = [];
            if J(1) < -175 || J(1) > 175
                isvalid = 0;
                K = [1];
            end
            if J(2) < 0 || J(2) > 110
                isvalid = 0;
                K = [K 2];
            end
            if J(3)-J(2) < -125 || J(3)-J(2) > 0
                isvalid = 0;
                K = [K 3];
            end
            if J(4)-J(3) < -110 || J(4)-J(3) > 110
                isvalid = 0;
                K = [K 4];
            end
            if J(5) < -180 || J(5) > 180
                isvalid = 0;
                K = [K 5];
            end
        end
        
        function result = madeg(obj, x)
            %MADEG Set the joint angles of the arm in degrees.
            %R.MADEG(J) will set the joint angles of R to the angles in
            %degrees given by J in a manner consistent with the robot arm
            %convention (joints 2, 3, and 4 measured relative to the
            %horizon
            %
            %RESULT = R.MADEG(J) will also return a result string that will
            %be empty if the command succeeded; otherwise an error message
            %will be returned indicating the joints that were out of range.
         
            [isvalid, K] = obj.checkrange(x);
            if isvalid
                result = [];
                x(2) = -x(2);
                x(3) = -x(3);
                x(4) = -x(4);
               
               
                angleDiffs = zeros(1,5);

                angleDiffs(1) = obj.waist - x(1);
                angleDiffs(2) = obj.shoulder - x(2);
                angleDiffs(3) = obj.elbow - x(3);
                angleDiffs(4) = obj.wrist - x(4);
                angleDiffs(5) = obj.twist - x(5);

                animationMax = max(abs(angleDiffs(:)));

                animationLength = length(1:obj.speedStep:animationMax);

                for i = 1:animationLength
                    if obj.waist + obj.speedStep < x(1)
                        obj.waist = obj.waist + obj.speedStep;
                    elseif obj.waist - obj.speedStep > x(1)
                        obj.waist = obj.waist - obj.speedStep;
                    else
                        obj.waist = x(1);
                    end

                    if obj.shoulder + obj.speedStep < x(2)
                        obj.shoulder = obj.shoulder + obj.speedStep;
                    elseif obj.shoulder - obj.speedStep > x(2)
                        obj.shoulder = obj.shoulder - obj.speedStep;
                    else
                        obj.shoulder = x(2);
                    end

                    if obj.elbow + obj.speedStep < x(3)
                        obj.elbow = obj.elbow + obj.speedStep;
                    elseif obj.elbow - obj.speedStep > x(3)
                        obj.elbow = obj.elbow - obj.speedStep;
                    else
                        obj.elbow = x(3);
                    end

                    if obj.wrist + obj.speedStep < x(4)
                        obj.wrist = obj.wrist + obj.speedStep;
                    elseif obj.wrist - obj.speedStep > x(4)
                        obj.wrist = obj.wrist - obj.speedStep;
                    else
                        obj.wrist = x(4);
                    end

                    if obj.twist + obj.speedStep < x(5)
                        obj.twist = obj.twist + obj.speedStep;
                    elseif obj.twist - obj.speedStep > x(5)
                        obj.twist = obj.twist - obj.speedStep;
                    else
                        obj.twist = x(5);
                    end

                    changePose(obj);
                end

                obj.waist = x(1);
                obj.shoulder = x(2);
                obj.elbow = x(3);
                obj.wrist = x(4);

                changePose(obj);

            else
                result = ['Joints out of range: ' ...
                        sprintf('%d', K(1)) sprintf(' %d', K(2:end))];
            end
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

        function [T, J, theta] = getpose(obj)
            %GETPOSE Get the current pose of the robot.
            %T = R.GETPOSE() will return the 4x4 homogeneous pose matrix of the
            %robot manipulator (frame 5) relative to the robot base (frame 0).
            %
            %[T, J] = R.GETPOSE() also returns the joint angles J using the
            %robot joint angle convention (joints 3, 4, and 5 measured
            %relative to the horizon. The angles are in degrees.
            %
            %[T, J, THETA] = R.GETPOSE() also returns the joint angles THETA
            %using the Java simulator/Denavit-Hartenberg convention. The
            %angles are in degrees.
         
            J = [obj.waist, -obj.shoulder, -obj.elbow, -obj.wrist, obj.twist];
            
            % convert robot angles to DH angles
            theta = [J(1), J(2), J(3) - J(2), J(4) - J(3), J(5)] * pi/180;
            a = [0 10 10 0 0];
            alpha = [90 0 0 -90 0] * pi/180;
            d = [10 0 0 0 2];
            T = dh(a, alpha, d, theta);
            
            % DH angles in degrees
            theta = [J(1), J(2), J(3) - J(2), J(4) - J(3), J(5)];
        end
        
        function speed(obj, x)
            %SPEED Set the speed of the robot.
            %R.SPEED(X) sets the speed of the robot to X.
         
            x = round(x);
            if x > 0 && x <= 100
                obj.speedStep = 4*(x/100);
            end
        end
        

    end
    
end

