v = VideoWriter('test.avi');
v.FrameRate = 10;
v.Quality = 100;
open(v);

fig = figure(2)
x = linspace(1,10,100);
y = x;
c = x;
c(1) = 10;
fp = animatedline('Color','r','LineWidth',1.5);
bt = animatedline('Color','b','LineWidth',1.5);

for k = 1:size(x,2)
    scatter(x(k),y(k),[],c(k))
    axis([0 10 0 10])
    hold on
    colormap jet
    colorbar
    frame = getframe(fig);
    writeVideo(v,frame);
end
close(v)