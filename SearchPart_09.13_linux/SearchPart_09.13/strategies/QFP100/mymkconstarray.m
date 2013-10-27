%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = mymkconstarray(class, value, size)
%MKCONSTARRAY creates a constant array of a specified numeric class.
%   A = MKCONSTARRAY(CLASS, VALUE, SIZE) creates a constant array 
%   of value VALUE and of size SIZE.

%   Copyright 1993-2003 The MathWorks, Inc.  
%   $Revision: 1.8.4.1 $  $Date: 2003/01/26 06:00:35 $

out = repmat(feval(class, value), size);
