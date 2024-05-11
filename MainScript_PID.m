close all;
clear;

%% initialize FPGA

fugihandle = fugiboard('Open', 'Pendulum1');
fugihandle.WatchdogTimeout = 0.5;
fugiboard('SetParams', fugihandle);
fugiboard('Write', fugihandle, 0, 0, 0, 0);  % dummy write to sync interface board
fugiboard('Write', fugihandle, 5, 1, 0, 0);  % reset position, activate relay
data = fugiboard('Read', fugihandle);        % get version info from FPGA
model = bitshift(data(1), -5); 
version = bitand(data(1), 31);
fprintf('FPGA setup %d, version %d\n', model, version); % for the B&P it should say 1 1, or else there is a problem
fugiboard('Write', fugihandle, 0, 1, 0, 0);  % end reset
pause(0.1);                         % give relay some time to respond
clear data

%% Sensors calibration
disp('Press enter when pendulum is in stable equilibrium...  (down)'); %theta1=pi
pause;
down_data = [];
for i = 1:100
    thetas = fugiboard('Read', fugihandle);
    thetas = thetas(6:7,:);
    down_data = [down_data, thetas];
end

disp('Press enter when pendulum is upright...');    %theta=0
pause;
up_data = [];
for i = 1:100
    thetas = fugiboard('Read', fugihandle);
    thetas = thetas(6:7,:);
    up_data = [up_data, thetas];
end

sensor_data = [down_data(1,:); up_data(1,:);
               down_data(2,:); up_data(2,:)];
mean_data = mean(sensor_data,2);  %first 3 are theta 1 (main arm) last 3 are theta2 (pendulum)

%theta1_calibration
g01 = mean_data(2);
g11 = (mean_data(2)-mean_data(1))/pi;
%theta2_calibration
g02 = mean_data(3);
g12 = (mean_data(3)-mean_data(4))/pi;

%clearing workspace
clear down_data mean_data sensor_data
clear thetas up_data i

%% CHECKPOINT AFTER CALIBRATION
close all;
clearvars -except fugihandle g01 g02 g11 g12 model version
%% GENERAL  SAMPLING PERIOD AND INITIAL CONDITIONS FOR SIMULATION
%----Sampling period
%\\\\\\
h=0.01; 
%\\\\\\

%///////// INITIAL CONDITION FOR SIMULATION
theta0 = [-pi;     pi/4];
thetadot0 = [0;0];

%% Parameters initialization

g  = 9.81;
l1 = 0.0897;
l2 = 0.1;
m1 = 0.2; %0.59634; %0.125;
m2 = 0.087972;
c1 = 0.01; %-0.04;
c2 = 0.07;
I1 = 0.01076; %0.074;
I2 = 0.0001;
b1 = 5.33518; %4.8;
b2 = 4e-05;
km = 42.2954;
te = 0.008;
%% Drawing pendulum with data
th1TimeSeries = out.th1;
th2TimeSeries = out.th2;
inputTimeSeries = 0;

for k=1:size(th2TimeSeries.Data)
    drawRotPend(0, 0, th1TimeSeries.Data(k),...
                th2TimeSeries.Data(k), 0, 0);
end