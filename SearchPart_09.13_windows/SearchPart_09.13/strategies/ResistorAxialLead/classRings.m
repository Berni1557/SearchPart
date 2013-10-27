%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ClassRes]=classRings(rings)

    loadNet=true;

    X=[];                                   %  take all rings and put them in X
    for i=1:size(rings,2)
        for j=1:size(rings{i},2)
            X{end+1}=rings{i}{j};
        end
    end


    if (loadNet==true)                      % if loadNet is true the Neural networ is loaded and traind by the data in trainData
        load('ResistorG1Data/net','net','maxX')

    else
        load ('ResistorG1Data/trainData');      % load traindata data
        Xt=[];
        Yt=[];
        for i=1:size(RingClass,1)
            R1=RingData1{i};
            R2=reshape(R1,size(R1,1)*size(R1,2),3);
            sigma=cov(double(R2));              % calculate standard deviation
            mu=mean(R2,1);                      % calculate mean
            if(RingClass(i)~=0)
                Xt=[Xt;mu,sigma(1,1),sigma(1,2),sigma(1,3),sigma(2,2),sigma(2,3),sigma(3,3)];       % attributes are 9 parameters with std (6) and mean (3)
                Yt=[Yt,RingClass(i)];
            end
        end
        maxX=max(Xt(:));
        X1=Xt./maxX;
        Y1=zeros(size(Yt,2),12);
        for i=1:size(Yt,2)
            Y1(i,Yt(i))=1;
        end
        net = newff(X1',Y1',25);                % create feedforward network with 25 hidden neurons
        net=train(net,X1',Y1');                 % train neural network
    end

    Xc=[];
    for i=1:size(X,2)
        R=X{i};
        R1=reshape(R,size(R,1)*size(R,2),3);
        sigma=cov(double(R1));                  % calculate standard deviation
        mu=mean(R1,1);                          % calculate mean
        Xc=[Xc;mu,sigma(1,1),sigma(1,2),sigma(1,3),sigma(2,2),sigma(2,3),sigma(3,3)];        % attributes are 9 parameters with std (6) and mean (3)
    end           
    Xc=Xc./maxX;                                % normalize the data
    if (size(Xc,2)>0)
        Yout=sim(net,Xc');                      % classify data by neural network
    else
        Yout=[];
    end

    [~,p]=max(Yout);                            % get maximum value of data
    Y=[];
    for i=1:size(p,2)
        Y{i}=num2str(p(i));
    end


    k=0;
    ClassRes=[];
    for im=1:size(rings,2)
        ClassRes{im}=[];
        for r=1:size(rings{im},2)
            k=k+1;
            ClassRes{im}(r)=str2num(Y{k});          % sort the class of the rings to the resistor assin
        end
    end


end