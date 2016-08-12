%
% General solver for a single cell battery run under different conditions 
% Uses a fitted equivalent circuit model
%

% 
% Uses ode23t as a DAE solver. The unknowns in order are 
% 1. Capacitor voltage 
% 2. SOD dimensionless parameter
% 3. Current 
% 4. Cell voltage 

% battery parameters passed to ODE RHS 

param.R = 0.11; % equivalent circuit resistance in ohms 
RC = 85; % Characteristic time in seconds 
param.C = RC/param.R; % equivalent circuit capacitance 
param.capacity = 3200*3600*1e-3; % mAh converted to Coulombs
param.current = 1.6; % constant current operation in Amps

% Spline of EMF fit

load('EMF');

param.dtheta = theta(2)-theta(1);
param.EMF = [EMF(1:end-1); 2.5; 2.4; 2.3; 2.2];

% Mass matrix. Variables 1 and 2 are differential, 3 and 4 are algebraic

M = sparse(4,4);
M(1,1) = 1;
M(2,2) = 1;
M(3,3) = 0;
M(4,4) = 0;

% ODE options set the mass matrix to distinguish differential from 
% algebraic equations and sets the event function to stop the computation
% at cell voltage 2.5 
ode_options = odeset('Mass',M,'Events',@end_simulation);

v = 0;
theta = 0;
I = param.current;
V = EMF(1);

y0 = [v; theta; I; V];

[t, y] = ode15s(@(t,y)battery_rhs_constantI(t,y,param),[0 8000], y0, ode_options);


