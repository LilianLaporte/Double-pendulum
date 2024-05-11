function drawRotPend(dth1data, dth2data, th1data, th2data, Tdata, u)

state = [dth1data dth2data th1data th2data Tdata];

bw = 0.5;
arm1 = 3;
arm2 = 3;
m1x = -arm1*sin(state(3));
m1y = arm1*cos(state(3));
m2x = m1x - arm2*sin(state(3)+state(4));
m2y = m1y + arm2*cos(state(3)+state(4));


plot([0 m1x],[0 m1y],'k','LineWidth',2), hold on; %draw arm 1
plot([m1x m2x],[m1y m2y],'k','LineWidth',2); %draw arm 2

text(7,3, 'v_{in} = '+string(u)+' V');
% text(7,1.8, '\partial_t \theta_1 = '+string(state(1)));
% text(7,0.6, '\partial_t \theta_2 = '+string(state(2)));
text(7,-0.6, '\theta_1 = '+string(state(3)));
text(7,-1.8, '\theta_2 = '+string(state(4)));
% text(7,-3, 'T = '+string(state(5)));

rectangle('Position',[-bw/2,-bw/2,bw,bw],...
    'Curvature',1,'FaceColor',[0 0 0],...
    'LineWidth',1.5); %draw motor
rectangle('Position',[m1x-bw/2,m1y-bw/2,bw,bw],...
    'Curvature',1,'FaceColor',[0.4 0.4 0.4],...
    'LineWidth',1.5); %draw mass 1
rectangle('Position',[m2x-bw/2,m2y-bw/2,bw,bw],...
    'Curvature',1,'FaceColor',[0.4 0.4 0.4],...
    'LineWidth',1.5); %draw mass 2

axis equal
xlim([-7 13]);
ylim([-7 7]);
set(gcf,'Position',[100 100 500 400])
%drawnow, hold off
pause(0.001), hold off