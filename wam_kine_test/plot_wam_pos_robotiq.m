clear, clc, close all
load('wam_pos_robotiq.mat')
flag_fkine = 1;
flag_plot = 1;
METER_TO_INCH = 39.3701;


%% Calculate forward kinematics
if flag_fkine
    syms t1 t2 t3 t4 t5 t6 t7 h1 d2 
    DH = [-90 0 0 0 0 0;...
          90 0 0 0 0 0;...
          -90 0.045 0.55 0 0 0;...
          90 -0.045 0 0 0 0;...
          -90 0 0.3 0 0 0;...
          90 0 0 0 0 0;...
          0 0 0.06 0 0 0];
    Robot1 = DH2Robot(DH,0);
%     tool = [0 10 0]*2.54/100;

%     tool = [-95 -30 135]  / 1000;
%     tool = [-2.46-.4 -1.5 5.658+4.814] * 2.54/100;
%     tool = [-1.5 -2.46 5.658+4.814] * 2.54/100;
    tool = [-3.3 -2.4 8.0000] * 2.54/100;
    Robot1.base = trotz(pi/2)*trotx(-pi/2);
    Robot1.tool = transl(tool);
    figure(100)
    Robot1.plot([-pi/2 -pi/2 0 0 0 0 0])
%     Robot1.plot(wam_pos,'fps',2)

    N = size(wam_pos,1);
    pos = zeros(N,3);

    for t = 1:N
        T = Robot1.fkine(wam_pos(t,:));
        p = transl(T);
        pos(t,1) = p(1);
        pos(t,2) = p(2);
        pos(t,3) = p(3);
    end
else
    load('square2.mat')
    N = size(pos,1);
end

%% Plot
if flag_plot
    figure(1)
    orient1 = pos(1:10,:)*METER_TO_INCH;
    orient2 = pos(11:end,:)*METER_TO_INCH;
    scatter(orient1(:,1),orient1(:,2),[],'r', 'filled')
    hold on
    scatter(orient2(:,1),orient2(:,2),[],'b', 'filled')
    legend('orient1','orient2')
    xlabel('x (in)')
    ylabel('y (in)')
    axis('equal')
end




