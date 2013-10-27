%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [positionOut,value]=SMDResistor(I,scaleFactor1,bar,SearchPartLibrary)
    
    scaleFactor=18.5074/scaleFactor1;
    load('ResistorSMDData/mask')        %load ResistorSMD mask
    bar.update();   
    
    Ir=SearchPartLibrary.rotCorrection(I);  % corrects the Image if it is rotated
    bar.update();
    
    [mapH,mapV]=getResistor1206(Ir,scaleFactor,bar);    % get horizontal and vertical map of SMD resistors
    bar.update();

    maskpos=5; numparts=100; tol=[0.2,0.2]; treshold=[0.1,10];          % parameter of getMaxMask        
    
    [parts,position1,valueOut]=getMaxMaskSMD(Ir,scaleFactor,mapH,mapV,maskpos,numparts,tol,treshold);   % get parts from horizontal and vertical map

    bar.update();
    [Wout1,position2]=getTextSMD(parts,position1,bar);
    
    [Class,positionOut]=classnet(Wout1,position2);                      % classifies the numnbers with neuronal net (OCR for numbers from 0 to 9)
    bar.update();
    [value]=Resistorcode(Class);                                         % transforms numbers on resisitor to value

end