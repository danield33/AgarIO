classdef GameMap < handle
    %GAMEMAP Summary of this class goes here
    %   Detailed explanation goes here

    properties(Constant)
        size = [100, 100]; %from origin to negative and positive values of this
        numFood = 150;
        numAI = 1;
    end
    properties
        food;%cell array
        ai;
    end

    methods
        function this = GameMap()
            %GAMEMAP Construct an instance of this class
            %   Detailed explanation goes here
            this.food = cell(1, this.numFood);
            this.ai = cell(1, this.numAI);
        end

        function populateFood(this)
            for i = 1:length(this.food)
                randX = randi([-this.size(1), this.size(1)]);
                randY = randi([-this.size(2), this.size(2)]);
                this.food{i} = Blob(randX, randY, 1);
            end
        end

        function populateAI(this)
            for i = 1:length(this.ai)
                this.ai{i} = AIPlayer();
            end
        end

        function replaceFood(this, f)
            newPos = [randi([-this.size(1), this.size(1)]),...
                randi([-this.size(2), this.size(2)])];
            f.location.pos = newPos;
            f.rect.Position(1:2) = newPos;

        end


    end
end

