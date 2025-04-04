clear
clc
close all
%%
x1 = linspace(-2,2);
x2 = linspace(-2,2);


for i = 1:length(x1)
    for j = 1:length(x2)
        GPfn(i,j) = goldpr([x2(j),x1(i)]);
    end
end

C = log(GPfn);
threshold = 100;
threshsurf = threshold*ones(length(x1),length(x2));
figure;
surf(x1,x2,GPfn,C)
xlabel('x1')
ylabel('x2')
hold on
surf(x1,x2,threshsurf,0.0001*C)
hold on

x1sample = makedist('Normal','mu',0,'sigma',0.667);
x2sample = makedist('Normal','mu',0,'sigma',0.667);

n = 10000;
PS = zeros(2,1);
index = 1;
for i = 1:n
    x1mc = random(x1sample);
    x1dist(i) = x1mc;
    x2mc = random(x2sample);
    x2dist(i) = x2mc;
    GPMC(i) = goldpr([x1mc,x2mc]);
    % display(GPMC(i))
    if GPMC(i) <= threshold
        PS(1,index) = x1mc;
        PS(2,index) = x2mc;
        index = index+1;
    end
end

edges = [0,1,5,10,25,50,100,250,500,1000,2500,5000,10000,25000,50000,100000,250000,500000,1000000];
figure;
histogram(GPMC,edges)
set(gca,'xscale','log');
xlabel('Function Height')

figure;
subhist(x1dist,PS(1,:),0.95,40)
x1prob = failcases(x1dist,PS(1,:),0.95);
figure;
subhist(x2dist,PS(2,:),0.95,40)
x2prob = failcases(x2dist,PS(2,:),0.95);