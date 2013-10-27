%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Wtext,positionOut]=cutText(partsAll,positionIn,tol,bar)

Wtext=[];
positionOut=[];
for im=1:size(partsAll,2)
    bar.update();
    
    Win=partsAll{im};
    W=Win;
    % use nedian filter to get mean value of color
    W(:,:,1) = medfilt2(W(:,:,1), [10 10]);
    W(:,:,2) = medfilt2(W(:,:,2), [10 10]);
    W(:,:,3) = medfilt2(W(:,:,3), [10 10]);
    
    % calculate horizontal and vertical size of the part
    h1=round(310*((size(W,1)/480))/(1+tol(1)));
    h2=round(960*((size(W,2)/1050))/(1+tol(2)));
    
    % midpoint of the part
    x=round(size(W,1)/2);
    y=round(size(W,2)/2);
    
    s1=round(size(W,1)/2);
    s2=round(size(W,2)/2);   
    
    % calculate border of the mid rectangle
    pix=round(30*(size(W,2)/590));

    if((x-(s1/2)+pix)<0);   x1max=1; elseif ((x-(s1/2)+pix)>size(W,1)); x1max=size(W,1);    else    x1max=round(x-(s1/2)+pix); end
        
    if((x+(s1/2)-pix)<0);   x2min=1;    elseif ((x+(s1/2)-pix)>size(W,1));  x2min=size(W,1);    else    x2min=round(x+(s1/2)-pix);  end
 
    if((y-(s2/2)+pix)<0);   y1max=1; elseif ((y-(s2/2)+pix)>size(W,2)); y1max=size(W,2);    else    y1max=round(y-(s2/2)+pix); end
        
    if((y+(s2/2)-pix)<0);   y2min=1;    elseif ((y+(s2/2)-pix)>size(W,2));  y2min=size(W,2);    else    y2min=round(y+(s2/2)-pix);  end

    T=W(x1max:x2min,y1max:y2min,:);
    T1=double(reshape(T,size(T,1)*size(T,2),3));
    
    % get mean and std value of the color
    mu=mean(T1,1);
    sigma=cov(double(T1));
    
    % calculate propability of color for each pixel
    X=double(reshape(W,size(W,1)*size(W,2),3));
    [~,pd]=chol(sigma);
    if(pd==0)
        P=mvnpdf(X,mu,sigma);
        P1=reshape(P,size(W,1),size(W,2));
    else
        P1=zeros(size(W,1),size(W,2));
    end
    P2=P1./max(P1(:));
    
    % use average filter to filter propability to get midpoint of the part
    h = fspecial('average',[h1 h2]);    
    S = imfilter(P2,h,'replicate');
    
    % get first midpoint of the part
    [x,y]=maxM(S);
       
    % calculate border of the of the part
    if((x-(h1/2))<=1);   x1=1;    elseif ((x-(h1/2))>size(W,1)); x1=size(W,1);     else   x1=round(x-(h1/2));  end

    if((x+(h1/2))<=1);   x2=1;   elseif ((x+(h1/2))>size(W,1));  x2=size(W,1);    else   x2=round(x+(h1/2));  end

    if((y-(h2/2))<=1);   y1=1;    elseif ((y-(h2/2))>size(W,2)); y1=size(W,2);     else   y1=round(y-(h2/2));  end

    if((y+(h2/2))<=1);   y2=1;   elseif ((y+(h2/2))>size(W,2));  y2=size(W,2);    else   y2=round(y+(h2/2));  end
    
    % cut area of part to get pixel values
    W1=W(x1:x2,y1:y2,:);
    
    T1=double(reshape(W1,size(W1,1)*size(W1,2),3));
    % get mean and std value of the color
    mu=mean(T1,1);
    sigma=cov(double(T1));
    
    % calculate propability of color for each pixel
    X=double(reshape(W,size(W,1)*size(W,2),3));
    [~,pd]=chol(sigma);
    if(pd==0)
        P=mvnpdf(X,mu,sigma);
        P1=reshape(P,size(W,1),size(W,2));
    else
        P1=zeros(size(W,1),size(W,2));
    end
    
    P1=reshape(P,size(W,1),size(W,2));
    P2=P1./max(P1(:));
    
    p2=mean(P2,1);
    p1=mean(P2,2);
    
    % filter horizontal mean of propability
    p1=[zeros(h1,1);p1;zeros(h1,1)];
    b1=ones(1,h1)/h1;
    a1=1;
    p1f=filtfilt(b1,a1,p1);
    
    % filter vertical mean of propability
    p2=[zeros(1,h2),p2,zeros(1,h2)];
    b2=ones(1,h2)/h2;
    a2=1;
    p2f=filtfilt(b2,a2,p2);
    
    % get mean of propability on top of the part
    Pt=P2(1:x1,y1:y2);
    Ptv=sum(sum(Pt))/(size(Pt,1)*size(Pt,2));
    
    % get mean of propability on bottom of the part
    Pb=P2(x2:end,y1:y2);
    Pbv=sum(sum(Pb))/(size(Pb,1)*size(Pb,2));    
    
    % get mean of propability from the left of the part
    Pl=P2(x1:x2,1:y1);
    Plv=sum(sum(Pl))/(size(Pl,1)*size(Pl,2));
    
    % get mean of propability from the right of the part
    Pr=P2(x1:x2,y2:end);
    Prv=sum(sum(Pr))/(size(Pr,1)*size(Pr,2));  
    
    Wc1=rgb2gray(Win);
    Wc2=imadjust(Wc1);
    Wt=Wc2(x1:x2,y1:y2,:);
    
    % calculate mean value of the grayscaled image
    Pc=sum(sum(Wt))/(size(Wt,1)*(size(Wt,2)));
    
    %[pintop,pinbottom]=checkPins(Win,x1,x2,y1,y2);
    [pintop,pinbottom]=checkPins(Win,x,y);
    % filter parts by propability values
    %imshow(W);
    %close all;
    if(~isempty(Pt) && ~isempty(Pb) && ~isempty(Pl) && ~isempty(Pr))
        if(Ptv<0.3 && Pbv<0.3 && Plv<0.3 && Prv<0.3 && Pc<160 && ((pintop>=7 && pintop<=8) || (pinbottom>=7 && pinbottom<=8)))
            Wtext{end+1}=Win(x1:x2,y1:y2,:);
            positionOut=[positionOut;positionIn(im,:)];
        end
    end

end


