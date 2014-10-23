function T = dh(a, alpha, d, theta, start, stop)

if nargin == 4
    start = 1;
    stop = length(a);
end

T = eye(4);
for k = start:stop
    Tk = rz(theta(k)) * dz(d(k)) * dx(a(k)) * rx(alpha(k));
    T = T * Tk;
end





function R = rz(theta)

R = [cos(theta) -sin(theta) 0 0;
     sin(theta)  cos(theta) 0 0;
     0 0 1 0;
     0 0 0 1];

function R = rx(alpha)

R = [1 0 0 0;
     0 cos(alpha) -sin(alpha) 0;
     0 sin(alpha)  cos(alpha) 0;
     0 0 0 1];

function D = dz(d)

D = [eye(3) [0 0 d]';
     0 0 0 1];

function D = dx(d)

D = [eye(3) [d 0 0]';
     0 0 0 1];
