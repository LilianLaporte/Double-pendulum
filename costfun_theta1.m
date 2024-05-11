function e = costfun_theta1(x,theta,Lf, h, inputdata)
% cost function for nonlinear parameter tuning
% x contains the candidate parameters, U is the experimental input signal
% and y is the experiemental output signal

assignin('base','km',x(1));
assignin('base','te',x(2));
assignin('base','m1',x(3));       % assign candidate parameters to the 
assignin('base','c1',x(4));       % values in workspace, used in simulink simulation
assignin('base','b1',x(5));       
assignin('base','l1',x(6));
assignin('base','I1',x(7));

t = (0:h:3)';                      %creating step signal

simdata = sim('Non_linear_model', t, [], [t inputdata]);  % simulate nonlinear model using 
                                                     % assigned candidate parameter
                                       
thetam = simdata.yout{1}.Values.Data(1:Lf,:);

%----theta processing-----

e = theta-thetam;                       % residual (error)

% you can comment the below line to speed up
h1=figure(1);
set(h1,'Position',[100 100 2000 1000])
stairs(simdata.tout(1:Lf),[theta thetam]);   % intermediate fit
lgd = legend({'$\theta_1$', '$\theta_2$', '$\tilde{\theta_1}$', '$\tilde{\theta_2}$'}, 'Interpreter','latex', 'Location', 'northwest');
lgd.FontSize = 14;