figure
close all
clc
clear


grid on
axis equal
% set(gcf, 'Position', get(0, 'Screensize'));
set(gcf,'position',[100,100,1000,1000])


game = GameMap(150);
game.populateFood();
mapDim = GameMap.size;

global player; %declare global so that the mouseMove function has access to it
player = Player(1, 1);


set (gcf, 'WindowButtonMotionFcn', @mouseMove);

windowSize = 20;
while 1

    dir = player.mouseDir/5;
        
    player.move(dir);

    
    centerPoint = player.location.getCenter(); %TODO: lerp the zoom scaling
    xlim([centerPoint(1)-windowSize - player.location.r, centerPoint(1)+windowSize + player.location.r]);
    ylim([centerPoint(2)-windowSize - player.location.r, centerPoint(2)+windowSize + player.location.r]);

    for i = length(game.food):-1:1
        blob = game.food{i};
        if (~isempty(blob) && player.eats(blob))

            player.grow(blob.location.r);
            blob.kill();
            %replace food at random location
            game.replaceFood(i);

        end
    end

    drawnow %draw so that the loop doesn't prevent it from showing
end


%With this event we want to set the players direction whenever the mouse
%moves. This way the game loop can access the direction to move to

function mouseMove (~, ~)
    global player;
    C = get (gca, 'CurrentPoint');
   
    X = (C(1,1));
    Y = (C(1,2));

    start = player.location.getCenter();
    dir = [X Y] - start;
    dir = dir / norm(dir);
    
    player.setMouseDir(dir);

end






