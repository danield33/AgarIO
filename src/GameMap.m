classdef GameMap < handle
    %GAMEMAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Constant)
        size = [100, 100] %from origin to negative and positive values of this
    end
    
    methods
        function obj = GameMap(inputArg1,inputArg2)
            %GAMEMAP Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

