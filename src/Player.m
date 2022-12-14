classdef Player < handle
    %PLAYER The player holds a collection of blobs that they control.

    properties
        mouseDir = [0 0];
        blobs = cell(1);
    end
    properties(Access=private)
        center = [0, 0];
        lastSplit;
    end

    methods(Static, Access=private)
        function playPopSound()
            [y, fS] = audioread("./sounds/splitPop");
            audioPlayer = audioplayer(y, fS);
            play(audioPlayer);
        end
    end

    methods
        function this = Player(x,y)
            %PLAYER Construct an instance of this class
            %   When a new player is made, they immediantly start out as a
            %   single blob
            this.blobs{1} = Blob(x, y, 5, this);
            this.lastSplit = java.lang.System.currentTimeMillis();

        end

        function mass = getTotalMass(this)
            tMass = 0;
            for i = 1:length(this.blobs)
                blob = this.blobs{i};
                tMass = tMass + blob.location.r*blob.location.r*pi;
            end
            mass = tMass;
        end

        function split(this)

            if(java.lang.System.currentTimeMillis() - this.lastSplit > 500)

                dir = this.mouseDir;
                for i = 1:length(this.blobs)
                    blob = this.blobs{i};
                    if(blob.location.r > 1)
                        pos = blob.location.pos;
                        blobRad = blob.location.r;
                        blobAreaHalf = pi * (blobRad * blobRad) / 2;
                        blobRadHalf = sqrt(blobAreaHalf / pi);

                        newBlob = Blob(pos(1), pos(2), blobRadHalf * 2);% times 2 b/c it's the width of the blob
                        newBlob.rect.FaceColor = blob.rect.FaceColor;
                        this.blobs{end+1} = newBlob;
                        blob.setRadius(blobRadHalf);

                        newBlob.addVelocity(dir*2);%Set velocity to fly away
                    end
                end
                this.playPopSound()
                this.lastSplit = java.lang.System.currentTimeMillis();
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
            cen = this.center;
            if(~isnan(cen(1)))
                cellfun(@(c) c.move(dir, cen), this.blobs, 'UniformOutput',false);
            end
        end

        %Gets the center coordinates of all blobs the player controls
        function centerLoc = getCenter(this)


            xSum = sum(cell2mat(cellfun(@(c) c.location.getCenter(1), ...
                this.blobs,'UniformOutput',false)));
            ySum = sum(cell2mat(cellfun(@(c) c.location.getCenter(2), this.blobs, ...
                'UniformOutput',false)));
            len = length(this.blobs);

            this.center = [xSum/len, ySum/len];
            centerLoc = this.center;

        end

        function setMouseDir(this, vector)
            this.mouseDir = vector;
        end

    end
end

