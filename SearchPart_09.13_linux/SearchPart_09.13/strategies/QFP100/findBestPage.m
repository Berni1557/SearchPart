%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [StrName,positionOut]=findBestPage(output1,output2,positionIn)


[Strings1,Strings2]=splitString(output1,output2);   % split the string in words

[pages1,pages2]=getAllPages(Strings1,Strings2);     % search for datasheetpages on www.datasheetarchive.com

[err1,StrName1,err2,StrName2]=searchWord(Strings1,Strings2,pages1,pages2); %search for the words and it's and some variants

[StrName,positionOut]=getBestMatch(err1,StrName1,err2,StrName2,positionIn);    % get best match by smallest error


end













