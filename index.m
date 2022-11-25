figure
close all
clc
clear
grid on
axis equal
% set(gcf, 'Position', get(0, 'Screensize')); %full screen
set(gcf,'position',[0,1000,1000,1000])

global game;
game = GameMap();
game.populateFood();
game.populateAI();
mapDim = GameMap.size;

set (gcf, 'WindowButtonMotionFcn', @mouseMove);
set (gcf, 'KeyPressFcn', @keyPressed);

windowSize = 20;
player = game.player;
player.getCenter();

while 1

    dir = player.mouseDir/3; %Dir with speed so we slow it down by 3 just b/c
    
    centerPoint = player.getCenter(); %TODO: get farthest blob from center of player view and add that to window size

    xlim([centerPoint(1)-windowSize , centerPoint(1)+windowSize ]);
    ylim([centerPoint(2)-windowSize , centerPoint(2)+windowSize ]);
    player.move(dir);
    for i = 1:length(game.ai)
        ai = game.ai{i};
        ai.determineState(game);
        ai.move(game);
    end


    for i = length(game.food):-1:1
        blob = game.food{i};
        [canEat, indx] = player.eats(blob);
        if (~isempty(blob) && canEat)

            player.growBlob(blob.location.r, indx);
            %replace food at random location
            game.replaceFood(blob);

        end
    end

    drawnow %draw so that the loop doesn't prevent it from showing
end


%With this event we want to set the players direction whenever the mouse
%moves. This way the game loop can access the direction to move to

function mouseMove (~, ~)
    global game;
    player = game.player;
    C = get(gca, 'CurrentPoint');
   
    X = (C(1,1));
    Y = (C(1,2));

    start = player.getCenter();
    dir = [X, Y] - start;%Figure out directional vector
    dir = dir / norm(dir);
    
    player.setMouseDir(dir);

end

function keyPressed(~, eventData)
    global game;
    player = game.player;
    char = eventData.Key;
    if(strcmp(char, 'space'))
        player.split();
    end
end






