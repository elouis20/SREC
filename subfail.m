function x = subfail(A,B,C,nbins)
%This function plotted two BTS on the same histogram. This was done to make
%demonstration images that show how individual failure modes have a sub-BTS
%within the total BTS. This function is not called in the main body of the
%SREC models (Goldstein-Price and Gradeability), but was used to make
%figures


    Amax = max(A);
    Amin = min(A);
    edges = linspace(Amin,Amax,nbins);
    Adata = histogram(A,edges,'EdgeColor','none','FaceAlpha',1,'FaceColor',[0 0.6902 0.9412]);
    hold on
    Bdata = histogram(B,edges,'EdgeColor','none','FaceAlpha',1,'FaceColor',[1 0.5 0.5]);
    hold on
    Cdata = histogram(C,edges,'EdgeColor','none','FaceAlpha',1,'FaceColor',[1 0.2 0.2]);
    fontname('Times New Roman')
end