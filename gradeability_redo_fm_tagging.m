clear
clc
close all


%% Inputs
wdist = makedist('Normal','mu',60000,'sigma',5000); %weight [N]
% wdist = makedist('Uniform','lower',50000,'upper',70000);
d1dist = makedist('Normal','mu',1.8,'sigma',0.5); %cg to rear contact point [m]
% d1dist = makedist('Uniform','Lower',0.5,'Upper',1.9); %cg to rear contact point [m]
d2dist =  makedist('Normal','mu',1.5,'sigma',0.5); %cg to front contact point [m]
% d2dist = makedist('Uniform','Lower',1.3,'Upper',1.7);
h = 0.619; %cg height off ground [m] CHECK THIS VALUE!!!
k = 160000; %spring constant [N/m]
r = 0.47; % radius of tire [m] 
mu = 0.8; %input('coefficient of static friction: ') 
mtdist = makedist('Normal','mu',515,'sigma',150); %Maximum engine torque at crank [Nm]
% mtdist = makedist('Uniform','lower',215,'upper',715);
gearing = 39.9; %global gear reduction
g = 9.81;

threshold = 27; %acceptable gradeability performance threshold

%% Main

nMC = 10000; %number of monte carlo simulations

crit = 0; %critical grade placeholder
%tic
failindex = 0; %index for system failures (of any failure mode)
fm1index = 0; %index for tipover failures
fm2index = 0; %index for traction failures
fm3index = 0; %index for torque failures
for j = 1:nMC
    w = random(wdist);
    d1 = random(d1dist);
    d2 = random(d2dist);
    mt = random(mtdist);
    %select random values from respective distributions

    whistory(j) = w;
    d1history(j) = d1;
    d2history(j) = d2;
    mthistory(j) = mt;
    %keeping track of history of inputs

    T = mt*gearing; %torque at the wheel
    m = w/g; %vehicle mass
    phi = atand(h/d1); %angle between rear contact point, cg, and the grade

    qlow = 0;
    qmid = 45;
    qhigh = 90;
    int = [qlow,qmid,qhigh];
    % initial points for bisection method
    
    diff = qhigh - qlow;
    %initial difference value for convergence (can be arbitrarily high)
    
    counter = zeros(3,length(int));
    % counter for checking if each criteria is passed. All 3 failure modes must
    % be avoided to consider the grade passable. A passing grade has counter
    % equal to 3
    whilecounter = 0; %counts how many time while loop executes
    while diff >= 0.01 %sets precision of output
        % whilecounter = whilecounter + 1;

        int = [qlow,qmid,qhigh]; %repeated so it updates with every loop
        %Bisection Method interval
        counter = zeros(3,length(int)); %repeated so it resets every loop
        %Counter used for checking failure modes
    
        for i = 1:length(int)

            %% Calculation of Forces from FBD
        
            if int(i) + phi <= 90 %when theta + phi = 90, the cg is directly over the wheel, sum of moments changes sign here
                Nf = (-w*sind(int(i))*h) + (w*cosd(int(i))*d1)/(d1 + d2); %front wheel normal force
            else
                Nf = (-w*sind(int(i))*h) + (-w*cosd(int(i))*d1)/(d1 + d2); %front wheel normal force
            
            end
            
            Nr = w*cosd(int(i)) - Nf; %rear wheel normal force
            
            wx = w*sind(int(i)); %component of weight acting parallel to grade
            Ft = T/r; %tractive force
            Ffric = mu*Nr; %friction force
            
            %counter(i) = 0;

            %% Failure Mode Checks
            
            if Nf <= 0 %check for tipping
                counter(1,i) = counter(1,i); %if vehicle does not pass tip test, do not increase counter
            else
                counter(1,i) = counter(1,i) + 1; %if vehicle passes tip test, increase counter
            end
            
            if Ffric <= wx %check for sliding
                counter(2,i) = counter(2,i); %if vehicle does not pass sliding test, do not increase counter
            else
                counter(2,i) = counter(2,i) + 1; %if vehicle passes sliding test, increase counter
            end
            
            if Ft <= wx %check for sufficient torque
                counter(3,i) = counter(3,i); %if vehicle does not pass torque test, do not increase counter
            else
                counter(3,i) = counter(3,i) + 1; %if vehicle passes torque test, increase counter
            end
        
        end
        
        % Bisection method
    
        if sum(counter(:,2)) < 3 %if the critical grade is somewhere between the low and middle grade, update the interval accordingly
            qlow = qlow; %lower bound of interval stays the same
            qhigh = qmid; %middle of the interval becomes new upper bound
            qmid = qlow + 0.5*(qmid - qlow); %new middle of interval is midpoint of new upper and lower bound
            diff = qmid - qlow; %update difference
        elseif sum(counter(:,3)) < 3 %if the critical grade is somewhere between the middle and high grade, update the interval accordingly
            qlow = qmid; %new lower bound is the middle of interval
            qhigh = qhigh; %upper bound of interval stays the same
            qmid = qmid + 0.5*(qhigh - qmid); %middle of interval is midpoint of new lower and upper bound
            diff = qhigh - qmid; %update difference
        end
    end
    crit(j) = qmid; %critical grade reported as last midpoint value from bisection method

    % Sub-distribution of failures
    
    if crit(j) < threshold %checks if the grade reported is below acceptable threshold
        failindex = failindex + 1;
        wfail(failindex) = w; %inputs that result in a failure are put into a "failing set"
        d1fail(failindex) = d1;
        d2fail(failindex) = d2;
        mtfail(failindex) = mt;

        if sum(counter(1,:)) < 3
            fm1index = fm1index + 1;
            wfm1(fm1index) = w; %subsets constructed of failure mode 1 (tipover) violations
            d1fm1(fm1index) = d1;
            d2fm1(fm1index) = d2;
            mtfm1(fm1index) = mt;
        elseif sum(counter(2,:)) < 3
            fm2index = fm2index + 1;
            wfm2(fm2index) = w; %subsets constructed of failure mode 2 (traction) violations
            d1fm2(fm2index) = d1;
            d2fm2(fm2index) = d2;
            mtfm2(fm2index) = mt;
        elseif sum(counter(3,:)) < 3 %subsets constructed of failure mode 3 (torque) violations
            fm3index = fm3index + 1;
            wfm3(fm3index) = w;
            d1fm3(fm3index) = d1;
            d2fm3(fm3index) = d2;
            mtfm3(fm3index) = mt;
        end
    end

