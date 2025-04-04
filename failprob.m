function bounds = failprob(set,prob)
if prob <= 0 || prob > 1
    error('prob must be between 0 and 1')
end

failset = sort(set); %need to sort randomly sampled data
n = size(failset,2); %length of failing set
ub = failset(round(0.5*n + 0.5*prob*n)); %upper bound
lb = failset(round(0.5*n - 0.5*prob*n)); %lower bound
bounds = [lb, ub];

end