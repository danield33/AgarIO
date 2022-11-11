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
            obj = obj@Blob(x, y, 5);

        end

        function setMouseDir(obj, vector)
            obj.mouseDir = vector;
        end
       

    end
end

