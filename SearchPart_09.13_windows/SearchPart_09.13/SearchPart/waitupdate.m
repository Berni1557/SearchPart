%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function waitupdate(bar,full)

timeTable=get(bar,'UserData');
timeRest=timeTable{1};
timeWait=timeTable{2};
timeDone=timeTable{3};

time=toc;
if(time>0.99*timeRest(1) || full)
    Vn=((timeRest(1)*(1-timeDone))/sum(timeRest))*0.99;
    timeWait=timeDone+Vn;
    waitbar(timeWait,bar);
else
    %waitbar(time/timeRest,bar);
    %Vn=(time*(1-timeWait))/timeRest;
    %Vt=time/sum(timeRest);
    %Vn=Vt*(1-timeWait);
    Vn=(time*(1-timeDone))/sum(timeRest);
    timeWait=timeDone+Vn;
    waitbar(timeWait,bar);
end

timeTable{1}=timeRest;
timeTable{2}=timeWait;
timeTable{3}=timeDone;
set(bar,'UserData',timeTable);
end
