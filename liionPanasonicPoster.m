%filename = 'Panasonic-NCR18650B-C-over2-C-over-4-completed-for Students.xlsx';
clear all
clc
clf
fileB = 'Panasonic-BData.xlsx';
fileC = 'Panasonic-CData.xlsx';
A = xlsread(fileC);
%B = xlsread(fileC);
[m, n]=size(A);
CycleID=A(:,1);
StepID = A(:,2);
TimeS = A(:,3);
VolmV = A(:,4);
CurmA = A(:,5);
CRateB=0.5;
StepIDmax = max(StepID);
TimeHTotal=[];
tend=0.0;
for i=1:StepIDmax
    indCyc = find(StepID == i);
    TimeHTotal = [TimeHTotal; tend+TimeS(indCyc)/3600];
    tend=tend+TimeS(indCyc(end))/3600;
end
%--------Integration loop for Capacity & Power --------------------------
Capacity(1)=0;
Power(1) = 0;
Power(1)=0;
kk=1;
for j=1:m-1   
     deltat = TimeHTotal(j+1) - TimeHTotal(j);
      if deltat == 0.0 & CurmA(j)*CurmA(j+1)<0
          CapacityMag(kk)= Capacity(j);
          Capacity(j)=0;
          Power(j)=0;
          kk = kk+1;
      end
      Capacity(j+1)=Capacity(j)+deltat*CurmA(j);
      Power(j+1)=Power(j)+deltat*VolmV(j)*CurmA(j);
end
figure(1)
subplot(3,1,1);
plot(TimeHTotal,A(:,5)/1000,'g-')
ylabel('Current (mA)') 
title('Charge Characteristics')
subplot(3,1,2);
plot(TimeHTotal,A(:,4)/1000,'b-')
ylabel('Voltage (V)')
subplot(3,1,3);
plot(TimeHTotal,Capacity,'r.')
ylabel('Capacity (mAh)')
xlabel('Time (h)') 

figure(2)
indChargeCapacity=find(CapacityMag>0);
indDisChargeCapacity=find(CapacityMag<0);
plot(smooth(CapacityMag(indChargeCapacity)),'bo-')
hold on 
plot(smooth(abs(CapacityMag(indDisChargeCapacity(2:end)))),'ro-')
ylabel('Capacity (mAh)')
xlabel('Cycle Count') 
legend('Charge:','Discharge:')
title('Cycle Life Characteristics')

figure(3)
oneCyc=2455:3820;
TimeOneCyc = TimeHTotal(oneCyc) - min(TimeHTotal(oneCyc));
plot(TimeOneCyc,A(oneCyc,5)/1000,'g-')
hold on
plot(TimeOneCyc,A(oneCyc,4)/1000,'b-')
hold on
plot(TimeOneCyc,Capacity(oneCyc)/1000,'r')
title('Charge Characteristics')
ylabel('Voltage (V)')
xlabel('Time (h)') 
legend('Current','Voltage','Capacity')
hold off


figure(4)
%ind=find(Capacity(1:1726)<0);
ind = find(CurmA< -0.99 & TimeHTotal>5) ;
plot(abs(Capacity(ind)),VolmV(ind)/1000,'r.')
xlabel('Discharge Capacity (mAh)')
ylabel('Voltage (V)')

figure(5)
indPowp=find(Power>=0);
indPown=find(Power<0);
plot(TimeHTotal(indPowp),Power(indPowp),'b.')
hold on
plot(TimeHTotal(indPown),Power(indPown),'r.')
hold off
ylabel('Power')
xlabel('Time (h)') 
legend('Power In','Power Out')