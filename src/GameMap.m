classdef GameMap < handle
    %GAMEMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        size = [100, 100]; %from origin to negative and positive values of this
        numFood = 150;
    end
    properties
        food;%cell array
    end
    
    methods
        function this = GameMap(foodCount)
            %GAMEMAP Construct an instance of this class
            %   Detailed explanation goes here
            this.food = cell(1, foodCount);
        end

        function populateFood(this)
            for i = 1:length(this.food)
                randX = randi([-this.size(1), this.size(1)]);
                randY = randi([-this.size(2), this.size(2)]);
                this.food{i} = Blob(randX, randY, 1);
            end
        end

        function replaceFood(this, index)
            this.food{index} = Blob(randi([-this.size(1), this.size(1)]), ...
                randi([-this.size(2), this.size(2)]), 1);
        end
        

    end
end

