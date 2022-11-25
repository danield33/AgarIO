classdef AIPlayer < Player
    %AICONTROLLER Summary of this class goes here
    %   Detailed explanation goes here

    properties
    end

    methods
        function this = AIPlayer()
            %AICONTROLLER Construct an instance of this class
            randLoc = [5 5];%[randi([-GameMap.size(1), GameMap.size(1)]), randi(-GameMap.size(2), GameMap.size(2))];
            %             this.player = Player(randLoc(1), randLoc(2));
            this@Player(randLoc(1), randLoc(2));

        end

        function move(this, game)

            [dist, food] = this.getClosestFood(game);
            cen = food.location.getCenter();
            pointVec = cen - this.getCenter();
            normVec = pointVec / norm(pointVec);
            move@Player(this, normVec/3);
            
            if(dist < 0.2)
                [canEat, indx] = this.eats(food);
                if(canEat)
                    this.growBlob(food.location.r, indx);
                    game.replaceFood(food);
                end
            end

        end
    end

    methods(Access=private)

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

