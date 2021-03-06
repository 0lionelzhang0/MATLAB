syms t1 t2 t3 t4 t5 t6 t7 h1 d2 

DH = [-90 0 0 0 0 0;...
      90 0 0 0 0 0;...
      -90 0.045 0.55 0 0 0;...
      90 -0.045 0 0 0 0;...
      -90 0 0.3 0 0 0;...
      90 0 0 0 0 0;...
      0 0 0.06 0 0 0];
 
Robot1 = DH2Robot(DH,0)
T1_2 = Robot1.A([2],[t1 t2 t3 t4 t5 t6 t7])

standby = [-0.0487222, -1.3306, 1.62575, 2.04923, -0.0101211, -0.378435, 0.0185968];

figure(1)
subplot(2,1,1)
Robot1.plot([0 0 0 0 0 0 0])
subplot(2,1,2)
Robot1.plot([standby])


