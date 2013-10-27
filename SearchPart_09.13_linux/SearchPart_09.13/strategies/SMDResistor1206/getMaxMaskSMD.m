%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [parts,position,valueOut]=getMaxMaskSMD(I,scale_factor_zoom,mapH,mapV,maskpos,numparts,tol,treshold)
%map and I have same size
%maskpos=1:9
%%%%%%%%%%%
% 1  2  3 %
% 4  5  6 %
% 7  8  9 %
%%%%%%%%%%%
%tol=[0.2,0.2];
%treshold=[0.5,0.7]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('ResistorSMDData/mask')
mask=imresize(mask,1/scale_factor_zoom);
mask=imresize(mask,0.5);
%mask=imrotate(mask,90);
%mapH=imresize(mapH,[size(I,1),size(I,2)]);  % resize mapH to size of the image
%h = fspecial('average',100);
%mapH=imfilter(mapH,h,'replicate');
mapH(mapH<treshold(1))=0;
valueOutH=[];
partsH=[];
positionH=[];
position=[];
parts=[];
%imshow(I);
%hold on,
for i=1:numparts
    outOfRange=false;
    [a,b,value]=maxM(mapH);                         % get maiximum value of horizontal map
    
    if(value<treshold(1) || value> treshold(2))
        outOfRange=true;
    end
    
    [c,cm,outOfRange]=getPos(mask,maskpos,a,b,tol,I);           % get position of the part and check range

    if(outOfRange==false)
        W=I(c(1):c(2),c(3):c(4),:);                             % crop horizontal part from image
        partsH{end+1}=W;
        valueOutH(end+1)=value;
        positionH(end+1,1:2)=[round(b),round(a)];
    end   
    mapH(cm(1):cm(2),cm(3):cm(4))=zeros((cm(2)-cm(1))+1,(cm(4)-cm(3))+1);       % delete horizontal part in horizontal map
    %plot(b,a,'r+');
end
% if(~isempty(partsH))
%     partsH= cellfun(@(p) (imrotate(p,90)),partsH,'UniformOutput', false);    
% end
mapV(mapV<0.75)=0;
mapV=imrotate(mapV,-90);
mapV=imresize(mapV,[size(I,1),size(I,2)]);
mask=imrotate(mask,-90);
valueOutV=[];
partsV=[];
positionV=[];

for i=1:numparts
    outOfRange=false;
    [a,b,value]=maxM(mapV);                             % get maximum value of vertical map
    
    if(value<treshold(1) || value> treshold(2))
        outOfRange=true;
    end
    
    [c,cm,outOfRange]=getPos(mask,maskpos,a,b,tol,I);           % get position of the part and check range

    if(outOfRange==false)
        W=I(c(1):c(2),c(3):c(4),:);                             % crop vertical part from image
        partsV{end+1}=W;
        valueOutV(end+1)=value;
        positionV(end+1,1:2)=[round(b),round(a)];
    end   
    mapV(cm(1):cm(2),cm(3):cm(4))=zeros((cm(2)-cm(1))+1,(cm(4)-cm(3))+1);       % delete vertical part in horizontal map
end
if(~isempty(partsV))
    partsV= cellfun(@(p) (imrotate(p,90)),partsV,'UniformOutput', false);    
end
parts=[partsH,partsV];
%parts=partsV;
position=[positionH;positionV];
valueOut=[valueOutH,valueOutV];
end





function [c,cm,outOfRange]=getPos(mask,maskpos,a,b,tol,I)               % get position of the part and check range
W1m=size(mask,1);
W2m=size(mask,2);
W1=round(W1m*(1+tol(1)));
W2=round(W2m*(1+tol(2)));
switch(maskpos)                                         % get position of part depending on mask position (left upper corner(1) ...right lower corner (9)
    case 1
        p11=a;
        p12=a+W1;
        p21=b;
        p22=b+W2;
    
    case 2
        p11=round(a-W1/2);
        p12=round(a+W1/2);
        p21=b;
        p22=b+size(mask,2);    
        
    case 3        
        p11=round(a-W1);
        p12=round(a);
        p21=b;
        p22=b+W2;      
                
    case 4        
        p11=a;
        p12=a+W1;
        p21=round(b-W2/2);
        p22=round(b+W2/2);
    
    case 5        
        p11=round(a-W1/2);
        p12=round(a+W1/2);
        p21=round(b-W2/2);
        p22=round(b+W2/2);
    
    case 6        
        p11=round(a-W1);
        p12=a;
        p21=round(b-W2/2);
        p22=round(b+W2/2);
        
    case 7
        p11=a;
        p12=a+W2;
        p21=b-W2;
        p22=b;
    
    case 8
        p11=round(a-W1/2);
        p12=round(a+W1/2);
        p21=b-W2;
        p22=b;
    case 9
        p11=a-W1;
        p12=a;
        p21=b-W2;
        p22=b;
end   
c=[p11,p12,p21,p22];
outOfRange=false;                   
if (c(1)<1)
    c(1)=1;
    outOfRange=true;
end
if(c(2)>size(I,1))
    c(2)=size(I,1);
    outOfRange=true;
end
if (c(3)<1)
    c(3)=1;
    outOfRange=true;
end
if(c(4)>size(I,2))
    c(4)=size(I,2);
    outOfRange=true;
end



        
W1m=size(mask,1);
W2m=size(mask,2);
W1=round(W1m*(1+tol(1)));
W2=round(W2m*(1+tol(2)));
switch(maskpos)                                         % get position of part depending on mask position (left upper corner(1) ...right lower corner (9)
    case 1
        p11=a;
        p12=a+W1m;
        p21=b;
        p22=b+W2m;
    
    case 2
        p11=round(a-W1m/2);
        p12=round(a+W1m/2);
        p21=b;
        p22=b+size(mask,2);    
        
    case 3        
        p11=round(a-W1m);
        p12=round(a);
        p21=b;
        p22=b+W2m;      
                
    case 4        
        p11=a;
        p12=a+W1;
        p21=round(b-W2m/2);
        p22=round(b+W2m/2);
    
    case 5        
        p11=round(a-W1m/2);
        p12=round(a+W1m/2);
        p21=round(b-W2m/2);
        p22=round(b+W2m/2);
    
    case 6        
        p11=round(a-W1m);
        p12=a;
        p21=round(b-W2m/2);
        p22=round(b+W2m/2);
        
    case 7
        p11=a;
        p12=a+W2m;
        p21=b-W2m;
        p22=b;
    
    case 8
        p11=round(a-W1m/2);
        p12=round(a+W1m/2);
        p21=b-W2m;
        p22=b;
    case 9
        p11=a-W1m;
        p12=a;
        p21=b-W2m;
        p22=b;
end   
cm=[p11,p12,p21,p22];
    
outOfRange=false;                   
if (cm(1)<1)
    cm(1)=1;
    outOfRange=true;
end
if(cm(2)>size(I,1))
    cm(2)=size(I,1);
    outOfRange=true;
end
if (cm(3)<1)
    cm(3)=1;
    outOfRange=true;
end
if(cm(4)>size(I,2))
    cm(4)=size(I,2);
    outOfRange=true;
end

end



