%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Component < handle
  %TARGET Class for representing a target
  %   A target class knows its angle, signal and range

  % Copyright 2008 The MathWorks, Inc.

  properties
      name;
      active=false;         %active=false if component was not searched yet
      strategy;             %strategy object wihich defines the search strategy
      ComponentID;
      hasDatasheet=false;
      partList=[];
      numParts=0;
      ImageName='';     
  end

  methods
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Constructor
   function newComponent = Component(varargin)
      
        newComponent.ComponentID=varargin{2};
        newComponent.strategy=varargin{4};
        newComponent.name=varargin{6};
        if(varargin{8})
            newComponent.hasDatasheet=varargin{8};
        end

    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setter methods
     
     function set.name(obj,name)                            % set component name
        if(ischar(name))
            obj.name=name;
        else
            error('Error: Passed name is not a string!')
        end
     end
     
     function set.ImageName(obj,ImageName)                  % set image name
        if(ischar(ImageName))
            obj.ImageName=ImageName;
        else
            error('Error: Passed name is not a string!')
        end
     end
     
     function set.numParts(obj,numParts)                    % set number of parts name
        if(isnumeric(numParts))
            obj.numParts=numParts;
        else
            error('Error: Passed name is not a string!')
        end
     end
     
     function set.active(obj,active)                        % set active if component od session was searched
        if(islogical(active))
            obj.active=active;
        else
            error('Error: Passed Activitistate is not logical!')
        end
     end
     
     function set.hasDatasheet(obj,hasDatasheet)            % set hasDatasheet to true if datasheet exists on www.alldatasheet.com
        if(islogical(hasDatasheet))
            obj.hasDatasheet=hasDatasheet;
        else
            error('Error: Passed Datasheetstate is not logical!')
        end
     end     
     
     function set.strategy(obj,strategy)                    % set strategy of component
        superClass=superclasses(strategy);
        if(strcmp(superClass{1},'Strategy'))
            obj.strategy=strategy;
        else
            error('Error: Passed strategy is not a Strategy!')
        end
     end
     
     function set.ComponentID(obj,ComponentID)              % set ComponentID of component
        if(isnumeric(ComponentID))
            obj.ComponentID=ComponentID;
        else
            error('Error: Passed ComponentID is not a numeric!')
        end
     end
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Getter methods

    function partList = get.partList(obj)       % get List of all parts of component
        partList = obj.partList;              
    end
    
    function numParts = get.numParts(obj)       % get Number of parts of component
        numParts = obj.numParts;              
    end
    
    function name = get.name(obj)               % get name of component
        name = obj.name;             
    end
    
    function hasDatasheet = get.hasDatasheet(obj)   % get hasDatasheet
        hasDatasheet = obj.hasDatasheet;             
    end
    
    function ImageName = get.ImageName(obj)     % get name of the Image of the component
        ImageName = obj.ImageName;             
    end

    function active = get.active(obj)           % get active, active is true, if component was search in session
        active = obj.active;             
    end
    
    function strategy = get.strategy(obj)       % get strategy of component
        strategy = obj.strategy;             
    end

    function ComponentID = get.ComponentID(obj) % get ComponentID of component (see ID-List for more information)
        ComponentID = obj.ComponentID;             
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %execute Strategy on component
    function executeStrategy(obj,image,scaleFactor,bar,SearchPartLibrary)
        if (~strcmp(class(image),'uint8')) 
            error('Error: Passed value is not an image!')
        end
        if(obj.active==false)            
            [positionT, valueT]=obj.strategy.executeAlgo(image,scaleFactor,bar,SearchPartLibrary);
            if(size(positionT,1)==size(valueT,2))
                for i=1:size(positionT,1)
                    part=Part((obj.numParts)+1,obj.ComponentID,positionT(i,:),valueT{i},obj.ImageName,obj.hasDatasheet);
                    obj.addPart(part);
                    %obj.active=true;
                end
            else
                error('Error: Passed Value and Position have not the same size!')
            end
            obj.active=true;
        else
            disp('Component-information already exist!')
        end
        
    end
    
    %add a new Part to component
    function addPart(obj,part)
        if(strcmp(class(part),'Part'))
            obj.partList{end+1}=part;
            obj.numParts=obj.numParts+1;
        end
    end
    
    % get part by partID of the component
    function part=getPart(obj,partID)
        for i=1:obj.numParts
            if(obj.partList{i}.partID==partID)
                part=obj.partList{i};
            end
        end
    end
     

         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  end
end

