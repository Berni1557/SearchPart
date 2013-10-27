%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [position,code]=ResistorAxialLead(image,scaleFactor,bar,SearchPartLibrary)

        [Ir,~]=SearchPartLibrary.rotCorrection(image);          % rotate image
        code=[];
        scale_factor_zoom=19.5480/scaleFactor;                  % scale image for algorithm
        bar.update();
        [mapH,searchScale]=searchPCAResistor(Ir,scale_factor_zoom,bar);    % use PCa to search to get horizontal and vertical map
        [mapV,searchScale]=searchPCAResistor(imrotate(Ir,90),scale_factor_zoom,bar);
        bar.update();
        
        [parts,position1,valueOut]=getMaxMask(Ir,scale_factor_zoom,mapH,mapV,5,50,[0.0,0.0],[0,10000000]);       % get parts from horizontal and vertical map
        bar.update();
        
        [Wcut1,Wcut2]=cutResistor(parts);           % cur parts margin for recognition Wcut1 cuts smaller for backround recognition, Wcut2 for further processing
        bar.update();
        [Wout1]=reduceReflexion(Wcut1);                % reduce reflexion of Wcut1
        [Wout2]=reduceReflexion(Wcut2);                % reduce reflexion of Wcut2
        
        bar.update();
        [backColor]=PWDModel(Wout1);                    % get backround pixel
        [rings,Wout3,position2]=classNormRing(Wout2,position1,backColor);          % extract rings of resistor
        bar.update();
        [ClassRes]=classRings(rings);                  % classify rings
        bar.update();
        [valueOut,codeOut,position]=getResistorValue(ClassRes,position2,scale_factor_zoom);     % calculate resistor value of ringvalue
        for i=1:size(valueOut,2)
            code{i}=num2str(valueOut{i});
        end

end
