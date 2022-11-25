classdef Location < handle

    properties
        pos
        w; %Width of rectangle (height will match)
        r;
    end

    methods

        function this = Location(x, y, w)
            this.pos = [x, y];
            this.w = w;
            this.r = w/2;
        end


        function center = getCenter(this, index)

            switch nargin
                case 2%So you can call getCenter(1) and only get the x or y coordinate
                    if(index == 1)
                        center = (this.pos(1) + this.r + this.pos(1))/2;
                    elseif(index == 2)
                        center = (this.pos(2) + this.r + this.pos(2))/2;
                    end
                otherwise
                    x = (this.pos(1) + this.r + this.pos(1))/2;
                    y = (this.pos(2) + this.r + this.pos(2))/2;
                    center = [x, y];
            end


        end


    end


end
