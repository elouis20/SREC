function xint = linintersect(x1,y1,x2,y2,x3,y3,x4,y4)
%This function finds the intersection of two diagonals of any convex
%quadrilateral. If you have a histogram with a highest bin, you can
%construct a quadrilateral of the height of that bin and the heights of the
%bins directly adjacent. The mode is estimated to be at the intersection of
%the two diagonals. A determinant-based method exists to find this
%intersection point.

%function takes the quadrilateral coordinates and outputs the x-coordinate
%of the intersection point. Only the x-coord is needed.

    A = det([x2 y2;x4 y4]);
    B = det([x1 y1;x3 y3]);
    C = det([x2 1; x4 1]);
    D = det([x1 1; x3 1]);
    E = det([y2 1; y4 1]);
    F = det([y1 1; y3 1]);

    xint = det([A C; B D])/det([C E; D F]);
end