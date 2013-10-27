%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% start SearchPart
% Add directorys to search path and start GUIwelcome GUI
function SearchPart()
    filepath=mfilename('fullpath');
    startPath = regexpi(filepath,'SearchPart');
    filepath=filepath(1:startPath(end)-2);
    if(strcmp(userpath,''))
        userpath(pwd);
        upath=userpath();
    else
        upath=userpath();
    end
    currentpath=upath(1:end-1);
	disp('Starting SearchPart');
    
    currentpath=filepath;
    
    if(strcmp(currentpath,filepath))
        % Add path of strategies and SearchPart-programm
        addpath(genpath([currentpath,'/strategies']));
        addpath(genpath([currentpath,'/SearchPart']));
        
        % open welcome GUI
        GUIwelcome();    
    else
        load('SearchPartVersion');
        disp(['False directory! Browse to the ', SearchPartVersion,' folder and execute ''SearchPart''.']);
    end
end
