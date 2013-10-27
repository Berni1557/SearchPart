%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [StrName,positionOut]=getBestMatch(err1,StrName1,err2,StrName2,positionIn)

StrNameTemp1=[];
StrNameTemp2=[];
positionOut=[];        
% find  best part name of StrName1 by checking the error
for i=1:size(StrName1,2)                            
    errmin1{i}=1000;
    StrNameTemp1{i}=[];
    for j=1:size(StrName1{i},2)                     
        for e=1:size(err1{i}{j},2)
            if(err1{i}{j}{e}<=errmin1{i})
                errmin1{i}=err1{i}{j}{e};
                StrNameTemp1{i}=StrName1{i}{j}{e};
            end
        end
    end
end

% find  best part name of StrName2 by checking the error
for i=1:size(StrName2,2)                            
    StrNameTemp2{i}=[];
    errmin2{i}=1000;
    for j=1:size(StrName2{i},2)  
        for e=1:size(err2{i}{j},2)
            if(err2{i}{j}{e}<=errmin2{i})
                errmin2{i}=err2{i}{j}{e};
                StrNameTemp2{i}=StrName2{i}{j}{e};
            end
        end     
    end
end


StrName=[];
% check if strings are empty
if(isempty(StrNameTemp1) && isempty(StrNameTemp2))          
    StrName=[];
% check if StrNameTemp1 is empty and StrNameTemp2 is not empty
elseif(isempty(StrNameTemp1) && ~isempty(StrNameTemp2))
    for i=1:size(StrNameTemp2,2)
        if(~isempty(StrNameTemp2{i}))
            StrName{end+1}=StrNameTemp2{i};
            positionOut(end+1,:)=positionIn(i,:);
        end
    end
% check if StrNameTemp is not empty and StrNameTemp2 is empty        
elseif(~isempty(StrNameTemp1) && isempty(StrNameTemp2))
    for i=1:size(StrNameTemp1,2)
        if(~isempty(StrNameTemp1{i}))
            StrName{end+1}=StrNameTemp1{i};
            positionOut(end+1,:)=positionIn(i,:);
        end
    end
else
    % get maximum number of parts
    if(size(StrNameTemp1,2)>size(StrNameTemp2,2))
        num=size(StrNameTemp1,2);
    else
        num=size(StrNameTemp2,2);
    end
    StrName=[];
    % check error between not rotated and rotated part names
    for i=1:num          
        if((~isempty(StrNameTemp1{i})) && (~isempty(StrNameTemp2{i})))
            % compare errors
            if(errmin1{i}>errmin2{i})
                StrName{end+1}=StrNameTemp2{i};
                positionOut(end+1,:)=positionIn(i,:);
            elseif(errmin1{i}==errmin2{i})
                if(size(StrNameTemp2{i},2)>size(StrNameTemp1{i},2))
                    StrName{end+1}=StrNameTemp2{i};
                    positionOut(end+1,:)=positionIn(i,:);
                else
                    StrName{end+1}=StrNameTemp1{i};
                    positionOut(end+1,:)=positionIn(i,:);
                end
            else
                StrName{end+1}=StrNameTemp1{i};
                positionOut(end+1,:)=positionIn(i,:);
            end
        elseif((isempty(StrNameTemp1{i})) && (~isempty(StrNameTemp2{i})))
            StrName{end+1}=StrNameTemp2{i};
            positionOut(end+1,:)=positionIn(i,:);
        elseif((~isempty(StrNameTemp1{i})) && (isempty(StrNameTemp2{i})))
            StrName{end+1}=StrNameTemp1{i};
            positionOut(end+1,:)=positionIn(i,:);
        end
    end
end
            

end







