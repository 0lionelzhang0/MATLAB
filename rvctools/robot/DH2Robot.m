function Robot = DH2Robot(DH,rad)

% 1: alpha
% 2: a
% 3: d
% 4: theta
% 5: 0 for rev, 1 for pris
% 6: offset
[m,n] = size(DH);

for i=1:m
    a = DH(i,2);
    d = DH(i,3);
    rot = DH(i,5);
    off = 0;
    al = 0;
    th = 0;
    
    if(rad == 0)
        al = DH(i,1)*pi/180;
        th = DH(i,4)*pi/180;
        if(rot == 0)
           off = DH(i,6)*pi/180;
        else
           off = DH(i,6);
        end
    else
        al = DH(i,1);
        th = DH(i,4);
        off = DH(i,6);
    end
    
    if(off == 0)
    L(i) = Link([th,d,a,al,rot]);
    else
    L(i) = Link([th,d,a,al,rot,off]);
    end
end

Robot = SerialLink(L);
end