%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [positionOut,name]=PCI(I,scaleFactor,bar,SearchPartLibrary)

bar.update();
%q1=q2;
[Ir,~]=SearchPartLibrary.rotCorrection(I);                                 % corrects the Image if it is rotated

scale=14.714/scaleFactor;                               % scale for PCI search to reduce search time 

I1=imresize(Ir,0.660*scale);

load('PCIData/mask');

x1=7; x2=23;       % min, max of connector size in x direction
y1=3; y2=13;       % min, max of connector size in x direction

I2=rgb2gray(I1);
I3=imadjust(I2);

BW=adaptivethreshold(I3,[15,15],0,0);       % convert to binary image

BW = xor(bwareaopen(BW,30),  bwareaopen(BW,200));            % skip blobs with area between 30 and 200
bar.update(); 



% search for horizontal PCIs

CC = bwconncomp(BW,4);
blobs=regionprops(CC,'Centroid','BoundingBox');

b=cat(1,blobs.BoundingBox);
ind1=(b(:,3)>y1) .* (b(:,3)<y2) .* (b(:,4)>x1) .* (b(:,4)<x2);      % extract connectors in the range of min and max size

BW1=zeros(size(BW));

pix1=CC.PixelIdxList(find(ind1));
BW1(cell2mat(pix1')) = 1;                              


CC = bwconncomp(BW1,4);
blobs=regionprops(CC,'Centroid','BoundingBox');
Cent1=cat(1,blobs.Centroid);

dist=pdist2(Cent1,Cent1);
dist(dist==0)=100;

BWq=zeros(size(BW1));

su=sum((dist<15).*(dist>10),2);                                 % skip blobs with hight distance between each other
pix1=CC.PixelIdxList(find(su>0));
BWq(cell2mat(pix1')) = 1;

%mask=imresize(mask,1.0668);
mask=imresize(mask,1.1336);
map = conv2(single(BWq),single(mask));                     % convolution of image with PCI mask
mapH=map(1:end-size(mask,1),1:end-size(mask,2));

[partsHT,positionHT,valuesHT]=getMaxMask(I1,mapH,mask,9,10,[0,0],[1000,1000000]);      % get PCI-images of map
[partsHB,positionHB,valuesHB]=getMaxMask(BWq,mapH,mask,9,10,[0,0],[1000,1000000]);

% check size of PCI bus
[b,a]=butter(9,30/1000,'low');
partsH=[];
positionH=[];
for i=1:size(partsHB,2)
    m=mean(partsHB{i});
    if(size(m,2)>100)
        m1=filtfilt(b,a,m);
        max1=max(m1(1:100));
        max2=max(m1(end-100:end-100));
        if((max1>0.05) && (max2>0.05))
            partsH{end+1}=partsHT{i};
            positionH(end+1,:)=positionHT(i,:);
        end
    end
end
    
bar.update(); 


% search for vertical PCIs

CC = bwconncomp(BW,4);
blobs=regionprops(CC,'Centroid','BoundingBox');

BW2=zeros(size(BW));
b=cat(1,blobs.BoundingBox);
ind=(b(:,3)>x1) .* (b(:,3)<x2) .* (b(:,4)>y1) .* (b(:,4)<y2);       % extract connectors in the range of min and max size
pix1=CC.PixelIdxList(find(ind));
BW2(cell2mat(pix1')) = 1;

CC = bwconncomp(BW2,4);
blobs=regionprops(CC,'Centroid','BoundingBox');
Cent2=cat(1,blobs.Centroid);

dist=pdist2(Cent2,Cent2);
dist(dist==0)=100;

BWq=zeros(size(BW2));

d=15*(size(BW2,2)/1696);
d1=d-5;
d2=d+5;
su=sum((dist>d1).*(dist<d2),2);                     % skip blobs with hight distance between each other
pix1=CC.PixelIdxList(find(su>0));
BWq(cell2mat(pix1')) = 1;
                                     
map = conv2(single(BWq),single(mask)');
mapV=map(1:end-size(mask,2),1:end-size(mask,1));

[partsVT,positionVT,valuesVT]=getMaxMask(I1,mapV,mask',9,10,[0,0],[1000,1000000]);         % get PCI-images of map
[partsVB,positionVB,valuesVB]=getMaxMask(BWq,mapV,mask',9,10,[0,0],[1000,1000000]);         % get PCI-images of map

% check size of PCI bus
[b,a]=butter(9,30/1000,'low');
partsV=[];
positionV=[];
for i=1:size(partsVB,2)
    m=mean(partsVB{i},2);
    if(size(m,1)>100)
        m1=filtfilt(b,a,m);
        max1=max(m1(1:100));
        max2=max(m1(end-100:end-100));
        if((max1>0.05) && (max2>0.05))
            partsV{end+1}=partsVT{i};
            positionV(end+1,:)=positionVT(i,:);
        end
    end
end
    
bar.update(); 


positionOut=[positionH;positionV];
positionOut=positionOut./(0.660*scale);                                % rescale position to orignal image size

name= cell(1,size(positionOut,1));
name= cellfun(@(p) ('PCI'),name,'UniformOutput', false);    % fill part value with string "PCI"

end
