clear, clc, close all
load('wam_jp2.mat')
load('btf2.mat')
flag_fkine = 1;
flag_process = 1;
flag_plot = 1;
flag_animate_scatter = 0;
flag_animate_line = 0;

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
%     tool = [-2.46-.4 -1.5 5.658+4.814] * 2.54/100;
    tool = [-3.3 -2.4 8.0000] * 2.54/100;
%     tool = [1.5 -2.46 5.658+4.814] * 2.54/100;
    Robot1.base = trotz(pi/2)*trotx(-pi/2);
    Robot1.tool = transl(tool);

    N = size(wam_jp,1);
    pos = zeros(N,3);

    for t = 1:N
        T = Robot1.fkine(wam_jp(t,:));
        p = transl(T);
        pos(t,1) = p(1);
        pos(t,2) = p(2);
        pos(t,3) = p(3);
    end
else
    load('pos2.mat')
    N = size(pos,1);
end

%% Get wanted time intervals
if flag_process
    start_time = 1000; %ind
    swipe_time = 5; %s
    retreat_time = 10; %s
    num_swipe = 3;
    wanted_ind = [0];
    for i = 1:num_swipe
        chunk = (1:swipe_time*100) + retreat_time*100 + wanted_ind(end);
        wanted_ind = [wanted_ind chunk];
    end
    wanted_ind = wanted_ind + start_time;
    threshold_ind = [2258 4370 6493 8161 10208 12370 14497 16272];
    
    wanted_ind = [];
    

    %% Get rid of unwanted data points
%     for i = 1:N
%         if ~ismember(i,wanted_ind)
%             pos(i,:) = ones(1,3) * 100;
%         end
%     end
end


%% Plot
if flag_plot
    load('btf2.mat')
    figure(2)
    btf(1:2000) = btf(1:2000) + 0.55;
    btf(4380:4395) = btf(4380:4395) - 1;
    btf(6683:6689) = btf(6683:6689) - 2;
    btf(12370:12375) = btf(12370:12375) + 3;
    plot(btf)
    
    figure(1)
    offset = 270;
    scatter(pos(:,1),pos(:,2),[],btf(406-offset:end-offset))
    xlabel('x (m)')
    ylabel('y (m)')
%     axis([-0.3 0.2 -0.5 0.1])
    cb = colorbar;
    title(cb,'Force (N)')
    colormap jet
    caxis([0 2])
    
    figure(3)
    offset2 = 500;
    contact = [pos(threshold_ind-offset2,2) pos(threshold_ind-offset2,1)];
%     scatter([pos(threshold_ind-offset2,2)],[pos(threshold_ind-offset2,1)], 150,'filled')
    contact(1:3,1) = contact(1:3,1) + .1;
    contact(4,1) = contact(4,1) + 0.05;
    scatter(contact(:,1),contact(:,2), 150,'filled')
    axis([-0.5 0.1 -0.3 0.2])
    set(gca,'Xdir','reverse')
    legend('point of contact')
    xlabel('y (m)')
    ylabel('x (m)')
    axis equal
end

%% Animate scatter plot
if flag_animate_scatter
    v = VideoWriter('wam_btf_scatter.avi');
    v.FrameRate = 100;
    v.Quality = 100;
    open(v);
    
    % Dummy point to fix scale
    pos = [100 100 100;pos];
    btf = [2;btf];

    fig = figure(10);
    for k = 1:size(pos,1)
        scatter(pos(k,1),pos(k,2),[],btf(k))
        axis([-0.3 0.2 -0.5 0.1])
        hold on
        colormap jet
        colorbar
        caxis([0 2])
        frame = getframe(fig);
        writeVideo(v,frame);
    end
    close(v)
end
% 
% if flag_animate_scatter2
%     v = VideoWriter('wam_btf_scatter2.avi');

%% Animate BioTac force
if flag_animate_line
    v = VideoWriter('wam_btf_line_ann.avi');
    v.FrameRate = 100;
    v.Quality = 100;
    open(v);

    fig = figure(20);
    start_ind = 1;
    finish_ind = 17401;
    end_time = (finish_ind - start_ind)/100;
    plot([0 end_time],[2 2], 'r--','LineWidth', 1.5)
    axis([0,end_time,-2,6])
    xticks([0:20:170])
    yticks(-2:6)

    xlabel('Time (s)')
    ylabel('Force (N)')
    fp = animatedline('Color','b','LineWidth',1.5);
    lgd = legend('Force threshold', 'BioTac force prediction', 'Location', 'northwest');
    set(gca,'fontsize',14)
    lgd.FontSize = 10;
    
    t = 0:1/100:(finish_ind-start_ind)/100;
    fp_y = btf(start_ind:finish_ind);

    for k = 1:length(t)
        addpoints(fp,t(k),fp_y(k));
        htext = text(120,5,num2str(k),'Fontsize', 14)
        drawnow
        frame = getframe(fig);
        writeVideo(v,frame);
        delete(htext)
    end

    close(v)
end



