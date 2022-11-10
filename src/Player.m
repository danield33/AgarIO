classdef Player < Blob
    %PLAYER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mouseDir = [0 0]
    end
    
    methods
        function obj = Player(x,y)
            %PLAYER Construct an instance of this class
            %   Detailed explanation goes here
            obj = obj@Blob(x, y, 10);

        end

        function setMouseDir(obj, vector)
            obj.mouseDir = vector;
        end
       
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

