%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mapH]=searchPCAQFP100(I,scale_factor_zoom,bar)

load ('QFP100Data/PCAQFP');
bar.update();

% scale factors for two state recognition
searchScale1=0.03;              % scale factor for first recognition step (lower resolution than in second step)
searchScale2=0.06;              % scale factor for second recognition step (higher resolution than in second step)

bar.update();


Ir=imresize(I,scale_factor_zoom);             % resize image to reduce time for first step
Ic1=imresize(Ir,searchScale1);
Ip=imageprocessing(Ir);                 % use gauss filter to detect edges
Ip1=imresize(Ip,searchScale1);               % resize image for first step search


% resize image depending on scale factor of the image
% Ir=imresize(I,scale_factor_zoom);       % resize image for first stage recognition
% Ip=imageprocessing(Ir);
% % resize for size of PCA-iamges
% Ip1=imresize(Ip,0.0720);
% Ic1=imresize(Ir,0.0720);
% Ip1=imrotate(Ip1,90);
% Ic1=imrotate(Ic1,90);

% first step recognitione in edge-image
funIp1 = @(block) (PCADIP1_Ip(block,MeanPosEdge1,MeanNegEdge1,MPosEdge1,MNegEdge1)); 
mapH1P = colfilt(Ip1,[14 11],[20,20],'sliding',funIp1);
bar.update();

% first step recognitione in color-image
funIc1 = @(block) (PCADIP1_Ic(block,MeanPosColor1,MeanNegColor1,MPosColor1,MNegColor1));
mapH1G = colfiltDIP1c(Ic1,[14 11],[20,20],'sliding',funIc1);
bar.update();
mapH1=mapH1P+mapH1G;

% resize for size of PCA-iamges
% Ip2=imresize(Ip,0.1216);
% Ic2=imresize(Ir,0.1216);

Ir=imresize(I,scale_factor_zoom);                     % resize image to reduce time for second step
Ic2=imresize(Ir,searchScale2);
Ip=imageprocessing(Ir);
Ip2=imresize(Ip,searchScale2);


% dilate map from first step recognition for second step recognition
mapH1=imresize(mapH1,size(Ip2));
mapH1(mapH1<0)=0;
se = strel('rectangle',[2 2]);
mapH1 = imdilate(mapH1,se);
mapH1(mapH1>0)=1;
bar.update();

% second step recognitione in edge-image and color-image
fun2 = @(block1,block2) (PCAG(block1,block2,MeanPosEdge2,MeanPosColor2,MeanNegEdge2,MeanNegColor2,MPosEdge2,MPosColor2,MNegColor2,MNegEdge2)); 
[mapH] = colfiltQFP2(Ip2,[28 22],[50,50],'sliding',fun2,mapH1,Ic2);
mapH(mapH<0)=0;



