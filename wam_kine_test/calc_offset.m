function [ error ] = calc_offset(offset)
% Input x y z offset of robotiq gripper end effector from last joint
    error = 0;
    METER_TO_INCH = 39.3701;
    load('wam_pos_robotiq_grav.mat')
    wam_pos = recorded_pos;
    
    syms t1 t2 t3 t4 t5 t6 t7 h1 d2 
    DH = [-90 0 0 0 0 0;...
          90 0 0 0 0 0;...
          -90 0.045 0.55 0 0 0;...
          90 -0.045 0 0 0 0;...
          -90 0 0.3 0 0 0;...
          90 0 0 0 0 0;...
          0 0 0.06 0 0 0];
    Robot1 = DH2Robot(DH,0);

%     tool = [-1.5 -2.46 5.658+4.814] * 2.54/100;
    tool = [offset(1) offset(2) offset(3)] * 2.54/100;
    Robot1.base = trotz(pi/2)*trotx(-pi/2);
    Robot1.tool = transl(tool);
    figure(100)
    Robot1.plot([0 0 0 0 0 0 0])
    N = size(wam_pos,1);
    pos = zeros(N,3);

    for t = 1:N
        T = Robot1.fkine(wam_pos(t,:));
        p = transl(T);
        pos(t,1) = p(1);
        pos(t,2) = p(2);
        pos(t,3) = p(3);
    end
    
    pos = pos * METER_TO_INCH;
    
    for i = 1:11
        error = error + (pdist([pos(i,1:2);pos(i+1,1:2)])-2)^2;
    end
    error = error + (pdist([pos(12,1:2);pos(1,1:2)])-2)^2;
    
    for i = 1:3:7
        error = error + (pdist([pos(i,1:2);pos(i+3,1:2)])-6)^2;
    end
    error = error + (pdist([pos(7,1:2);pos(10,1:2)])-6)^2;
    
    for i = 3:3:9
        error = error + (pdist([pos(i,1:2);pos(i+2,1:2)])-sqrt(8))^2;
    end
    error = error + (pdist([pos(12,1:2);pos(2,1:2)])-sqrt(8))^2;
    

end

