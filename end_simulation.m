function [value, isterminal, direction] = end_simulation(t,y)

% stop if the cell voltage goes below 2.5
value(1) = y(4) -2.5;
isterminal(1) = 1;
direction(1) = 0;

% stop if the theta value is bigger than 1
value(2) = y(2) - 1;
isterminal(2) = 1;
direction(2) = 0;

end

