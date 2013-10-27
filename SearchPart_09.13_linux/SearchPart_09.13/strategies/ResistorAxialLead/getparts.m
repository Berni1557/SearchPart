%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[parts,position]=getpartsSMD(I,mapH,mapV,scale_factor_zoom,searchScale)

load('ResistorG1Data/mask');
load ('ResistorG1Data/PCA');
se = strel('rectangle',[2 2]);

partsV=[];
partsH=[];
mapH = imerode(mapH,se);
mapH(mapH<0)=0;

mapV = imerode(mapV,se);
mapV(mapV<0)=0;


W1map=round(size(mask,1));
W2map=round(size(mask,2));
W1=W1map/searchScale;
W2=W2map/searchScale;

mapH=double(mapH);
I=imresize(I,scale_factor_zoom);

%imshow(I)
%hold on
positionH=[];
m=mapH;
m(m<0)=0;
m(m>0)=1;

numparts=sum(m(:));
for i=1:numparts
    outOfRange=false;
    [amap,bmap,value]=maxM(mapH);

    cmap(1)=floor(amap-3);
    cmap(2)=floor(amap+3);
    cmap(3)=floor(bmap-10);
    cmap(4)=floor(bmap+10);

    b=bmap/searchScale;
    a=amap/searchScale;
    
    c(1)=floor(a-(W1/2)+1);
    c(2)=floor(a+(W1/2));
    c(3)=floor(b-(W2/2)+1);
    c(4)=floor(b+(W2/2));
    
    if (c(1)<1 || cmap(1)<1)
        c(1)=1;
        outOfRange=true;
    end
    if(c(2)>size(I,1) || cmap(2)>size(mapH,1))
        c(2)=size(I,1);
        outOfRange=true;
    end
    if (c(3)<1 || cmap(3)<1)
        c(3)=1;
        outOfRange=true;
    end
    if(c(4)>size(I,2))
        c(4)=size(I,2);
        outOfRange=true;
    end
    if(value<0)
        outOfRange=true;
    end
    if(outOfRange==false)
        W=I(c(1):c(2),c(3):c(4),:);
        partsH{end+1}=W;
        positionH(end+1,1:2)=[round(b),round(a)];
    end
    
    if(cmap(1)<1)
        cmap(1)=1;
    end
    if(cmap(2)>size(mapH,1))
        cmap(2)=size(mapH,2);
    end
    if(cmap(3)<1)
        cmap(3)=1;
    end
    if(cmap(4)>size(mapH,2))
        cmap(4)=size(mapH,2);
    end
    
    mapH(cmap(1):cmap(2),cmap(3):cmap(4))=zeros((cmap(2)-cmap(1))+1,(cmap(4)-cmap(3))+1); 
    %mapH(amap-1:amap+1,bmap)=0; 

    
    %plot(round(b),round(a),'r+');
    %plot(round(bmap),round(amap),'r+');

    
end



mask=imrotate(mask,90);

W1map=round(size(mask,1));
W2map=round(size(mask,2));
W1=W1map/searchScale;
W2=W2map/searchScale;

mapV=double(mapV);
positionV=[];

m=mapV;
m(m<0)=0;
m(m>0)=1;

numparts=sum(m(:));

mapV=imrotate(mapV,180);

for i=1:numparts
    outOfRange=false;
    [amap,bmap,value]=maxM(mapV);
    
    cmap(1)=floor(amap-3);
    cmap(2)=floor(amap+3);
    cmap(3)=floor(bmap-10);
    cmap(4)=floor(bmap+10);

    b=bmap/searchScale;
    a=amap/searchScale;
    
    c(1)=floor(b-(W1/2)+1);
    c(2)=floor(b+(W1/2));
    c(3)=floor(size(I,2)-a-(W2/2)+1);
    c(4)=floor(size(I,2)-a+(W2/2));
    
    if (c(1)<1 || cmap(1)<1)
        c(1)=1;
        outOfRange=true;
    end
    if(c(2)>size(I,1) || cmap(2)>size(mapH,1))
        c(2)=size(I,1);
        outOfRange=true;
    end
    if (c(3)<1 || cmap(3)<1)
        c(3)=1;
        outOfRange=true;
    end
    if(c(4)>size(I,2))
        c(4)=size(I,2);
        outOfRange=true;
    end
    if(value<0)
        outOfRange=true;
    end
    if(outOfRange==false)
        W=I(c(1):c(2),c(3):c(4),:);
        partsV{end+1}=imrotate(W,90);
        positionV(end+1,1:2)=[size(I,2)-round(a),round(b)];
    end
    
        
    if(cmap(1)<1)
        cmap(1)=1;
    end
    if(cmap(2)>size(mapV,1))
        cmap(2)=size(mapV,2);
    end
    if(cmap(3)<1)
        cmap(3)=1;
    end
    if(cmap(4)>size(mapV,2))
        cmap(4)=size(mapV,2);
    end
    
    mapV(cmap(1):cmap(2),cmap(3):cmap(4))=zeros((cmap(2)-cmap(1))+1,(cmap(4)-cmap(3))+1); 
    %plot(size(I,2)-round(a),round(b),'r+');

end

parts=partsH;
for i=1:size(partsV,2)
    parts{end+1}=partsV{i};
end


position=[positionH;positionV];





end
