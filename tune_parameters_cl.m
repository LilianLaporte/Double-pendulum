%intial guess is made in calib

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial state 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta0 = [0;-pi]; %[theta1;theta2]
theta0 = [-pi;-pi]; %[theta1;theta2]
% theta0 = [-pi/2;-pi/2]; %[theta1;theta2]
thetadot0 = [0;0]; %[thetadot1;thetadot2]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data collection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MANUALLY create a vector theta = [th1.data, th2.data]
% in which you crop the useful data and its length to compare with
% simulation

Lf = 5/h;  %don't go to far above 500

g = 9.81;
l1 = 0.0897;
l2 = 0.1;
m1 = 0.53513;
m2 = 0.0528;
c1 = 0.025;
c2 = 0.0644;
I1 = 0.018544;
I2 = 8.3382e-5;
b1 = 5.33518;
b2 = 3.7644e-5;
km = 39.2954;
te = 0.00258;

init_param = [km, te];%, m1, c1, b1, l1, I1];%, m2, c2, b2, l2, I2]; %initial guess for the value 
                                   %(can be a vector [a, b, c])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nonlinear optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OPT = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','MaxIter', 25,...
    'FiniteDifferenceStepSize', 1e-4);%, 'SpecifyObjectiveGradient',true); % options
% OPT = optimset('MaxIter', 25);

f = @(x)costfun_cl(x, theta(1:Lf,1), Lf, h, inputdata); %a function handle 
                                 %calling f onlz requires parameter x
                                 %which will be the candidate parameters
lb = [1e-6, 1e-3];%, 1e-6,0, 1e-6, 1e-6, 0.01];%, 0.0527, 0.0643, 3.7643e-5, 0.099,8.3381e-5];
ub = [100, 0.1];%, 0.2, 1, 10, 1, 0.15];%, 0.0529, 0.0645, 3.7645e-5, 0.11, 8.3383e-5];
format long;
[est_param, fval] = lsqnonlin(f,init_param,lb,ub,OPT) % actual optimization

colname = {'km','te'};%,'m1','c1', 'b1', 'l1', 'I1'};%, 'm2','c2', 'b2', 'l2', 'I2'};
est_param_table = array2table(est_param,'VariableNames',colname)