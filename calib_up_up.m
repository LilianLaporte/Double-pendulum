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
h=0.005; 
%\\\\\\
%----simulation initial condition
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
theta0 = [0;-pi];          %[theta1;theta2]
thetadot0 = [0;0];              %[thetadot1;thetadot2]
T0 = 0;                         % initial Torque
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
x0 = [thetadot0; theta0; T0];
%% MODEL LINEARIZATION
syms P1 P2 P3 g1 g2 b1 b2
syms th1 th2 dth1 dth2 ddth1 ddth2
syms T te km vin

M = [P1+P2+2*P3*cos(th2) P2+P3*cos(th2);
     P2+P3*cos(th2) P2];
C = [b1-P3*dth2*sin(th2) -P3*(dth1+dth2)*sin(th2);
     P3*dth1*sin(th2) b2];
G = [-g1*sin(th1)-g2*sin(th1+th2);
     -g2*sin(th1+th2)];
iM = inv(M);

%symbolic state of the system
state = [dth1;dth2;th1;th2;T];
%non-linear system function
f = [iM*[T;0]-iM*C*[dth1; dth2]-iM*G;
     dth1; dth2; -T/te+km*vin/te];

%LINEARIZATION POINT
x_eq = [0;0;0;0;0];
u_eq = 0;

%Linearized symbolic state space model
lA = [diff(f, dth1) diff(f, dth2) diff(f, th1) diff(f, th2) diff(f, T)];
lB = diff(f, vin);

clear M C G iM 
%% Parameters initialization

%parameters that work
g = 9.81;
l1 = 0.0897;
l2 = 0.1;
m1 = 0.2; %0.59634; %0.125;
m2 = 0.087972;
c1 = 0.01; %-0.09376; %-0.04;
c2 = 0.07;
I1 = 0.01076; %0.074;
I2 = 0.0001;
b1 = 5.33518; %4.8;
b2 = 4e-05;
km = 39.2954;
te = 0.01;%0.02;

%% Evaluation of the Continuous Time Linear System

%---Model paramters substitution 
%(only used to get linear system matrices! get cleared afterwards)
P1 = m1*c1^2 + m2*l1^2 + I1;
P2 = m2*c2^2 + I2;
P3 = m2*l1*c2;
g1 = (m1*c1+m2*l1)*g;
g2 = m2*c2*g;

% Assign physical parameters to linear system
nA = subs(lA);
nB = subs(lB);

% Substitute the linearization point
nA0 = subs(nA, state, x_eq);
nA0 = subs(nA0, vin, u_eq);
nB0 = subs(nB, state, x_eq);
nB0 = subs(nB0, vin, u_eq);

% Final CT Linearized system
A = eval(nA0);
B = eval(nB0);
C = [0 0 1 0 0;
      0 0 0 1 0];
D = 0;

clear lA lB nA nB nA0 nB0 f
clear ddth1 ddth2 dth1 dth2 th1 th2
clear vin T state P1 P2 P3 g1 g2

%% Continuous Time Linearized State Space Model
csys = ss(A, B, C, D);
csys.InputName = 'vin';
csys.OutputName = ['th1'; 'th2'];
csys.StateName = ["dth1";"dth2";"th1";"th2";"T"];
csys.Name = 'RotPend';
%% Discrete Controller and Observer Design

fprintf("\n\nController and Observer Eigenvalues : \n");
rank(ctrb(csys));
eig(A);

K = lqr(A, B, diag([10 20 200 110 10]), 350);
obs_x0 = [0;0;0;0;0];
rank(obsv(csys));
eig(A-eye(5,2)*C);
po = eig(A-B*K)*8; 
L = place(A', C', po).';

eig(A-B*K)
eig(A-L*C)

%% Drawing pendulum with data  %To use only if we want the animation
th1TimeSeries = th1_data;
th2TimeSeries = th2_data;
inputTimeSeries = input_data;

for k=1:size(th2TimeSeries.Data)
    drawRotPend(0, 0, th1TimeSeries.Data(k),th2TimeSeries.Data(k),...
                0, inputTimeSeries.Data(k));
end