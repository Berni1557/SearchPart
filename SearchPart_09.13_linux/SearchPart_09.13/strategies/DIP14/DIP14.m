%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [positionOut,StrName]=DIP14(image,scaleFactor,bar,SearchPartLibrary) 

I(:,:,1)=imadjust(image(:,:,1));
I(:,:,2)=imadjust(image(:,:,2));
I(:,:,3)=imadjust(image(:,:,3));
[Ir,~]=SearchPartLibrary.rotCorrection(I);
scale_factor_zoom=19.5480/scaleFactor;
% get horizontal map for DIP14 parts
[mapH]=searchPCADIP14(Ir,scale_factor_zoom,bar);
bar.update();
% get vertical map for DIP14 parts
[mapV]=searchPCADIP14(imrotate(Ir,90),scale_factor_zoom,bar);      
bar.update();
% tolerance for cutting the part
tol=[0.3,0.3];
% get parts from horizontal and vertical map
[parts,position1,valueOut]=getMaxMask(Ir,scale_factor_zoom,mapH,mapV,5,15,tol,[0,10000000]);       
bar.update();
% cut the black area with characters of the part
[Wtext,position2]=cutText(parts,position1,tol,bar);
bar.update();
% get text of the part
[output1,output2]=getText(Wtext,bar);
bar.update();
% search for words in the list of all parts
[err1,StrName1]=searchWord(output1,bar,SearchPartLibrary);
[err2,StrName2]=searchWord(output2,bar,SearchPartLibrary);
bar.update();
% get strings with less errors
[StrName,positionOut]=getBestMatch(err1,StrName1,err2,StrName2,position2); 

%to=toc;
%str=['dip',num2str(round(to*100000))];
%save(str);

end


