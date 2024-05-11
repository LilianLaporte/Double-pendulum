%% Read Files
filename = 'data\step_input_2.csv';
inputdata = csvread(filename);
filename = 'data\step_response_2.csv';
theta = csvread(filename);

%% Compute difference with input
theta0 = [-pi;0];   %[theta1;theta2]
% theta0 = [0;-pi];   %[theta1;theta2]
% theta0 = [-pi/2;-pi/2];   %[theta1;theta2]

Lf = 3/h;           %don't go to far above 500
t = (0:h:3)';       %creating step signal

inputdata = inputdata(1:Lf+1);
simdata = sim('Non_linear_model', t, [], [t inputdata]);  % simulate nonlinear model using 
% simdata = sim('constrained_second_link2', t, [], [t inputdata]);  % simulate nonlinear model using 
                                       
thetam = simdata.yout{1}.Values.Data(1:Lf,:);
theta = theta(1:Lf,:);

%----theta processing-----

fit = goodnessOfFit(thetam,theta,'NMSE');
colname = {'nmse theta1','nmse theta2'};
nmse_result = array2table(fit','VariableNames',colname)

% you can comment the below line to speed up
h1=figure(1);
stairs(simdata.tout(1:Lf),[theta thetam]);
lgd = legend({'$\theta_1$', '$\theta_2$', '$\tilde{\theta_1}$', '$\tilde{\theta_2}$'}, 'Interpreter','latex', 'Location', 'northwest');
lgd.FontSize = 14;

%% Read Files
filename = 'data\3_quarter_pi_2.csv';
theta = csvread(filename);

%% Compute difference without input
theta0 = [-pi;3*pi/4];   %[theta1;theta2]
% theta0 = [0;-pi];   %[theta1;theta2]
% theta0 = [-pi/2;-pi/2];   %[theta1;theta2]

Lf = 3/h;           %don't go to far above 500
t = (0:h:3)';       %creating step signal

simdata = sim('Non_linear_model', 0:h:3);  % simulate nonlinear model using 
                                       
thetam = simdata.yout{1}.Values.Data(1:Lf,2);
theta = theta(1:Lf,2);

%----theta processing-----

% e = theta-thetam;                       % residual (error)
% square_err = e.^2;
% mse = sum(square_err)./Lf;
% theta_shift = theta-mean(theta);
% square_theta_shift = theta_shift.^2;
% mse0 = sum(square_theta_shift);
% nmse = mse.*100./mse0;
fit = goodnessOfFit(thetam,theta,'NMSE');
colname = {'nmse theta2'};
nmse_result = array2table(fit','VariableNames',colname)

% you can comment the below line to speed up
h1=figure(1);
stairs(simdata.tout(1:Lf),[theta thetam]);
lgd = legend({'$\theta_2$', '$\tilde{\theta_2}$'}, 'Interpreter','latex', 'Location', 'northwest');
lgd.FontSize = 14;