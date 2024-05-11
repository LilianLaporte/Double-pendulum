function e = costfun(x,theta,L, h)
% cost function for nonlinear parameter tuning
% x contains the candidate parameters, U is the experimental input signal
% and y is the experiemental output signal

assignin('base','m2',x(1));       % assign candidate parameters to the 
assignin('base','c2',x(2));
assignin('base','b2',x(3));       % values in workspace, used in simulink simulation
assignin('base','l2',x(4));
assignin('base','I2',x(5));

simdata = sim('Non_linear_model', 1:h:100);  % simulate nonlinear model using 
                                             % assigned candidate parameter                                        
                                       
thetam = simdata.yout{1}.Values.Data(1:L,2);

%----theta processing-----

e = theta-thetam;                       % residual (error)

% you can comment the below line to speed up
figure(1); stairs(simdata.tout(1:L),[theta thetam]);   % intermediate fit
