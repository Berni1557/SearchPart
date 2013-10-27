%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bw2 = edu_imgcrop(bw)

% Find the boundary of the image
[y2temp x2temp] = size(bw);
x1=1;
y1=1;
x2=x2temp;
y2=y2temp;

% Finding left side blank spaces
cntB=1;
while (sum(bw(:,cntB))==y2temp)
    x1=x1+1;
    cntB=cntB+1;
end

% Finding right side blank spaces
cntB=1;
while (sum(bw(cntB,:))==x2temp)
    y1=y1+1;
    cntB=cntB+1;
end

% Finding upper side blank spaces
cntB=x2temp;
while (sum(bw(:,cntB))==y2temp)
    x2=x2-1;
    cntB=cntB-1;
end

% Finding lower side blank spaces
cntB=y2temp;
while (sum(bw(cntB,:))==x2temp)
    y2=y2-1;
    cntB=cntB-1;
end

% Crop the image to the edge
bw2=imcrop(bw,[x1,y1,(x2-x1),(y2-y1)]); 