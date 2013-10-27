%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mapH,searchScale2]=searchPCAResistor(I,scale_factor_zoom,bar)
tic
load ('ResistorG1Data/PCA');

MeanPosEdge2=single(MeanPosEdge2);
MeanPosGray2=single(MeanPosGray2);
MeanNegEdge2=single(MeanNegEdge2);
MeanNegGray2=single(MeanNegGray2);
MPosEdge2=single(MPosEdge2);
MPosGray2=single(MPosGray2);
MNegGray2=single(MNegGray2);
MNegEdge2=single(MNegEdge2);

searchScale1=0.12;                  % scale factor for first stage recognition
searchScale2=0.21;                   % scale factor for second stage recognition

Ir1=imresize(I,scale_factor_zoom);       % resize image for first stage recognition
Ip1=imageprocessing(Ir1);
Ip1=imresize(Ip1,searchScale1);

Ir1=imresize(Ir1,searchScale1);
Ig1=rgb2gray(Ir1);
Ig1 = imadjust(Ig1);

bar.update();

funIp1 = @(block,q) (PCAG1_Ip(block,MeanPosEdge1,MeanNegEdge1,MPosEdge1,MNegEdge1)); 
funIg1 = @(block) (PCAG1_Ip(block,MeanPosGray1,MeanNegGray1,MPosGray1,MNegGray1)); 

%s=max(size(Ip1));
mapH1P = colfilt(Ip1,[7 25],[100,100],'sliding',funIp1);
bar.update();
mapH1G = colfilt(Ig1,[7 25],[100,100],'sliding',funIg1);
mapH1=mapH1P+mapH1G;


bar.update();
Ir2=imresize(I,scale_factor_zoom);
Ip2=imageprocessing(Ir2);
Ip2=imresize(Ip2,searchScale2);

Ir2=imresize(Ir2,searchScale2);
Ig2=rgb2gray(Ir2);
Ig2 = imadjust(Ig2);



mapH1=imresize(mapH1,size(Ip2));
mapH1(mapH1<0)=0;
se = strel('rectangle',[2 2]);
mapH1 = imdilate(mapH1,se);
mapH1(mapH1>0)=1;
bar.update();

fun2 = @(block1,block2) (PCAG(block1,block2,MeanPosEdge2,MeanPosGray2,MeanNegEdge2,MeanNegGray2,MPosEdge2,MPosGray2,MNegGray2,MNegEdge2)); 

T=mapH1;

[mapH] = mycolfilt(Ip2,[12 44],[100,100],'sliding',fun2,T,Ig2);
h = fspecial('average',2);
mapH=imfilter(mapH,h,'replicate');
mapH(mapH<0)=0;

bar.update();

