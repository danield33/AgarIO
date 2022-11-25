function normVec = getNormVec(coord1,coord2)
%GETNORMVEC Gets the vector between two points coord1 - coord2
    vec = coord1 - coord2;
    normVec = vec / norm(vec);
end

