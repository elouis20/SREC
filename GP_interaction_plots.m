clear
clc
close all
%%
x1 = linspace(-2,2,10);
x2 = linspace(-2,2,10);


for i = 1:length(x1)
    for j = 1:length(x2)
        GPfn(i,j) = goldpr([x2(j),x1(i)]);
        %evaluate GP function over input space
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2-setting interaction plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot([-2 2],[goldpr([-2 -2]), goldpr([2 -2])],':b','LineWidth',2)
hold on
scatter([-2 2],[goldpr([-2 -2]), goldpr([2 -2])],'filled','ob')
hold on
plot([-2 2],[goldpr([-2 2]), goldpr([2 2])],'-k','LineWidth',2)
hold on
scatter([-2 2],[goldpr([-2 2]), goldpr([2 2])],'filled','ok')
hold on
plot([-2.2 2.2],[100 100],'--r')
axis([-2.2, 2.2, -100000, 1.1*max(max(GPfn))])
xlabel('x_{1}')
ylabel('Output Response, y')
text(-1,200000,'x_{2} = -2')
text(-0.5,800000,'x_{2} = 2')
text(-0.25,-25000,'y_{threshold}')
title('Goldstein-Price Interaction Plot - 2 Settings')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3-setting interaction plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot([-2 0 2],[goldpr([-2 -2]), goldpr([0 -2]), goldpr([2 -2])],':b','LineWidth',2)
hold on
scatter([-2 0 2],[goldpr([-2 -2]), goldpr([0 -2]), goldpr([2 -2])],'filled','ob')
hold on
plot([-2 0 2],[goldpr([-2 0]), goldpr([0 0]), goldpr([2 0])],'--r','LineWidth',2)
hold on
scatter([-2 0 2],[goldpr([-2 0]), goldpr([0 0]), goldpr([2 0])],'filled','or')
hold on
plot([-2 0 2],[goldpr([-2 2]), goldpr([0 2]), goldpr([2 2])],'-k','LineWidth',2)
hold on
scatter([-2 0 2],[goldpr([-2 2]), goldpr([0 2]), goldpr([2 2])],'filled','ok')
hold on
plot([-2.2 2.2],[100 100],'--r')
axis([-2.2, 2.2, -100000, 1.1*max(max(GPfn))])
xlabel('x_{1}')
ylabel('Output Response, y')
text(-1,200000,'x_{2} = -2')
text(-0.5,800000,'x_{2} = 2')
text(-0.25,-25000,'y_{threshold}')
title('Goldstein-Price Interaction Plot - 3 Settings')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 10-setting interaction plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; plot(x1,GPfn(1,:),'-k')
hold on
plot(x1,GPfn(2,:),'-k')
hold on
plot(x1,GPfn(3,:),'-k')
hold on
plot(x1,GPfn(4,:),'-k')
hold on
plot(x1,GPfn(5,:),'-k')
hold on
plot(x1,GPfn(6,:),'-k')
hold on
plot(x1,GPfn(7,:),'-k')
hold on
plot(x1,GPfn(8,:),'-k')
hold on
plot(x1,GPfn(9,:),'-k')
hold on
plot(x1,GPfn(10,:),'-k')
hold on
scatter(x1,GPfn(1,:),20,'filled','ok')
hold on
scatter(x1,GPfn(2,:),20,'filled','ok')
hold on
scatter(x1,GPfn(3,:),20,'filled','ok')
hold on
scatter(x1,GPfn(4,:),20,'filled','ok')
hold on
scatter(x1,GPfn(5,:),20,'filled','ok')
hold on
scatter(x1,GPfn(6,:),20,'filled','ok')
hold on
scatter(x1,GPfn(7,:),20,'filled','ok')
hold on
scatter(x1,GPfn(8,:),20,'filled','ok')
hold on
scatter(x1,GPfn(9,:),20,'filled','ok')
hold on
scatter(x1,GPfn(10,:),20,'filled','ok')
%I made these plots very quickly please excuse the awful coding practices
xlabel('x_{1}')
ylabel('Output Response, y')
title('Goldstein-Price Interaction Plot - 10 Settings')
