%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Class,position3]=classnet(Wout1,position2)

Class=[];
load('ResistorSMDData/net')
position3=[];
for im=1:size(Wout1,2)
    R=Wout1{im};

    % not rotate
    X=[];
    for i=1:size(R,2)
        W1=R{i};
        W2=imresize(W1,[30,15]);
        W4=reshape(W2,450,1);
        X=[X,W4];
    end
    Y1=sim(net,X);

    % rotate
    X=[];
    for i=1:size(R,2)
        W1=R{i};
        W1=imrotate(W1,180);
        W2=imresize(W1,[30,15]);
        W4=reshape(W2,450,1);
        X=[X,W4];
    end
    Y2=sim(net,X);

    [maxC1,Class1]=max(Y1);
    [maxC2,Class2]=max(Y2);
    Class1=Class1-1;
    Class2=Class2-1;
    
    if(sum(maxC1)>sum(maxC2))
        Class{end+1}=Class1;
        position3(end+1,:)=position2(im,:);
    else
        Class2=Class2(end:-1:1);
        Class{end+1}=Class2;
        position3(end+1,:)=position2(im,:);
    end
    
end

end



