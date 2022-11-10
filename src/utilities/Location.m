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
            

        function center = getCenter(this)
            center = [(this.pos(1) + this.w + this.pos(1))/2, (this.pos(2) + this.w + this.pos(2))/2];
        end


    end


end
