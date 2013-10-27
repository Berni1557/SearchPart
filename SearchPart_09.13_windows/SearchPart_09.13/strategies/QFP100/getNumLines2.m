function [NumLines,c]=getNumLines2(data,maxNumLines,W,b2)

    prall=zeros(1,size(W,1));
    x=(data(:,3)+data(:,4))/2;
    for p=1:size(data,1)
        pr = normpdf(1:1:size(W,1),x(p),10);
        prall=prall+pr;
    end

    prall=prall/size(data,1);
    MPD=round(b2/2);
    [pks,locs] = findpeaks(prall,'MINPEAKDISTANCE',MPD);

    
    
    X=(data(:,3)+data(:,4))/2;
    Z = linkage(X);

    if (std(X)<10)
        NumLines=1;
    else
        NumLines=size(pks,2);
    end

    if(NumLines>maxNumLines)
        NumLines=maxNumLines;
    end
    c = cluster(Z,'maxclust',NumLines);
end