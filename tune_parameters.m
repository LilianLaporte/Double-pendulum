%intial guess is made in calib

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial state 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta0 = [-pi;10*pi/12]; %[theta1;theta2]
thetadot0 = [0;0]; %[thetadot1;thetadot2]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data collection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MANUALLY create a vector theta = [th1.data, th2.data]
% in which you crop the useful data and its length to compare with
% simulation

L = 500;  %don't go to far above 500

g = 9.81;
l1 = 0.1;
l2 = 0.1;
m1 = 0.125;
m2 = 0.0528;
c1 = -0.04;
c2 = 0.0644;
I1 = 0.074;
I2 = 0.0001;
b1 = 4.8;
b2 = 0.00005;
km = 50;
te = 0.03;

init_param = [m2, c2, b2, l2, I2]; %initial guess for the value 
                                   %(can be a vector [a, b, c])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nonlinear optimization
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPT = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','TolX',1e-7,'MaxIter', 25,...
%     'FiniteDifferenceStepSize', 1e-5);%, 'SpecifyObjectiveGradient',true); % options
OPT = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','MaxIter', 25,...
    'FiniteDifferenceStepSize', 1e-7);%, 'SpecifyObjectiveGradient',true); % options
% OPT = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
%OPT = optimset('MaxIter', 25);

f = @(x)costfun(x, theta(1:L,2), L, h); %a function handle 
                                        %calling f onlz requires parameter x
                                        %which will be the candidate parameters
lb = [0,-Inf, 0, 0, 0];
ub = [];

format long;
[est_param, fval] = lsqnonlin(f,init_param,lb,ub,OPT) % actual optimization

colname = {'m2','c2', 'b2', 'l2', 'I2'};
est_param_table = array2table(est_param,'VariableNames',colname)
