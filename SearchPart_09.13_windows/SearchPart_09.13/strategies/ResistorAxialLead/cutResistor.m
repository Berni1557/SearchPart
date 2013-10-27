%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Wcut1,Wcut2]=cut1Resistor1(parts)
% cur parts margin for recognition Wcut1 cuts smaller for backround recognition, Wcut2 for further processing

Wcut1=[];
Wcut2=[];

[Wcut1,Wcut2]= cellfun(@(p) (cut(p)),parts,'UniformOutput', false);

end

function [Wc1,Wc2]=cut(W)

    W1=size(W,1);
    W2=size(W,2);
    
    % calculate margin for Wcut1
    c1=round(25*(W1/61));      
    c2=round(15*(W1/61));
    c3=round(70*(W2/221));
    c4=round(70*(W2/221));
    
    % calculate margin for Wcut2
    d1=round(25*(W1/61));
    d2=round(15*(W1/61));
    d3=round(25*(W2/221));
    d4=round(25*(W2/221));

    Wc1=W(c1:W1-c2,c3:W2-c4,:);
    Wc2=W(d1:W1-d2,d3:W2-d4,:);
end
