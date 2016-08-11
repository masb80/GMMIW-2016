clear all

% load whole thing.
load('data_B.mat');

% find a full charge discharge cycle.
j = 1;
for i = 1:length(data)
    if data(i,2) == 3 || data(i,2) == 4 || data(i,2) == 5
        data_full_1(j,:) = data(i,:);
        j = j+1;
    end
end

% units right (mV to V).
data_full_1(:,4) = data_full_1(:,4)./1000;

first_ID = find(data_full_1(:,2) == 3);
second_ID = find(data_full_1(:,2) == 4);
third_ID = find(data_full_1(:,2) == 5);

t_discharge = data_full_1(third_ID,3)./60;
E_discharge = data_full_1(third_ID,4);

t_charge = data_full_1(first_ID,3)./60;
E_charge = flip(data_full_1(first_ID,4));

space_to_fill = length(E_discharge)-length(E_charge);
to_fill_E = zeros(space_to_fill,1)+E_charge(1,1);
to_fill_t = zeros(space_to_fill,1)+t_charge(1,1);

E_charge = [to_fill_E; E_charge];
t_charge = data_full_1(first_ID,3)./60;
t_charge = [to_fill_t; t_charge];
t_diff = t_discharge(end)-t_charge(end);
t_charge = t_charge+t_diff;
t_ini = t_charge(1);

t = data_full_1(:,3);
E = data_full_1(:,4);

t = t/t(end);
t_charge = t_charge/t_charge(end);
t_discharge = t_discharge/t_discharge(end);

% interpolation (average)
E_av = (E_charge(space_to_fill+1:end)+E_discharge(space_to_fill+1:end))/2;
t_av = t_discharge(space_to_fill+1:end);

% and add a straight line at the beginning.
x1 = 0;
y1 = 4.195;
x2 = t_av(1);
y2 = E_av(1);

m = (y2-y1)/(x2-x1);
x = t_discharge(1:space_to_fill);
y = m.*(x-x1)+y1;

E_av = [y; E_av];
t_av = t_discharge;

%%% spline.

E_av_spline = spline(t_av,E_av);

E_av_der_1 = fnder(E_av_spline,1);
E_av_der_2 = fnder(E_av_spline,2);

E_prime_1 = ppval(E_av_der_1,t_av);
E_prime_2 = ppval(E_av_der_2,t_av);

% plot stuff.
end_point = length(t_discharge);

figure(1);
plot(t_discharge(1:10:end_point),E_discharge(1:10:end_point),'or','MarkerSize',4);
hold on
plot(t_charge(1:10:end_point),E_charge(1:10:end_point),'ob','MarkerSize',4);
hold on
plot(t_av(1:10:end_point),E_av(1:10:end_point),'ok','MarkerSize',4);
hold on
plot(t_av,ppval(E_av_spline,t_av),'-k','LineWidth',2);

xlabel('State of Discharge')
ylabel('V')
title('C/2 case')

legend('data points for discharge','data points for charge','iterpolation (average of two curves)','spline approximation','Location','southwest')

axis square

figure(2);
plot(t_av,ppval(E_av_spline,t_av),'-k','LineWidth',2);
hold on

% figure(3)
% plot(t_av,E_prime_1,'-k','LineWidth',2);
% 
% ylabel('dV/dt')
% 
% axis ([0 0.95 -4 0])
% axis square
% 
% figure(4)
% plot(t_av,E_prime_2,'-k','LineWidth',2);
% 
% ylabel('d^2V/dt^2')
% 
% % axis ([0 0.95 -50 40])
% axis square

% integration

R1 = 0.11;
R1C = -1.05;

V = zeros(1,length(t_av));
V(1) = 4.195;

for t_step = 2:length(t_av)
    t_step_value = t(t_step);
   
    pt1 = exp(t_step_value/R1C)/R1C;
   
    E_av_to_integrate = ppval(E_av_spline,t_av);
    fun_int = exp(t(1:t_step)./R1C).*(R1C.*E_prime_1(1:t_step)+E_av_to_integrate(1:t_step)-R1*2);
    pt2 = trapz(t(1:t_step),fun_int);

    V(t_step) = pt1*pt2 + V(1);
end

figure(3);
plot(t_av,V,'-k','LineWidth',2);
hold on
plot(t_discharge,E_discharge,'-r','LineWidth',2);
axis square