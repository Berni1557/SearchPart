%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Part < handle
  %TARGET Class for representing a target
  %   A target class knows its angle, signal and range

  % Copyright 2008 The MathWorks, Inc.

  properties
      ComponentID;          % ID of the Component of the part ex.: 3
      ImageName;
      blank;                % if part exist blank=false else blank=true
      position=[];          % position of the part ex.:[1200, 1530]
      value=[];             % value of the part (string) ex.: 'GD74LS00'
      PartID;               % ID of the part in Component of the Image ex.: 45
      hasDatasheet=false;   % hasDatasheet is true if datasheet exists on www.alldatasheet.com
  end

  methods
      

%Constructor
   function newPart = Part(newPartID,newComponentID,newposition,newvalue,newImageName,newhasDatasheet)
        newPart.PartID=newPartID;
        newPart.ComponentID=newComponentID;
        newPart.blank=false;
        newPart.value=newvalue;
        newPart.position=newposition;
        newPart.ImageName=newImageName;
        newPart.hasDatasheet=newhasDatasheet;
    end
    
%Setter methods

     function set.ImageName(obj,ImageName)                          % set ImageName of the part
        if(ischar(ImageName))
            obj.ImageName=ImageName;
        else
            error('Error: Passed ImageName is not correct!')
        end
     end
          
     function set.hasDatasheet(obj,hasDatasheet)                    % set hasDatasheet
        if(islogical(hasDatasheet))
            obj.hasDatasheet=hasDatasheet;
        else
            error('Error: Passed Datasheetstate is not logical!')
        end
     end     
     
     function set.position(obj,position)                            % set position of part
        if(size(position,2)==2 && size(position,1)==1 && isnumeric(position))
            obj.position=position;
        else
            error('Error: Passed Value is not correct!')
        end
     end

     function set.blank(obj,blank)                                  % set blank if part is not on 
        if(islogical(blank))
            obj.blank=blank;
        else
            error('Error: Passed blank is not correct!')
        end
     end
  
     
     function set.ComponentID(obj,ComponentID)                      % set ComponentID of component
        if(isnumeric(ComponentID))
            obj.ComponentID=ComponentID;
        else
            error('Error: Passed name is not a string!')
        end
     end
     
     function set.value(obj,value)                                  % set value of part
        if(ischar(value))
            obj.value=value;
        else
            error('Error: Passed Value is not consistent!')
        end
     end 

     function set.PartID(obj,PartID)                                % set part ID
        if(isnumeric(PartID))
            obj.PartID=PartID;
        else
            error('Error: Passed ComponentID is not a numeric!')
        end
     end
     
%Getter methods

    function ImageName = get.ImageName(obj)                         % get ImageName
        ImageName = obj.ImageName;              
    end
    
    function hasDatasheet = get.hasDatasheet(obj)                   % get hasDatasheet of part
        hasDatasheet = obj.hasDatasheet;             
    end
    
    function position = get.position(obj)                           % get position of part
        position = obj.position;              
    end
     
    function blank = get.blank(obj)                                 % get blank
        blank = obj.blank;              
    end
    
    function ComponentID = get.ComponentID(obj)                     % get ComponentID
        ComponentID = obj.ComponentID;             
    end
    
    function value = get.value(obj)                                 % get value of part
        value = obj.value;              
    end
     
    function PartID = get.PartID(obj)                               % get PartID of part
        PartID = obj.PartID;             
    end
    
    % download datasheet of www.alldatasheet.com
     function [stat]=downloadDatasheet(obj,fullpath)
        if (obj.hasDatasheet) 
            [stat]=datasheetarchive(obj.value,fullpath);
        else
            error('Error: Component has no Datasheet!')
        end
     end

     
  end
end

