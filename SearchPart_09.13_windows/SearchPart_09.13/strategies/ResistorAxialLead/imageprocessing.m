%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Iout=imageprocessing(I)

I1=rgb2gray(I);
I2 = imadjust(I1);
I3=medfilt2(I2,[3 3]);
[gx,gy]=gaussgradient(I3,2);
Iout=(abs(gx)+abs(gy));
% Ir=rgb2gray(I);
% Iout=imadjust(Ir);


% I1=I(:,:,1);
% I2 = imadjust(I1);
% I3=medfilt2(I2,[3 3]);
% [gx,gy]=gaussgradient(I3,1.5);
% Iout=(abs(gx)+abs(gy));
% Ia=Iout;
% 
% I1=I(:,:,2);
% I2 = imadjust(I1);
% I3=medfilt2(I2,[3 3]);
% [gx,gy]=gaussgradient(I3,1.5);
% Iout=(abs(gx)+abs(gy));
% Ia=Ia+Iout;
% 
% I1=I(:,:,3);
% I2 = imadjust(I1);
% I3=medfilt2(I2,[3 3]);
% [gx,gy]=gaussgradient(I3,1.5);
% Iout=(abs(gx)+abs(gy));
% Ia=Ia+Iout;
% Ia(Ia<180)=0;
% Iout=I2;
end