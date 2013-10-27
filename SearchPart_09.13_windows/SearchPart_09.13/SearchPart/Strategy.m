%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Strategy
  %TARGET Class for representing a target
  %   A target class knows its angle, signal and range

  % Copyright 2008 The MathWorks, Inc.

   properties
      time=0;           % time the strategy needs to find all parts of a component of an image
  end

  methods
      
%Constructor
    function newStrategy = Strategy(varargin)           
        newStrategy.time=varargin{2};               
    end

%Setter methods
     function obj = set.time(obj,varargin)                      % set time to search
        if(isnumeric(varargin{1}))
            obj.time=varargin{1};
        else
            error('Error: Passed time is not a number!')
        end
     end
     
     
%Getter methods   
    function time = get.time(obj)                               % get time to search
        time = obj.time;              
    end

     
  end
  
  
  methods
      % execute the strategy of the component
      function [position, value]=executeAlgo(obj,image,scaleFactor,bar,SearchPartLibrary) 
        position=[];
        value=[];
      end;
  end
    
end

