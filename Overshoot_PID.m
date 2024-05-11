%% Initialisation
th1_ov = csvread('data\overshoot_th1.csv');
th2_ov = csvread('data\overshoot_th2.csv');
t1 = linspace(0,size(th1_ov,1),size(th1_ov,1)/h);
t2 = linspace(0,size(th2_ov,1),size(th2_ov,1)/h);
plot(th2_ov)

%% Get overshoot interval
ts1 = 1670;
te1 = 1924;
ts2 = 1689;
te2 = 1924;

th1_ov = th1_ov(ts1:te1);
t1 = t1(ts1:te1);
th2_ov = th2_ov(ts2:te2);
t2 = t2(ts2:te2);

th1_ov = th1_ov';
th2_ov = th2_ov';

%% Compute overshoot
S1 = stepinfo(th1_ov,t1)
t1(1)
S2 = stepinfo(th2_ov,t2)
t2(1)


