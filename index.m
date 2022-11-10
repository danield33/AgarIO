figure
close all


grid on
axis equal

global player;
player = Player(1, 1);

set (gcf, 'WindowButtonMotionFcn', @mouseMove);

while 1

    dir = player.mouseDir;
        
    player.move(dir);

    
    centerPoint = player.location.getCenter();
    xlim([centerPoint(1)-3, centerPoint(1)+3]);
    ylim([centerPoint(2)-3,centerPoint(2)+3]);

    drawnow %draw so that the loop doesn't prevent it from showing
end


%With this event we want to set the players direction whenever the mouse
%moves. This way the game loop can access the direction to move to

function mouseMove (object, eventdata)
    global player;
    C = get (gca, 'CurrentPoint');
   
    X = (C(1,1));
    Y = (C(1,2));

    start = player.location.getCenter();
    dir = [X Y] - start;
    dir = dir / norm(dir) / 15;
    
    player.setMouseDir(dir);

end






