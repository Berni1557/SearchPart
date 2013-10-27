%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [rings,Wout,positionOut]=classNormRing(Win,positionIn,backColor)
%
%classifie rings (Pixel of one ring)
%rings is mx4 or mx5 pixel of rings
%PixelData are the data of color pixel for each color
%Wcut are the Resistors of the rings
%
%ClassRes is array of 4 or 5 entrys with the number of color
%

load('ResistorG1Data/PixelDataSecurity');                   % load Pixelvalues for each color
rings=[];
num=0;
Wout=[];
positionOut=[];
for im=1:size(Win,2)
    PixelData{13}=reshape(backColor{im},size(backColor{im},2)*size(backColor{im},1),3);     % insert backround pixel

    W=Win{im};
    for c=1:13                                          
         P{c}=zeros(size(W,1),size(W,2));
         sigma=cov(double(PixelData{c}));                               % compute mean of pixels
         mu=mean(PixelData{c},1);                                       % compute standard deviation of pixels
         if((~isnan(sigma(1,1))) && (all( all( sigma == sigma' ) ) && min( eig( sigma ) ) > 0));
            X=double(reshape(W,size(W,1)*size(W,2),3));
            [~,pd]=chol(sigma);
            if(pd==0)                                       % use multivariate normal distribution to filter backround pixel
                Px=mvnpdf(X,mu,sigma);
                P{c}=reshape(Px,size(W,1),size(W,2),1);
            else
                P{c}=zeros(size(W,1),size(W,2));
            end
            q(c)=sum(sum(P{c}));
         end

    end

    P13=P{13}./(P{1}+P{2}+P{3}+P{4}+P{5}+P{6}+P{7}+P{8}+P{9}+P{10}+P{11}+P{12}+P{13});  % compute propability of backround pixel
    
    m=mean(P13,1);                                          % calculate rowwise average
    if(size(m,2)>31)
        [b,a] = butter(9,(20/size(m,2)),'low');
        mx=filtfilt(b,a,m);      
    else
        mx=0;
    end

    mind=round(25*(size(m,2)/361));
    minpheight=0.5;
    if(max(mx)>minpheight)
        [pksx,locsx] = findpeaks(mx,'SORTSTR','none','MINPEAKHEIGHT',minpheight,'MINPEAKDISTANCE',mind);    % find peaks of backround along the resistor with minimum distance between peaks and minpeakhight of 0.5
    else
        pksx=[];
        locsx=[];
    end
        

    if(size(locsx,2)>=2)                                    % cut the left and right margin
        W1=W(:,locsx(1):locsx(end),:);
        Pm=P13(:,locsx(1):locsx(end),:);
        m1=m(locsx(1):locsx(end));

        m2=-m1+max(m1);                                     % m2 is propability of non backround colums

        if(size(m2,2)>31)
            [b1,a1] = butter(9,(15/size(m2,2)),'low');       
            m3 = filtfilt(b1,a1,m2);                        % lowpass filter m2
        else
            m3=0;
        end
        
        minpheight=0.3;
        if(max(m3)>minpheight)
            [pks,locs] = findpeaks(m3,'SORTSTR','none','MINPEAKHEIGHT',minpheight,'MINPEAKDISTANCE',mind);          % find position of rings with minimum distance between peaks and minpeakhight of 0.2
        else
            pks=[];
            locs=[];
        end
        
        numpix=round(4*(size(m,2)/151));



        if(size(pks,2)==4 || size(pks,2)==5)                        % check if number of ring is 4 or 5
            positionOut(end+1,:)=positionIn(im,:);
            num=num+1;
            for i=1:size(locs,2)
                if((locs(i)-numpix)>0); d1=locs(i)-numpix; else d1=1; end
                if((locs(i)+numpix)<size(W1,2)); d2=locs(i)+numpix; else d2=size(W1,2); end
                R=W1(:,d1:d2,:);                                    % cut ring
                rings{num}{i}=R;
                Wout{num}=W;
                if(num==9)
                    q=1;
                end
            end            
        end
    end
end
    

end



