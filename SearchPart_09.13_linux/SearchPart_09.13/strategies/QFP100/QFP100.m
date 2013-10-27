%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [position3,StrName]=QFP100(image,scaleFactorIn,bar,SearchPartLibrary)

    % scale image to improve time for search
    scale_factor_zoom=18.5074/scaleFactorIn;                              
    bar.update();
    % correct image rotation
    [Ir,~]=SearchPartLibrary.rotCorrection(image);                  
    % use PCA to detect QFP100       
    [mapH]=searchPCAQFP100(Ir,scale_factor_zoom,bar); 
    [mapV]=searchPCAQFP100(imrotate(Ir,90),scale_factor_zoom,bar);  
    bar.update();

    % tolerance for cutting the part
    tol=[0,0];
    % get parts from horizontal and vertical map
    %[parts,position1,valueOut]=getMaxMaskQFP(Ir,scale_factor_zoom,mapH,mapV,5,15,tol,[0,10000000]); 
    [parts,position1,valueOut]=getMaxMaskQFP(Ir,scale_factor_zoom,mapH,mapV,5,15,tol,[0,5000000]);
    bar.update();
    
    % filter parts
    [Wout,position2]=filtparts(parts,position1);                            
    bar.update();
    % extract characters on chip
    %[output1,output2]=getTextData(Wout,SearchPartLibrary);                                   
    [output1,output2]=getText1(Wout,bar);   
    bar.update();
    
    % search partnames in the list of all parts
    [err1,StrName1]=searchWord(output1,bar,SearchPartLibrary);
    [err2,StrName2]=searchWord(output2,bar,SearchPartLibrary);
    bar.update();
    % get strings with less errors
    [StrName,position3]=getBestMatch(err1,StrName1,err2,StrName2,position2);   
    bar.update();

end

