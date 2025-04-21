function prob = failcases(A,B,err)
    Asize = length(A); %number of values in input set
    Bsize = length(B); %number of values in failing set
    Abounds = failprob(A,err);
    Bbounds = failprob(B,err);%two-tailed probability for A and B

    bounds = [Abounds Bbounds]; %4-element vector of the bounds of both sets
    bounds = sort(bounds); %ordered set of bounds
    for i = 1:length(bounds) %goes column by column
        if i == length(bounds) %all Region IV values get wrapped up in one calculation - these are "leftovers" from the other bounds calculations
            Asub1 = A(find(A < bounds(1))); %find every value of input set less than the lowermost bound
            Asub2 = A(find(A > bounds(length(bounds)))); %find every value of input set greater than the uppermost bound
            Asub = [Asub1 Asub2]; %put all these values together
            Aprob(i) = length(Asub)/Asize; %find proportion of these values relative to input set
            Bsub1 = B(find(B < bounds(1))); %do the same process as above for failing set
            Bsub2 = B(find(B > bounds(length(bounds))));
            Bsub = [Bsub1 Bsub2];
            Bprob(i) = length(Bsub)/Asize;
        else
            Asub = A(find(A > bounds(i))); %find every value above the ith bound
            Asub = Asub(find(Asub < bounds(i + 1))); %find every value above the ith bound AND below the (i + 1)th bound
            %if i = 2, then this finds every value between the 2nd and 3rd bound
            Aprob(i) = length(Asub)/Asize; %proportion of these values relative to input set
            Bsub = B(find(B > bounds(i))); %same process as above for failing set
            Bsub = Bsub(find(Bsub < bounds(i + 1)));
            Bprob(i) = length(Bsub)/Asize;
        end
    end
    %The above loop always yields 2 1x4 vectors, but sometimes all 4
    %regions are not present.

    regions = [];
    if Bbounds(1) >= Abounds(1) && Bbounds(2) >= Abounds(2)
        regions = [1 2 3 4]; %vector that acts as a header row for probability table    
    elseif Abounds(1) >= Bbounds(1) && Abounds(2) >= Bbounds(2)
        regions = [3 2 1 4];
    elseif Bbounds(1) >= Abounds(1) && Abounds(2) >= Bbounds(2)
        Aprob = [Aprob(1) + Aprob(3), Aprob(2), Aprob(4)];
        Bprob = [Bprob(1) + Bprob(3), Bprob(2), Bprob(4)];
        %the above operations cover when Region I is split into 2 subsets
        %and Region III is not present
        regions = [1 2 4]; %only 3 regions present, so the probability table only has 3 columns!
    elseif Bbounds(1) <= Bbounds(2) && Bbounds(2) <= Abounds(1)
        %covers if the bounds have no overlap. Rare case, sometimes comes
        %up in the gradeability test if you have a very low 'err' value
        %passed to subhist.m
        Aprob = [Aprob(1), Aprob(2) + Aprob(4), Aprob(3)];
        Bprob = [Bprob(1), Bprob(2) + Bprob(4), Bprob(3)];
        regions = [3 4 1];
    else
        Aprob = [Aprob(1) + Aprob(3), Aprob(2), Aprob(4)];
        Bprob = [Bprob(1) + Bprob(3), Bprob(2), Bprob(4)];
        %covers when Region III is split and Region I is not present
        regions = [3 2 4];
    end

    prob = [regions; Aprob; Bprob; Bprob./Aprob]; %probability table
    %this table has the region numbers in the first row, the proportion of
    %the input set belonging to each region in the second row, the proportion of the failing set
    %belonging to each region in the third row, and the relative proportion of failures in
    %each region in the fourth row



    % On the rare chance that two bounds have the same value, then there
    % will be a NaN on the 4th row of the prob matrix. This bit checks if
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