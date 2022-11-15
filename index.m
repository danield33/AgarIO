figure
close all
clc
clear
grid on
axis equal
% set(gcf, 'Position', get(0, 'Screensize')); %full screen
set(gcf,'position',[100,100,1000,1000])


game = GameMap(150);
game.populateFood();
mapDim = GameMap.size;

global player; %declare global so that the mouseMove event function has access to it
player = Player(1, 1);


set (gcf, 'WindowButtonMotionFcn', @mouseMove);
set (gcf, 'KeyPressFcn', @keyPressed);

windowSize = 20;
player.getCenter();
while 1

    dir = player.mouseDir/5; %Dir with speed so we slow it down by .2 just b/c
        
    player.move(dir);

    
    centerPoint = player.getCenter(); %TODO: get farthest blob from center of player view and add that to window size
    xlim([centerPoint(1)-windowSize , centerPoint(1)+windowSize ]);
    ylim([centerPoint(2)-windowSize , centerPoint(2)+windowSize ]);

    for i = length(game.food):-1:1
        blob = game.food{i};
        [canEat, indx] = player.eats(blob);
        if (~isempty(blob) && canEat(1))

            player.growBlob(blob.location.r, indx);
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
    C = get(gca, 'CurrentPoint');
   
    X = (C(1,1));
    Y = (C(1,2));

    start = player.getCenter();
    dir = [X, Y] - start;%Figure out directional vector
    dir = dir / norm(dir);
    
    player.setMouseDir(dir);

end

function keyPressed(~, eventData)
    global player;
    char = eventData.Key;
    if(strcmp(char, 'space'))
        player.split();
    end
end






