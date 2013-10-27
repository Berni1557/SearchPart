%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Iout=imageprocessing2(I)

I1=I(:,:,1);
I2 = imadjust(I1);
I3=medfilt2(I2,[3 3]);
[gx,gy]=gaussgradient(I3,2);
Io=(abs(gy));
Iout=Io;

I1=I(:,:,2);
I2 = imadjust(I1);
I3=medfilt2(I2,[3 3]);
[gx,gy]=gaussgradient(I3,2);
Io=(abs(gy));
Iout=Iout+Io;

I1=I(:,:,3);
I2 = imadjust(I1);
I3=medfilt2(I2,[3 3]);
[gx,gy]=gaussgradient(I3,2);
Io=(abs(gy));
Iout=Iout+Io;

Iout=Iout./3;





% 
% I1=rgb2gray(I);
% I2 = imadjust(I1);
% I3=medfilt2(I2,[3 3]);
% [gx,gy]=gaussgradient(I3,2);
% %Iout=(abs((gx))+abs((gy)));
% Iout=(abs((gy)));
end