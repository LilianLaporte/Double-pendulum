close all;
clear;

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

%% LINEARIZATION POINT

%POSITIO   |    x_eq        |   u_eq
%up up      [0;0;0;0;0]           0
%down up    [0;0;-pi;-pi;0]       0
%up down    [0;0;0;-pi;0]         0
%down down  [0;0;-pi;0;0]         0

x_eq = [0;0;0;-pi;0];
u_eq = 0;

%Linearized symbolic state space model
lA = [diff(f, dth1) diff(f, dth2) diff(f, th1) diff(f, th2) diff(f, T)];
lB = diff(f, vin);

clear M C G iM 
%% Parameters initialization

g = 9.81;
l1 = 0.0897;
l2 = 0.1;
m1 = 0.2;
m2 = 0.087972;
c1 = 0.01;
c2 = 0.07;
I1 = 0.01076;
I2 = 0.0001;
b1 = 5.33518;
b2 = 4e-05;
km = 39.2954;
te = 0.01;

%% Evaluation of the Continuous Time Linear System

%---Model paramters substitution 
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
%% CONTROLLABILITY

fprintf("\n\nControlability : \n");
disp(rank(ctrb(csys)));
fprintf("\n\nStability : \n");
disp(eig(A));