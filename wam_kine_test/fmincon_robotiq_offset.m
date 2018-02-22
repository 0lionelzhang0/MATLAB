x0 = [1.5 -2.46 5.658+4.814];
w = [2 2 2];
lb = [x0(1)-w(1); x0(2)-w(2); x0(3)-w(3)];
ub = [x0(1)+w(1); x0(2)+w(2); x0(3)+w(3)];
options = optimoptions('fmincon', 'Display','iter');
% [x,fval] = fmincon(@calc_error,x0,[],[],[],[],lb,ub, [],options);
[x,fval] = fmincon(@calc_offset,x0,[],[],[],[],lb,ub, [],options);