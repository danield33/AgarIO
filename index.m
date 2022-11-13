figure
close all
clc
clear


grid on
axis equal
% set(gcf, 'Position', get(0, 'Screensize'));
set(gcf,'position',[100,100,1000,1000])


numFood = 150;
blobs = cell(1, numFood);
mapDim = [100, 100]; %width, height

%%Setup Food Blobs

for i = 1:numFood
    randX = randi([-mapDim(1), mapDim(1)]);
    randY = randi([-mapDim(2), mapDim(2)]);
    blobs{end+1} = Blob(randX, randY, 1);
end
clear i;

global player; %declare global so that the mouseMove function has access to it
player = Player(1, 1);


set (gcf, 'WindowButtonMotionFcn', @mouseMove);

windowSize = 10;
while 1

    dir = player.mouseDir/5;
        
    player.move(dir);

    
    centerPoint = player.location.getCenter(); %TODO: lerp the zoom scaling
    xlim([centerPoint(1)-windowSize - player.location.r, centerPoint(1)+windowSize + player.location.r]);
    ylim([centerPoint(2)-windowSize - player.location.r, centerPoint(2)+windowSize + player.location.r]);

    for i = length(blobs):-1:1
        blob = blobs{i};
        if (~isempty(blob) && player.eats(blob))

            player.grow(blob.location.r);
            blob.kill();
            %replace food at random location
            blobs{i} = Blob(randi([-mapDim(1), mapDim(1)]), randi([-mapDim(2), mapDim(2)]), 1);

        end
    end

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
    dir = dir / norm(dir);
    
    player.setMouseDir(dir);

end






