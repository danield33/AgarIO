classdef Player < handle
    %PLAYER The player holds a collection of blobs that they control. 
    
    properties
        mouseDir = [0 0];
        blobs = cell(1);
    end
    
    methods
        function this = Player(x,y)
            %PLAYER Construct an instance of this class
            %   When a new player is made, they immediantly start out as a
            %   single blob
            this.blobs{1} = Blob(x, y, 5);

        end

        function split(this)

            dir = this.mouseDir;
            for i = 1:length(this.blobs)
                blob = this.blobs{i};
                pos = blob.location.pos;
                newRad =  blob.location.r/2;
                newBlob = Blob(pos(1), pos(2), newRad*2);% times 2 b/c it's the width of the blob
                newBlob.rect.FaceColor = blob.rect.FaceColor;
                this.blobs{end+1} = newBlob;
                blob.setRadius(newRad);

                newBlob.addVelocity(dir);%Set velocity to fly away
            end

        end

        %Grows a specific blob by {@code radius} 
        function growBlob(this, radius, blobIndex)
            blob = this.blobs{blobIndex};
            blob.grow(radius);
        end

        %Find first blob that eats something. This tells if you can eat
        %something in the first index and which blob eats something
        function [canEat, index] = eats(this, other)
            canEat = false;
            index = 0;
            for i = 1:length(this.blobs) 
                blob = this.blobs{i};
                if(blob.eats(other))
                    canEat = true;
                    index = i;
                    return;
                end
            end
        end

        function move(this, dir)
            cellfun(@(c) c.move(dir), this.blobs, 'UniformOutput',false);
        end

        %Gets the center coordinates of all blobs the player controls
        function center = getCenter(this)

            
            xSum = sum(cell2mat(cellfun(@(c) c.location.pos(1), ...
                this.blobs,'UniformOutput',false)));
            ySum = sum(cell2mat(cellfun(@(c) c.location.pos(2), this.blobs,'UniformOutput',false)));
            len = length(this.blobs);
            center = [xSum/len, ySum/len];

        end

        function setMouseDir(this, vector)
            this.mouseDir = vector;
        end
       

    end
end

