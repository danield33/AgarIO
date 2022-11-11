classdef Blob < handle


    properties
        location
        
        rect
    end

    methods

        function this = Blob(x, y, mass)
            this.location = Location(x, y, mass);
            this.rect = rectangle('Position', [x, y, this.location.r, this.location.r,]...
                ,'Curvature',[1, 1], 'FaceColor', [rand(1) rand(1) rand(1)]);

        end

        function move(this, dir)
            this.rect.Position(1:2) = this.rect.Position(1:2) + dir;
            this.location.pos = this.location.pos + dir;
            
        end


        function grow(this, r)
%             this.mass = this.mass + mass; A = pi*r^2 => sqrt(A/pi) = r
            sum = pi * this.location.r * this.location.r + pi * r * r;
            newRadius = sqrt(sum / pi);
%             this.location.r
%             pi * this.location.r * this.location.r 
            this.location.r = newRadius;
            this.location.w = newRadius;
            this.rect.Position(3:4) = [newRadius, newRadius];
%             this.mass = this.mass + mass;
        end

        %Check if this blob eats the other blob. The other blob will not be removed
        %iff this.mass > other.mass*1.2 and this.location overlaps
        %other.location
        %@returns if it can eat it or not
        function canEat = eats(this, other)

            canEat = false;
            
            if(this.location.r > other.location.r * 1.2)
                loc = this.location.getCenter();
                oloc = other.location.getCenter();
                distance = sqrt((loc(1)-oloc(1))^2 + (loc(2)-oloc(2))^2);
                %Check if the circles overlap at least half of each other
                %to consume it
                if(distance < this.location.r/2)
                    canEat = true;
                end
            end

        end

        function kill(this)
            delete(this.rect);

        end
        

    end


end