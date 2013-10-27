%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output1,output2]=getTextData(Win,SearchPartLibrary)

output1=[];
output2=[];

for im=1:size(Win,2)

    W1=Win{im};
    cut=round((70*size(W1,1))/463);         % compute margin
    W2=W1(cut:end-cut,cut:end-cut,:);       % cut margin
    W2=imrotate(W2,90);                     % rotate part
    
    b31=round(40*(size(W2,1)/473)-30);      % compute approximated size of characters
    b32=round(40*(size(W2,1)/473)+80);
    b41=round(55*(size(W2,1)/473)-25);
    b42=round(55*(size(W2,1)/473)+25);
    
    
    W3=rgb2gray(W2);
    W4=imadjust(W3);                        % adjust brightness                 % erode image
    W5 = W4;
    W6=imadjust(W5);                        % adjust brightness
    BW1=im2bw(W6,0.6);                      % threshold image
    
    [BW2]=reduceSmall(BW1,b31,b32,b41,b42);     % reduce to small blobs
    [BW3]=reduceSingle(BW2,b31,b32,b41,b42);     % reduce to small blobs
    T=BW3;

    %[Tes1,Tes2]=OCRNet(T);          % optical character recognition with neural network
    [Tes1,Tes2]=OCRtesseract(T,SearchPartLibrary);
    output1{im}=Tes1;               % output1 are the strings without rotating
    output2{im}=Tes2;               % output2 are the strings by rotating about 180°
end 


end

function [BW1]=reduceSmall(BW,b31,b32,b41,b42)      % reduce to small blobs
    CC = bwconncomp(BW,4);
    blobs=regionprops(CC,'BoundingBox');

    BW1=zeros(size(BW));
    b=cat(1,blobs.BoundingBox);
    ind=((b(:,3)>b31) .* (b(:,3)<b32) .* (b(:,4)>b41) .* (b(:,4)<b42));
    pos=find(ind);
    pixind=cat(1,CC.PixelIdxList(pos));
    pixind1 = cat(1, pixind{:});        
    BW1(pixind1) = 1;
end

function [BW1]=reduceSingle(BW,b31,b32,b41,b42)      % reduce single blobs in a line
    
    BW1=zeros(size(BW));
    sumP=sum(BW,2);
    x=-sumP;
    [pks,locs] = findpeaks(x);
    locs2=locs(pks==0);
    locs3=[0;locs2;size(BW,1)];

    CC = bwconncomp(BW,4);
    blobs=regionprops(CC,'Centroid');
    cent=cat(1,blobs.Centroid);
    if(~isempty(cent))
        for l=1:size(locs2,1)+1
            ind=(cent(:,2)>locs3(l)) .* (cent(:,2)<locs3(l+1));
            if (sum(ind)>=3)
                pos=find(ind);
                pixind=cat(1,CC.PixelIdxList(pos));
                pixind1 = cat(1, pixind{:});
                BW1(pixind1) = 1;
            end
        end
    end

end





