function prob = failcases(A,B,err)
    Asize = length(A);
    Bsize = length(B);
    Abounds = failprob(A,err);
    Bbounds = failprob(B,err);
    bounds = [Abounds Bbounds];
    bounds = sort(bounds);
    for i = 1:length(bounds)
        if i == length(bounds)
            Asub1 = A(find(A < bounds(1)));
            Asub2 = A(find(A > bounds(length(bounds))));
            Asub = [Asub1 Asub2];
            Aprob(i) = length(Asub)/Asize;
            Bsub1 = B(find(B < bounds(1)));
            Bsub2 = B(find(B > bounds(length(bounds))));
            Bsub = [Bsub1 Bsub2];
            Bprob(i) = length(Bsub)/Asize;
        else
            Asub = A(find(A > bounds(i)));
            Asub = Asub(find(Asub < bounds(i + 1)));
            Aprob(i) = length(Asub)/Asize;
            Bsub = B(find(B > bounds(i)));
            Bsub = Bsub(find(Bsub < bounds(i + 1)));
            Bprob(i) = length(Bsub)/Asize;
        end
    end

    regions = [0 0 0 0];
    if Bbounds(1) >= Abounds(1) && Bbounds(2) >= Abounds(2)
        regions(1) = 1;
        regions(2) = 2;
        regions(3) = 3;
        regions(4) = 4;
    elseif Abounds(1) >= Bbounds(1) && Abounds(2) >= Bbounds(2)
        regions(1) = 3;
        regions(2) = 2;
        regions(3) = 1;
        regions(4) = 4;
    elseif Bbounds(1) >= Abounds(1) && Abounds(2) >= Bbounds(2)
        regions(1) = 1;
        regions(2) = 2;
        regions(3) = 1;
        regions(4) = 4;
    else
        regions(1) = 3;
        regions(2) = 2;
        regions(3) = 3;
        regions(4) = 4;
    end

    prob = [regions; Aprob; Bprob; Bprob./Aprob];
    % On the rare chance that two bounds have the same value, then there
    % will be a NaN on the 3rd row of the prob matrix. This bit checks if
    % there is a NaN at all (any NaN thrown into a non-NaN matrix will make
    % the whole matrix sum to NaN), and if there is, goes through and
    % replaces with zero. This is probably a boneheaded way of finding and 
    % replacing NaNs, but it only executes if it fails the first check
    if isnan(sum(sum(prob)))
        for j = 1:size(prob,1)
            for k = 1:size(prob,2)
                if isnan(prob(j,k))
                    prob(j,k) = 0;
                end
            end
        end
    end
end