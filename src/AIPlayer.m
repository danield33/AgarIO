classdef AIPlayer < Player
    %AICONTROLLER Summary of this class goes here
    %   Detailed explanation goes here

    properties
        state = AIStates.FOOD;
        target;
    end

    methods
        function this = AIPlayer()
            %AICONTROLLER Construct an instance of this class
            randLoc = [randi([-GameMap.size(1), GameMap.size(1)]), randi([-GameMap.size(2)/5, GameMap.size(2)/5])];
            this@Player(randLoc(1), randLoc(2));

        end

        function move(this, game)

            switch this.state
                case AIStates.FOOD
                    move@Player(this, this.goToFood(game))
                case AIStates.CHASING
                    vec = getNormVec(this.target.getCenter(), this.getCenter());
                    move@Player(this, vec/3)
            end

        end

        function determineState(this, game)
            players = game.getPlayers();

            for i = 1:length(players)
                player = players{i};
                if(player ~= this && ~isempty(player.blobs))%check for same reference

                    playerCen = player.getCenter();
                    thisCen = this.getCenter();
                    canEat = this.blobs{1}.canEat(player.blobs{1});
                    if(canEat)
                        dist = e_distance(playerCen, thisCen);
                        if(dist < 20)
                            this.state = AIStates.CHASING;
                            this.target = player;
                            return;
                        end
                    end
                end
            end
            this.state = AIStates.FOOD;
            this.target = {};
        end
    end

    methods(Access=private)

        function vec = goToFood(this, game)
            [dist, food] = this.getClosestFood(game);
            cen = food.location.getCenter();
            pointVec = cen - this.getCenter();
            normVec = pointVec / norm(pointVec);
            vec = normVec/3;

            if(dist < 0.2)
                [canEat, indx] = this.eats(food);
                if(canEat)
                    this.growBlob(food.location.r, indx);
                    game.replaceFood(food);
                end
            end

        end

        function [dist, food] =  getClosestFood(this, game)
            foods = game.food;
            dist = game.size(1)*2;%size of board
            food = foods{1};

            for i = 1:length(foods)
                currFood = foods{i};
                center = currFood.location.getCenter();
                thisCenter = this.getCenter();
                distance = e_distance(thisCenter, center);
                if(distance < dist)
                    dist = distance;
                    food = currFood;
                end
            end
        end

    end

end

