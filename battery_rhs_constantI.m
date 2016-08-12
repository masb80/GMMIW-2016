function dy = battery_rhs_constantI(t,y,param)

R = param.R;
C = param.C;
capacity = param.capacity;
current_target = param.current;
dtheta = param.dtheta;
EMF = param.EMF;

capv = y(1);
theta = y(2);
current = y(3);
cellv = y(4);

% work out E(theta) - linear interpolation
jtheta = floor(theta/dtheta);
frac = (theta - jtheta*dtheta)/dtheta;
E = EMF(jtheta+1) + frac*(EMF(jtheta+2)-EMF(jtheta+1));

dy = zeros(4,1); % column vector RHS

dy(1) = - capv/R/C-current/C; % capacitor voltage dv/dt
dy(2) = current/capacity; % discharge 
dy(3) = current - current_target; % fixed current 
dy(4) = cellv - E - capv;

end

