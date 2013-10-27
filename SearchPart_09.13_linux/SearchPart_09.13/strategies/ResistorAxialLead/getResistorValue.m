%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [valueOut,codeOut,positionOut]=getResistorValue(ClassRes,positionIn,scale_factor_zoom)

colorName={'black','brown','red','orange','yellow','green','blue','purple','grey','white','gold','silver'}; % colors of resistor rings
valueOut=[];
codeOut=[];
positionOut=[];
%Wend=[];
for im=1:size(ClassRes,2)
    code=ClassRes{im};
    if(size(code,2)==4)
        [value,tolerance,codeName,isr]=codemaker4(code);        % get resistor value of risistors with 4 rings
    else
        [value,tolerance,codeName,isr]=codemaker5(code);        % get resistor value of risistors with 5 rings
    end
    if(isr)                                                     % ckeck if combination of ring colors is possible
        valueOut{end+1}=value;
        codeOut{1,end+1}=codeName;
        codeOut{2,end}=im;
        positionOut=[positionOut;positionIn(im,1:2)];           % update positions
    end
end