end

edges = 0:1:40;
figure;
histogram(crit,edges,'EdgeColor','none','FaceAlpha',1,'FaceColor',[0 0.6902 0.9412]);
xlabel('Critical Grade, degrees','FontSize',12)
hold on
critfail = crit(find(crit <= threshold));
histogram(critfail,edges,'EdgeColor','none','FaceAlpha',1,'FaceColor',[1 0.2 0.2]);
fontname('Times New Roman')

figure;
subplot(2,2,1)
subhist(whistory,wfail,0.95,30)
xlabel('Subset of all failures')
hold on
subplot(2,2,2)
subhist(whistory,wfm1,0.95,30)
xlabel('Subset of tipover failures')
hold on
subplot(2,2,3)
subhist(whistory,wfm2,0.95,30)
xlabel('Subset of traction failures')
hold on
subplot(2,2,4)
subhist(whistory,wfm3,0.95,30)
xlabel('Subset of torque failures')
sgtitle('Vehicle Weight','FontSize',12,'FontWeight','bold')
fontname('Times New Roman')
wprob = failcases(whistory,wfail,0.95);
wprob1 = failcases(whistory,wfm1,0.95);
wprob2 = failcases(whistory,wfm2,0.95);
wprob3 = failcases(whistory,wfm3,0.95);

figure;
subplot(2,2,1)
subhist(d1history,d1fail,0.95,30)
xlabel('Subset of all failures')
hold on
subplot(2,2,2)
subhist(d1history,d1fm1,0.95,30)
xlabel('Subset of tipover failures')
hold on
subplot(2,2,3)
subhist(d1history,d1fm2,0.95,30)
xlabel('Subset of traction failures')
hold on
subplot(2,2,4)
subhist(d1history,d1fm3,0.95,30)
xlabel('Subset of torque failures')
sgtitle('CG to R. Wheel Distance','FontSize',12,'FontWeight','bold')
fontname('Times New Roman')
d1prob = failcases(d1history,d1fail,0.95);
d1prob1 = failcases(d1history,d1fm1,0.95);
d1prob2 = failcases(d1history,d1fm2,0.95);
d1prob3 = failcases(d1history,d1fm3,0.95);

figure;
subplot(2,2,1)
subhist(d2history,d2fail,0.95,30)
xlabel('Subset of all failures')
hold on
subplot(2,2,2)
subhist(d2history,d2fm1,0.95,30)
xlabel('Subset of tipover failures')
hold on
subplot(2,2,3)
subhist(d2history,d2fm2,0.95,30)
xlabel('Subset of traction failures')
hold on
subplot(2,2,4)
subhist(d2history,d2fm3,0.95,30)
xlabel('Subset of torque failures')
sgtitle('CG to F. Wheel Distance','FontSize',12,'FontWeight','bold')
fontname('Times New Roman')
d2prob = failcases(d2history,d1fail,0.95);
d2prob1 = failcases(d2history,d2fm1,0.95);
d2prob2 = failcases(d2history,d2fm2,0.95);
d2prob3 = failcases(d2history,d2fm3,0.95);

figure;
subplot(2,2,1)
subhist(mthistory,mtfail,0.95,30)
xlabel('Subset of all failures')
hold on
subplot(2,2,2)
subhist(mthistory,mtfm1,0.95,30)
xlabel('Subset of tipover failures')
hold on
subplot(2,2,3)
subhist(mthistory,mtfm2,0.95,30)
xlabel('Subset of traction failures')
hold on
subplot(2,2,4)
subhist(mthistory,mtfm3,0.95,30)
xlabel('Subset of torque failures')
sgtitle('Peak Motor Torque','FontSize',12,'FontWeight','bold')
fontname('Times New Roman')
mtprob = failcases(mthistory,mtfail,0.95);
mtprob1 = failcases(mthistory,mtfm1,0.95);
mtprob2 = failcases(mthistory,mtfm2,0.95);
mtprob3 = failcases(mthistory,mtfm3,0.95);