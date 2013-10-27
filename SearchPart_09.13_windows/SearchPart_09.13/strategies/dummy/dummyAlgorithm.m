%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%dummy of your algorith
function [position,name]=dummyAlgorithm(image,scaleFactor,bar,SearchPartLibrary)

%Inputs:
%
% image -               image of the circuid board
%
% scaleFactor -         is the scale factor which gives you information about
%                       the size of the image (100 pixel~10mm) 
%
% bar -                 (optional) is an processbar object. Just place bar.update(); between your code to update the progress bar
%
% searchPartLibrary -   (optional) is a structure of maybe usefull
%                       algorithms for your code
%
%Outputs:
%
% position -            is an nx2 array of the positions of the parts where n is the numbers of parts
%
% name -                is a cell array of n strings with the name of the
%                       part or the value of the part (SI base units)

%%%%%%%%%%%%%%%%%%%%%%%% paste your algorithm here! %%%%%%%%%%%%%%%%%%%%%%%


[Ir,~]=SearchPartLibrary.rotCorrection(image);                      % rotation correction is not necessary but probably usefull
% do some stuff
bar.update();                                                   % update progress bar
pause(5);                                                       % pause command is just to see what happends
position=[232, 914;830, 1710;1060, 320];                        % 3x2 array of part positions
name={'dummy: NE592N','dummy: SN74HC238N','dummy:74HC4086N'};     % 1x3 array of part names

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end