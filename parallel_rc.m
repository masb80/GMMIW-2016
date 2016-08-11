function output = parallel_rc(t,y,a1,a2,r1,r2,c1,c2)

output = zeros(6,1);

% e1, e2 and I can be functions of t, SOD, voltage and current
e1 = 2;
e2 = 2;
I = 5;

% Writing the system of ODE
output(1) = a1 .* y(5);
output(2) = a2 .* y(6);
output(3) = -1 ./ c1 .* (y(5) + y(3) ./ r1);
output(4) = -1 ./ c2 .* (y(6) + y(4) ./ r2);
output(5) = e1 - e2 + y(3) - y(4) + r1 .* y(5) - r2 .* y(6);
output(6) = y(5) + y(6) - I;
