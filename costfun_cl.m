function e = costfun_cl(x,theta,Lf, h, inputdata)
% cost function for nonlinear parameter tuning
% x contains the candidate parameters, U is the experimental input signal
% and y is the experiemental output signal

assignin('base','km',x(1));
assignin('base','te',x(2));

t = (0:h:Lf*h)';                      %creating step signal

simdata = sim('constrained_second_link2', t, [], [t inputdata]);  % simulate nonlinear model using 
                                                                  % assigned candidate parameter
% simdata = sim('Non_linear_model', t, [], [t inputdata]);  
                                       
thetam = simdata.yout{1}.Values.Data(1:Lf,1);

%----theta processing-----

e = theta-thetam;                       % residual (error)

% you can comment the below line to speed up
figure(1); stairs(simdata.tout(1:Lf),[theta thetam]);   % intermediate fit