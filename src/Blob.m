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

        function setRadius(this, newRadius)
            this.location.r = newRadius;
            this.location.w = newRadius*2;
            this.rect.Position(3:4) = [newRadius, newRadius];
        end

        %Moves this in the vector direction of {@code dir} if this is
        %inside of the map
        function move(this, dir)
            mapDim = GameMap.size;
            loc = this.rect.Position(1:2) + dir;
            insideXBounds = loc(1) < mapDim(1) && loc(1) > -mapDim(1);
            insideYBounds = loc(2) < mapDim(2) && loc(2) > -mapDim(2);
            if(insideXBounds && insideYBounds)
                this.rect.Position(1:2) = loc;
            elseif(insideXBounds)
                this.rect.Position(1) = this.rect.Position(1) + dir(1);
            elseif(insideYBounds)
                this.rect.Position(2) = this.rect.Position(2) + dir(2);
            end
            this.location.pos = loc;

        end


        %Grows the area of this by the area of r
        function grow(this, r)
            totalArea = pi * this.location.r * this.location.r + pi * r * r;
            newRadius = sqrt(totalArea / pi);

            this.location.r = newRadius;
            this.location.w = newRadius;
            this.rect.Position(3:4) = [newRadius, newRadius];
            
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
                distance = sqrt(sum([(loc(1)-oloc(1))^2, (loc(2)-oloc(2))^2])); %faster than norm(oloc - loc)
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