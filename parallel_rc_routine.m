% Routine solve the DAE system for the RC circuit in parallel

% end time
T = 1;

a1 = 0.2; % Artificial number
a2 = 0.3; % Artificial number
r1 = 0.05; % Artificial number
r2 = 0.11 - r1; % 0.11 is the real value we got
c1 = 1.05 / r1; % 1.05 is a real value but c1 and c2 are artificial numbers
c2 = 1.05 / r2;

% Mass matrix
M = diag(ones(6,1));

% Last two rows in M are null to create the constrains equations
M(end-1,end-1) = 0;
M(end,end) = 0;
opts = odeset('Mass',M);


% Initial condition
y0 = [0 0 2 1 3./r1 2./ r2]; % Artificial initial conditions


% Solving for SOD's, voltages and currents
[t,y] = ode23t(@(t,y) parallel_rc(t,y,a1,a2,r1,r2,c1,c2), [0 T], y0, opts);

% Plotting the solutions
plot(t,y(:,1),'k*',t,y(:,2),'kx',t,y(:,3),'b*',t,y(:,4),'bx',t,y(:,5),'r*',t,y(:,6),'rx')
legend('SOD1','SOD2','Voltage 1','Voltage 2','Current 1','Current 2')
