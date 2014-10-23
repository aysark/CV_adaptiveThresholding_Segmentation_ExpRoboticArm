% Aysar Khalid and Gonghe Shi
% Problem 2: Playing with the Robot
% The following function moves the arm to the given XYZ coordinate
% x,y,z are inputs which reprents the coordinates of the target position.
% f1,f2,f3,are the angles as represented in the graph in the assignment question.
% f1,f2,a150_f3 are the angles based on which the arm would move(waist shoulder elbow). 
function [f1,f2,f3] = p2(x,y,z, a150)
%function [f1,f2,f3] = move_arm(x, y, z, a150)
l = 10; % length of link is 10 inches.

% based on the calculation in the report
% x^2 + y^2 + z^2 = 2L^2(1+cosf3) 
% so f3 = acos(((x^2 + y^2 + z^2)/(2*l^2)) - 1)
% the abs() is meant to get rid of the complex solution of f3.
f3 = abs(acos(((x^2 + y^2 + z^2)/(2*l^2)) - 1));

% definitions for r_a, r_b, which makes 
% r = l * sqrt((1+cosf3)^2+(sin(f3))^2)) easier to write.
r_a = (1+cos(f3))^2; 
r_b = (sin(f3))^2;
r = l * sqrt(r_a+r_b);

% definitions for q_a, q_b, which makes 
% q = atan2((l* (1+ cos(f3))/r)*1.0,(q_b = l* sin(f3)/r)*1.0)
% easier to write.
q_a = l* (1+ cos(f3));
q_b = l* sin(f3);

% calculate for q
q = atan2((q_a/r)*1.0,(q_b/r)*1.0);

% calculate for f_1 f_2 and a150_f3.
f2 = q + atan2(z/r, sqrt(x^2 + y^2)/r);
f1 = atan(y/x);

%input angle for the elbow joint of arm
a150_f3 = f2 - f3;

% the range of angles allowed for waist joint is -175 degree to 175 degree
if (f1 >= 175*(pi/180))
    disp('angle for waist > the allowed max value, angle setted to 175 degree');
    f1 = 175*(pi/180);
elseif (f1 <= -175*(pi/180))
    disp('angle for waist < the allowed min value, angle setted to -175 degree');
    f1 = -175*(pi/180);
end


% the range of angles allowed for shoulder joint is 0 degree to 110 degree    
if (f2 >= 110*(pi/180))
    disp('angle for shoulder > the allowed max value, angle setted to 110 degree');
    f2 = 110*(pi/180);
elseif (f2 <= 0)
    disp('angle for shoulder < the allowed min value, angle setted to 0 degree');
    f2 = 0;
end

% the range of angles allowed for elbow joint is -125 degree to 0 degree
if (a150_f3 >= 0)
    disp('angle for elbow > the allowed max value, angle setted to 0 degree');
    a150_f3 = 0;
elseif (a150_f3 <= -125*(pi/180))
    disp('angle for elbow < the allowed min value, angle setted to -125 degree');
    a150_f3 = -125*(pi/180);
end

% angles of the inputs for a150 in degrees
K = [f1*(180/pi) f2*(180/pi) a150_f3*(180/pi) 0 0]

% angles of the inputs for a150 in radians
J = [f1 f2 a150_f3 0 0]
a150.madeg(K)
end