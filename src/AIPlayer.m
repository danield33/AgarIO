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

        function move(this)

            [dist, food] = this.getClosestFood();
            cen = food.location.getCenter();
            pointVec = cen - this.getCenter();
            normVec = pointVec / norm(pointVec);
            move@Player(this, normVec/3);


        end
    end

    methods(Access=private)

        function [dist, food] =  getClosestFood(this)
            global game;
            foods = game.food;
            dist = game.size(1)*2;
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

