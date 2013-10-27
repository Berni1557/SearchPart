%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [backColor1]=PWDModel(Win)
% calculate the backround pixel of the resistor

backColor1=[];
Wout=[];
for im=1:size(Win,2)
    W1=Win{im};
    W2=imresize(W1,[6,90]);
    W3=reshape(W2,1,size(W2,1)*size(W2,2),3);

    M=double(reshape(W3,size(W3,2),3)');
    d = pdist(M');
    distance = squareform(d);                   % calculate distance between all pixel
    
    sumd=sum(distance);                         % sum distances for each pixel
    [a,b]=min(sumd);                            % pixel with smallest distanc to all pixel is the main backround pixel
    P=M(:,b);
    I=uint8(reshape(P,1,1,3));
    
    I1=imresize(I,[100,100]);

    Wout{end+1}=W1;
    
    Prop=zeros(size(W1,1),size(W1,2));
    Px=P*ones(1,size(W1,2));
    X=mean(W1,1);
    X1=reshape(X,size(X,2),3);
    D=X1-Px';                                   % get distance fromall pixel to main backround pixel
    Prop=(D)*(D)';
    
    m1=diag(Prop);
    m2=-m1+max(m1);                             % calculate sum of distances for each line
    %m3 = filtfilt(b,a,m2);
    backColor1{im}=[];
    numC=80*(size(W1,2)/171);
    for i=1:numC                                  % get 20 colums with the smallest distance to the main backround pixel
        [~,b]=max(m2);
        B=W1(:,b,:);
        backColor1{im}=cat(2,backColor1{im},B);     % marge backround pixel
        m2(b)=0;
    end
    
end
