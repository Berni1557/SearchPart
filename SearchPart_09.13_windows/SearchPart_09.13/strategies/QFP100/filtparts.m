%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Wout,positionOut]=filtparts(partsAll,positionIn)
Wout=[];
positionOut=[];

for im=1:size(partsAll,2)
    W=partsAll{im};
    pix1=round((70*size(W,1))/463);         % horizontal margin
    pix2=round((70*size(W,1))/983);         % vertical margin
    
    W1=rgb2gray(W);
    
    meanConn=18*(size(W1,1)/461);
    meanfreq1=(1/meanConn)*size(W1,1);      % freqency peak in horizontal direction
    meanfreq2=(1/meanConn)*size(W1,2);      % freqency peak in vertical direction
    
    s1x=round(meanfreq1-20);
    s2x=round(meanfreq1+20);
    
    s1y=round(meanfreq2-20);
    s2y=round(meanfreq2+20);
    
    % Side 1
    Wx1=W1(pix2:end-pix2,1:pix1);           % get maximal frequency of left side 
    Wx1=imadjust(Wx1);
    for i=1:size(Wx1,2)
        x=double(Wx1(:,i));
        X = fft(x,size(x,1));
        Pxx1 = X.*conj(X)/size(x,1);
        Px1=Pxx1(s1x:s2x);
        [v,posx1]=max(Px1);
        vAll(i)=v;
    end
    val1=max(vAll);
    
    
    % Side 2
    Wx2=W1(1:pix1,pix2:end-pix2);           % get maximal frequency of top side 
    Wx2=imadjust(Wx2);
    for i=1:size(Wx2,1)
        x=double(Wx2(i,:))';
        X = fft(x,size(x,1));
        Pxx1 = X.*conj(X)/size(x,1);
        Px1=Pxx1(s1y:s2y);
        [v,posx1]=max(Px1);
        vAll(i)=v;
    end
    val2=max(vAll);
    
        
    % Side 3
    Wx3=W1(pix2:end-pix2,end-pix1:end);     % get maximal frequency of right side 
    Wx3=imadjust(Wx3);
    for i=1:size(Wx3,2)
        x=double(Wx3(:,i));
        X = fft(x,size(x,1));
        Pxx1 = X.*conj(X)/size(x,1);
        Px1=Pxx1(s1x:s2x);
        [v,posx1]=max(Px1);
        vAll(i)=v;
    end
    val3=max(vAll);
    
     % Side 4
    Wx4=W1(end-pix1:end,pix2:end-pix2);     % get maximal frequency of bottom side 
    Wx4=imadjust(Wx4);
    for i=1:size(Wx4,1)
        x=double(Wx4(i,:))';
        X = fft(x,size(x,1));
        Pxx1 = X.*conj(X)/size(x,1);
        Px1=Pxx1(s1y:s2y);
        [v,posx1]=max(Px1);
        vAll(i)=v;
    end
    val4=max(vAll);   

    sumval=val1+val2+val3+val4;
    if(val1>100000 && val2>200000 && val3>100000 && val4>200000)    % threshold of maximal freqeuncies
        Wout{end+1}=W;
        positionOut(end+1,:)=positionIn(im,:);                      % update positions
    end
end

end


