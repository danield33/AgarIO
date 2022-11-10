classdef Blob < handle


    properties
        location
        mass
        rect
    end

    methods

        function this = Blob(x, y, mass)
            this.location = Location(x, y, 1);
            this.mass = mass;
            this.rect = rectangle('Position', [x, y, this.location.w, this.location.w,]...
                ,'Curvature',[1 1], 'FaceColor', 'r');

        end

        function move(this, dir)
            this.rect.Position(1:2) = this.rect.Position(1:2) + dir;
            this.location.pos = this.location.pos + dir;
            
        end
        

    end


end