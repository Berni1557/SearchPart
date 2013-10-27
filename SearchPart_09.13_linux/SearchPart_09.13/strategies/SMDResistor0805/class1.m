%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Wout,position2]=class1(Wcut1,position1)

load('class1data')
RF = TreeBagger(40,data2,Class); 
Wout=[];
position2=[];
for im=1:size(Wcut1,2)
    
    W7=Wcut1{im};
    
    CC = bwconncomp(W7);
    blobs=regionprops(CC,'Centroid','Area','BoundingBox','Image');
    
    X=[];
    for o=1:CC.NumObjects
        X=[X;blobs(o).Centroid,blobs(o).Area,size(blobs(o).Image)];
    end
    
    if(~isempty(X))
        Y=predict(RF,X);
    else
        Y=[];
    end

    Y1=[];
    for i=1:size(Y,1)
        Y1(i)=str2num(Y{i});
        if(Y1(i)==0)
            W7(CC.PixelIdxList{i}) = 0;
        end
    end

    if(sum(Y1)==3 || sum(Y1)==4 || sum(Y1)==1)
        
        Wout{end+1}=W7;
        position2=[position2;position1(im,:)];
    end
end




