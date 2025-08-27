function x = subhist(A,B,err,nbins)
%This function makes plots of an input set and its BTS with the probability
%intervals of both sets overlain

    Amax = max(A);
    Amin = min(A);
    edges = linspace(Amin,Amax,nbins);
    Adata = histogram(A,edges,'EdgeColor','none','FaceAlpha',1,'FaceColor',[0 0.6902 0.9412]);
    %histogram of input set
    Asize = size(A,2);
    hold on
    Bdata = histogram(B,edges,'EdgeColor','none','FaceAlpha',1,'FaceColor',[1 0.2 0.2]);
    %histogram of BTS
    Bsize = size(B,2);
    hold on

    Aindex = find(Adata.Values == max(Adata.Values));
    if Aindex == 1
        modeA = 0.5*(Adata.BinEdges(Aindex + 1) + Adata.BinEdges(Aindex));
    elseif Aindex == nbins - 1
        modeA = 0.5*(Adata.BinEdges(Aindex) + Adata.BinEdges(Aindex - 1));
    elseif size(Aindex,2) > 1
        modeA = Adata.BinEdges(Aindex(2));
    else
        x1a = Adata.BinEdges(Aindex);
        y1a = Adata.Values(Aindex - 1);
        x2a = Adata.BinEdges(Aindex);
        y2a = Adata.Values(Aindex);
        x3a = Adata.BinEdges(Aindex + 1);
        y3a = Adata.Values(Aindex);
        x4a = Adata.BinEdges(Aindex + 1);
        y4a = Adata.Values(Aindex+ 1);
        modeA = linintersect(x1a, y1a, x2a, y2a, x3a, y3a, x4a, y4a);
    end
    %There was a point in time where I was quantifying robustness by
    %comparing mode of input distribution and mode of BTS distribution. Did
    %not make it into the paper, but it is still working, and calls a
    %linear intersection code which is used to estimate the mode of a
    %histogram. Linearly interpolates within the highest bin to make an
    %estimation of mode.

    Bindex = find(Bdata.Values == max(Bdata.Values));
    if Bindex == 1
        modeB = 0.5*(Bdata.BinEdges(Bindex + 1) + Bdata.BinEdges(Bindex));
    elseif Bindex == nbins - 1
        modeB = 0.5*(Bdata.BinEdges(Bindex) + Bdata.BinEdges(Bindex - 1));
    elseif size(Bindex,2) > 1
        modeB = Bdata.BinEdges(Bindex(2));
    else
        x1b = Bdata.BinEdges(Bindex);
        y1b = Bdata.Values(Bindex - 1);
        x2b = Bdata.BinEdges(Bindex);
        y2b = Bdata.Values(Bindex);
        x3b = Bdata.BinEdges(Bindex + 1);
        y3b = Bdata.Values(Bindex);
        x4b = Bdata.BinEdges(Bindex + 1);
        y4b = Bdata.Values(Bindex+ 1);
        modeB = linintersect(x1b, y1b, x2b, y2b, x3b, y3b, x4b, y4b);
    end
    %same here

    maxBinSize = max(Adata.Values);
    boundheight = 1.1*maxBinSize;

    Bbounds = failprob(B,err);
    plot([Bbounds(1),Bbounds(1)],[0,boundheight],'Color',[0.7 0 0],'LineStyle','--','LineWidth',2)
    plot([Bbounds(2),Bbounds(2)],[0,boundheight],'Color',[0.7 0 0],'LineStyle','--','LineWidth',2)
    hold on
    Abounds = failprob(A,err);
    plot([Abounds(1),Abounds(1)],[0,boundheight],'Color',[0 0 0.7],'LineStyle','-','LineWidth',2)
    plot([Abounds(2),Abounds(2)],[0,boundheight],'Color',[0 0 0.7],'LineStyle','-','LineWidth',2)
    fontname('Times New Roman')
    %plotting intervals on top of the histograms constructed earlier
end