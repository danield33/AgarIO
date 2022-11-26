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

set (gcf, 'WindowButtonMotionFcn', @mouseMove);
set (gcf, 'KeyPressFcn', @keyPressed);

draw(game);

function draw(game)
player = game.player;
windowSize = 20;

while ~game.isOver

    dir = player.mouseDir/3; %Dir with speed so we slow it down by 3 just b/c

    centerPoint = player.getCenter(); %TODO: get farthest blob from center of player view and add that to window size

    if(~isnan(centerPoint(1)))
        xlim([centerPoint(1)-windowSize , centerPoint(1)+windowSize ]);
        ylim([centerPoint(2)-windowSize , centerPoint(2)+windowSize ]);
    end
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
            title("Mass: " + player.getTotalMass());
            %replace food at random location
            game.replaceFood(blob);

        end
    end


    players = game.getPlayers();

    for i = length(players):-1:1
        for j = length(players):-1:1
            p1 = players{i};
            p2 = players{j};
            if(p1 ~= p2)
                for k = 1:length(p2.blobs)
                    blob = p2.blobs{k};
                    [canEat, blobIndex] = p1.eats(blob);
                    if(canEat)
                        if(p2 == game.player)
                            title("Game Over. Press space to restart");
                            game.isOver = true;
                        end
                        p1.growBlob(blob.location.r, blobIndex);
                        p2.blobs(k) = [];
                        blob.kill();
                        break;
                    end
                end
            end
        end
    end

    drawnow %draw so that the loop doesn't prevent it from showing
end

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
        if(~game.isOver)
            player.split();
        else
            title("");
            game.restart();
            draw(game);
        end
    end
    if(strcmp(char, 'q'))
        close all;
    end
end






