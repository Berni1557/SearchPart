%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [out,position2]=extractNumber(parts,position1)
f1=size(parts{1},1);                    % horizontal size of the parts
f2=size(parts{1},2);                    % vertical size of the parts

s1=20*(f1/73);                          
s2=35*(f2/126);
s11=10; s12=s1+20;                   % high of number is between s11 and s12
s21=20; s22=s2+30;                   % width of number is between s21 and s22

% cut the margin to extract the numbers (left and right margin is cut1, topand buttom margin is cut2)
cut1=round(12*(f1/73));
cut2=round(20*(f2/126));
for i=1:size(parts,2)
    W=parts{i};
    parts{i}=W(cut1:end-cut1,cut2:end-cut2,:);
end

out=[];
position2=[];
for i=1:size(parts,2)
    W=parts{i};                                     % take an image of the resistor array
    W1=rgb2gray(W);  
    se1 = strel('square',2);
    W1=imdilate(W1,se1);
    BW=imadjust(W1);                                % adjust contrast
    [t,~,~] = niblack(BW, -0.2, 5);                     % transform to bw image
    BW1=(BW > abs(t));
    
    CC = bwconncomp(BW1,4);
    blobs=regionprops(CC,'BoundingBox','Image','Centroid');
    bb = cat(1, blobs.BoundingBox);
    cent = cat(1, blobs.Centroid);
    ind=(bb(:,3)>s11) .* (bb(:,3)<s12) .* (bb(:,4)>s21) .* (bb(:,4)<s22);    % extract blobs that high is between s11 and s12 and width is between s21 and s22
    BW2=zeros(size(BW1));
    if(sum(ind)==3)                             % check if the number of blobs that could be a numbersr of the image is 3
        position2(end+1,:)=position1(i,:);
        for o=1:size(ind,1)
            if(ind(o))
                BW2=blobs(o).Image;         % extract the image if one number
                out{end+1}=BW2;
            end
        end 
    else
    end
    
end
