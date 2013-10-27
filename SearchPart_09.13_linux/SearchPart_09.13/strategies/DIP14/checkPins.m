function [pintop,pinbottom]=checkPins(Win,x,y)

    Win(:,:,1)=imadjust(Win(:,:,1));
    Win(:,:,2)=imadjust(Win(:,:,2));
    Win(:,:,3)=imadjust(Win(:,:,3));
    
    tol=[0.3, 0.1];
    h1=round(310*((size(Win,1)/480))/(1+tol(1)));
    h2=round(960*((size(Win,2)/1050))/(1+tol(2)));
    
    % calculate border of the of the part
    if((x-(h1/2))<=1);   x1=1;    elseif ((x-(h1/2))>size(Win,1)); x1=size(Win,1);     else   x1=round(x-(h1/2));  end

    if((x+(h1/2))<=1);   x2=1;   elseif ((x+(h1/2))>size(Win,1));  x2=size(Win,1);    else   x2=round(x+(h1/2));  end

    if((y-(h2/2))<=1);   y1=1;    elseif ((y-(h2/2))>size(Win,2)); y1=size(Win,2);     else   y1=round(y-(h2/2));  end

    if((y+(h2/2))<=1);   y2=1;   elseif ((y+(h2/2))>size(Win,2));  y2=size(Win,2);    else   y2=round(y+(h2/2));  end
    
    tresh=100;

    meanConn=62*(size(Win,1)/301);
    meanfreq1=(1/meanConn)*size(Win,1);      % freqency peak in horizontal direction
    meanfreq2=(1/meanConn)*size(Win,2);      % freqency peak in vertical direction
    
    s1x=round(meanfreq1-20);
    s2x=round(meanfreq1+20);
    
    s1y=round(meanfreq2*0.5);
    s2y=round(meanfreq2*2);
    
    % Side 2
    Wx2=Win(1:x1,y1:y2,:);           % get maximal frequency of top side 
    Wx2=rgb2gray(Wx2);
    Wx2f=imadjust(Wx2);
    
    h1=round(10*(size(Win,2)/648));
    h = fspecial('average', [h1,1]);
    Wx2=filter2(h, Wx2f);
    
    for i=1:size(Wx2,1)
        x=double(Wx2(i,:))';
        X = fft(x,size(x,1));
        Pxx1 = X.*conj(X)/size(x,1);
        Px1=Pxx1(s1y:s2y);
        [v,posx1]=max(Px1);
        vAll(i)=v;
    end
    [val2,posl]=max(vAll);
    d1=double(Wx2(posl,:))';
    %pintop=val2;
    
    

    [b,a]=butter(9,(50/(1000*(size(Win,2)/648))),'low');
    f1=filtfilt(b,a,d1);
    MPD=round(70*(size(Win,2)/1037));
    [pksTop,locsTop] = findpeaks(f1,'MINPEAKDISTANCE',MPD);
    pksTop=pksTop(pksTop>tresh);
    pintop=size(pksTop,1);
    
    % Side 4
    Wx4=Win(x2:end,y1:y2,:);     % get maximal frequency of bottom side 
    Wx4=rgb2gray(Wx4);
    Wx4f=imadjust(Wx4);
    
    Wx4=filter2(h, Wx4f);
    
    vAll=[];
    for i=1:size(Wx4,1)
        x=double(Wx4(i,:))';
        X = fft(x,size(x,1));
        Pxx1 = X.*conj(X)/size(x,1);
        Px1=Pxx1(s1y:s2y);
        [v,posx1]=max(Px1);
        vAll(i)=v;
    end
    [val4,posl]=max(vAll);  
    d2=double(Wx4(posl,:))';
    %pinbottom=val4;
    
    [b,a]=butter(9,(50/(1000*(size(Win,2)/648))),'low');

    f2=filtfilt(b,a,d2);
    [pksBottom,locsBottom] = findpeaks(f2,'MINPEAKDISTANCE',MPD);

    pksBottom=pksBottom(pksBottom>tresh);
    pinbottom=size(pksBottom,1);    
end