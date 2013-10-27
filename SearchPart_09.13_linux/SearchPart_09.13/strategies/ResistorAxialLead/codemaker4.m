%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [value,tolerance,codeName,isr]=codemaker4(code)
%Inputs:
%code is an array of 4 entrys with the number of color
%
%Outputs:
%tolerance is the tolerance of the Resistors
%value is the Value of the Resistors
%codeName is an array of 4 or 5 entrys with the name of color
%isr is true if Resistorvalue is right
%
colorName={'black','brown','red','orange','yellow','green','blue','purple','grey','white','gold','silver'};
%output value: value=1000
isr=true;
value=0;
tolerance=0;
codetemp=[];

    if(code(1)==11 || code(1)==12)              % sord color by the silver or gold ring
        codetemp(1)=code(4);
        codetemp(2)=code(3);
        codetemp(3)=code(2);
        codetemp(4)=code(1);
        code=codetemp;
    end
    
    for i=1:3
        if(code(i)==11)
            isr=false;                          % if last ring is not golden or silver, part is not a resistor and isr is false
        end
    end
    
    codeName=[colorName{code(1)},', ',colorName{code(2)},', ',colorName{code(3)},', ',colorName{code(4)}];
    
    switch code(1)                              % get value of first ring
        
        case 1
            value=value+0;     
        case 2
            value=value+10;
        case 3
            value=value+20;
        case 4
            value=value+30;
        case 5
            value=value+40;
        case 6
            value=value+50;
        case 7
            value=value+60;
        case 8
            value=value+70;
        case 9
            value=value+80;
        case 10
            value=value+90;
        otherwise
            isr=false;
    end
    switch code(2)                          % get value of second ring
        case 1
            value=value+0;
        case 2
            value=value+1;
        case 3
            value=value+2;
        case 4
            value=value+3;
        case 5
            value=value+4;
        case 6
            value=value+5;
        case 7
            value=value+6;
        case 8
            value=value+7;
        case 9
            value=value+8;
        case 10
            value=value+9;
        otherwise
            isr=false;
    end
    switch code(3)                      % get value of third ring
        case 1
            value=value*1;
        case 2
            value=value*10;
        case 3
            value=value*100;
        case 4
            value=value*1000;
        case 5
            value=value*10000;
        case 6
            value=value*100000;
        case 7
            value=value*1000000;
        case 8
            value=value+0.1;
        case 9
            value=value+0.01;
        otherwise
            isr=false;
    end
    switch code(4)                      % get value of fourth ring
        case 11
            tolerance=5;
        case 12
            tolerance=10;
        otherwise
            isr=false;
    end
    if(value==0)
        isr=false;
    end
end