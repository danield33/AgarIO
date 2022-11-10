figure
close all


grid on
axis equal

global a;
a = Player(1, 1);

set (gcf, 'WindowButtonMotionFcn', @mouseMove);

while 1

    dir = a.mouseDir;
        
    a.move(dir);

    
    centerPoint = a.location.getCenter();
    xlim([centerPoint(1)-3, centerPoint(1)+3]);
    ylim([centerPoint(2)-3,centerPoint(2)+3]);

    drawnow
end


%With this event we want to set the players direction whenever the mouse
%moves. This way the game loop can access the direction to move to

function mouseMove (object, eventdata)
    global a;
    C = get (gca, 'CurrentPoint');
   
    X = (C(1,1));
    Y = (C(1,2));

    start = a.location.getCenter();
    dir = [X Y] - start;
    dir = dir / norm(dir) / 15;
    
    a.setMouseDir(dir);

end






