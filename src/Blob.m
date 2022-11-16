classdef Blob < handle


    properties
        location
        rect
        velocity = [0, 0]
    end
    properties(Access=private)
        player;
        id;
    end

    methods(Access=private)

        function processFriction(this)
            friction = 0.05;
            xDir = this.velocity(1);
            yDir = this.velocity(2);

            if(xDir > friction)
                xDir = xDir - friction;
            elseif(xDir < -friction)
                xDir = xDir + friction;
            else
                xDir = 0;
            end
            this.velocity(1) = xDir;

            if(yDir > friction)
                yDir = yDir - friction;
            elseif(yDir < -friction)
                yDir = yDir + friction;
            else
                yDir = 0;
            end
            this.velocity(2) = yDir;

        end

        function processCenterPull(this, centerLoc)

            v = centerLoc-this.location.pos;
            vNorm = v / norm(v) / 20;
            if(~isnan(vNorm))
                this.addVelocity(vNorm);%Add velocity in dir of center
                if(~isempty(this.player))
                    [isTouching, dist] = this.isTouchingAnother();
                    if(isTouching)
                        %                     ~isempty(this.player) && ~this.isTouchingAnother()
                        this.addVelocity(-vNorm*(2/dist));
                    end
                end
            end
        end

        function [touching, distance] = isTouchingAnother(this)
            touching = false;
            distance = NaN;
            len = length(this.player.blobs);
            if(len > 1)
                for i = 1:len
                    blob = this.player.blobs{i};
                    if(~strcmp(this.id, blob.id))
                        thisCenter = this.location.getCenter();
                        blobCenter = blob.location.getCenter();
                        %                         e_distance(thisCenter, blobCenter)
                        %                         ~isempty(blob)
                        dist = e_distance(thisCenter, blobCenter);
                        if(~isempty(blob) && dist <= this.location.r)
                            %                         e_distance(thisCenter, blobCenter)
                            %                         this.location.r
                            touching = true;
                            distance = dist;

                            %                             vec = thisCenter - blobCenter;
                            %                             if(sum(vec > 0) > 0)
                            %                                 normVec = vec ./ norm(vec);
                            %                                 blob.addVelocity(-this.velocity*2);
                            %                             end

                        end
                    end
                end
            end

        end

    end

    methods

        function this = Blob(varargin)
            x = varargin{1};
            y = varargin{2};
            mass = varargin{3};
            this.location = Location(x, y, mass);
            this.id = char(matlab.lang.internal.uuid());
            this.rect = rectangle('Position', [x, y, this.location.r, this.location.r,]...
                ,'Curvature',[1, 1], 'FaceColor', [rand(1) rand(1) rand(1)]);
            if(length(varargin) >= 4)
                this.player = varargin{4};
            end

        end

        function addVelocity(this, newVel)
            this.velocity = this.velocity + newVel;
        end

        function setRadius(this, newRadius)
            this.location.r = newRadius;
            this.location.w = newRadius*2;
            this.rect.Position(3:4) = [newRadius, newRadius];
        end

        %Moves this in the vector direction of {@code dir} if this is
        %inside of the map
        function move(this, dir, center)
            mapDim = GameMap.size;

            %             if(~isempty(this.player))
            %                 this.repelOthers();
            %             end
            %             if(~isempty(this.player) && ~this.isTouchingAnother())
            %                 this.processCenterPull(center);
            %             end
            this.processFriction();

            this.processCenterPull(center);

            loc = this.rect.Position(1:2) + dir + this.velocity;
            insideXBounds = loc(1) < mapDim(1) && loc(1) > -mapDim(1);
            insideYBounds = loc(2) < mapDim(2) && loc(2) > -mapDim(2);
            if(insideXBounds && insideYBounds)
                this.rect.Position(1:2) = loc;
            elseif(insideXBounds)
                this.rect.Position(1) = this.rect.Position(1) + dir(1) + this.velocity(1);
            elseif(insideYBounds)
                this.rect.Position(2) = this.rect.Position(2) + dir(2) + this.velocity(2);
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
                distance = e_distance(loc, oloc); %faster than norm(oloc - loc)
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