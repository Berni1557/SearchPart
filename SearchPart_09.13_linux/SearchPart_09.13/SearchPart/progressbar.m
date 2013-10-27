%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef progressbar < handle
  %TARGET Class for representing a target
  %   A target class knows its angle, signal and range

  properties
    timeTable;      % table with timeRest, timeWait, timeDone. 
    bar;            % progressbar                              
    ticID;          % ID of the waitbar 
    infotext;
    aborted;
  end
    % timeTable - table with timeRest, timeWait, timeDone
    % timeRest - time calculatet until search is finished in seconds (depends on strategy)
    % timeWait - time until the waitbar reaches 1 (0..1)
    % timeDone - time still done by waitbar (0..1)  
    % numImages - maximum number of images to search for
 
  methods
      
%Constructor
    function newprogressbar = progressbar(handles,handle1)     
        newprogressbar.bar=newprogressbar.waitinit(handles,handle1); 
        newprogressbar.infotext=handles.infotext;
        newprogressbar.aborted=false;
    end
    
%Setter methods    
     function set.infotext(obj,infotext)                           % set ID of waitbar
        if(isnumeric(infotext))
            obj.infotext=infotext;
        else
            error('Error: Passed infotext is not numeric!')
        end
     end
     
     function set.ticID(obj,newticID)                           % set ID of waitbar
        if(isnumeric(newticID))
            obj.ticID=newticID;
        else
            error('Error: Passed ticID is not numeric!')
        end
     end 
     
     function set.timeTable(obj,newtimeTable)                   % set timeTable
        if(isstruct(newtimeTable))
            obj.timeTable=newtimeTable;
        else
            error('Error: Passed scaleFactor is not a struct!')
        end
     end

     function set.bar(obj,newbar)                               % set progressbar
        if(isnumeric(newbar))
            obj.bar=newbar;
        else
            error('Error: Passed newbar is not a Number!')
        end
     end

%Getter methods

    function timeTable = get.timeTable(obj)                     % get timeTable
        timeTable = obj.timeTable;              
    end
    
    function ticID = get.ticID(obj)                             % get ID of waitbar
        ticID = obj.ticID;              
    end
    
    function bar = get.bar(obj)                                 % get progressbar
        bar = obj.bar;                   
    end
 
    
    %init waitbar
    function bar=waitinit(obj,handles,handle1)
        [timeRest]=handles.Session.getTimeRest(handles,handle1);
        timeWait=0.01;
        timeDone=0.01;
        obj.timeTable.timeRest=timeRest;              %time calculatet until search is finished in seconds (depends on strategy)
        obj.timeTable.timeWait=timeWait;              %time until the waitbar reaches 1 (0..1)
        obj.timeTable.timeDone=timeDone;              %time still done by waitbar (0..1) 
        obj.timeTable.numImages=size(timeRest,2);
        
        numImages=size(timeRest,2);
        num=numImages-size(timeRest,2)+1;
        numStr=['Please wait... Image: ' ,num2str(num),'/',num2str(numImages)];
        bar = waitbar(timeWait,numStr,'CreateCancelBtn',{@abort_callback, obj});   %create waitbar
        %bar = waitbar(timeWait,numStr);
        obj.ticID = tic;
    end
    
    %reset waitbar depending on not yet searched components and images
    function waitreset(obj)
        obj.timeTable.timeDone=obj.timeTable.timeWait;
        if(size(obj.timeTable.timeRest,2)>1)
            obj.timeTable.timeRest=obj.timeTable.timeRest(2:end);
        end
        obj.ticID=tic;  
    end
    
    %close wait
    function waitclose(obj)
        bar=obj.bar;
        waitbar(1,bar);
        pause(0.5);
        close(bar);
    end
    
    % update waitbar
    function update(obj)
        
        if(obj.aborted)
            set(obj.infotext,'String','Stopping execution ...');
            error('Aborted!');
        end
        
        bar=obj.bar;
        timeTable=obj.timeTable;
        timeRest=timeTable.timeRest;
        timeWait=timeTable.timeWait;
        timeDone=timeTable.timeDone;
        numImages=timeTable.numImages;
        
        num=numImages-size(timeRest,2)+1;
        numStr=['Please wait... Image: ' ,num2str(num),'/',num2str(numImages)];
        
        time=toc(obj.ticID);
        if(time>0.99*timeRest(1))
            Vn=((timeRest(1)*(1-timeDone))/sum(timeRest))*0.99;
            timeWait=timeDone+Vn;
            waitbar(timeWait,bar,numStr);
        else
            Vn=(time*(1-timeDone))/sum(timeRest);
            timeWait=timeDone+Vn;
            waitbar(timeWait,bar,numStr);
        end

        timeTable.timeRest=timeRest;
        timeTable.timeWait=timeWait;
        timeTable.timeDone=timeDone;
        obj.timeTable=timeTable;

    end

    % update waitbar to 100% 
    function updatefull(obj)
        bar=obj.bar;
        timeTable=obj.timeTable;
        timeRest=timeTable.timeRest;
        timeWait=timeTable.timeWait;
        timeDone=timeTable.timeDone;

        time=toc(obj.ticID);
        
        Vn=((timeRest(1)*(1-timeDone))/sum(timeRest))*0.99;
        timeWait=timeDone+Vn;
        waitbar(timeWait,bar);

        timeTable.timeRest=timeRest;
        timeTable.timeWait=timeWait;
        timeTable.timeDone=timeDone;
        obj.timeTable=timeTable;
    end
    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
  end
end


