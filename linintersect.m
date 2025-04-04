function xint = linintersect(x1,y1,x2,y2,x3,y3,x4,y4)
    A = det([x2 y2;x4 y4]);
    B = det([x1 y1;x3 y3]);
    C = det([x2 1; x4 1]);
    D = det([x1 1; x3 1]);
    E = det([y2 1; y4 1]);
    F = det([y1 1; y3 1]);

    xint = det([A C; B D])/det([C E; D F]);
end