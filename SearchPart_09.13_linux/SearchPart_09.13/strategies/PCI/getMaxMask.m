%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [parts,position,valueOut]=getMaxMask(I,map,mask,maskpos,numparts,tol,treshold)
%map and I have same size
%maskpos=1:9
%%%%%%%%%%%
% 1  2  3 %
% 4  5  6 %
% 7  8  9 %
%%%%%%%%%%%
%tol=[0.2,0.2];
%treshold=[0.5,0.7]
%
valueOut=[];
parts=[];
position=[];
for i=1:numparts
    outOfRange=false;
    [a,b,value]=maxM(map);
    
    if(value<treshold(1) || value> treshold(2))
        outOfRange=true;
    end
    
    [c,cm]=getPos(mask,maskpos,a,b,tol);
    
    if (c(1)<1)
        c(1)=1;
        outOfRange=true;
    end
    if(c(2)>size(I,1))
        c(2)=size(I,1);
        outOfRange=true;
    end
    if (c(3)<1)
        c(3)=1;
        outOfRange=true;
    end
    if(c(4)>size(I,2))
        c(4)=size(I,2);
        outOfRange=true;
    end
    

    
    if (cm(1)<1)
        cm(1)=1;
    end
    if(cm(2)>size(I,1))
        cm(2)=size(I,1);
    end
    if (cm(3)<1)
        cm(3)=1;
    end
    if(cm(4)>size(I,2))
        cm(4)=size(I,2);
    end
    

    if(outOfRange==false)
        W=I(c(1):c(2),c(3):c(4),:);
        parts{end+1}=W;
        valueOut(end+1)=value;
        pos1=round((c(1)+c(2))/2);
        pos2=round((c(3)+c(4))/2);
        position(end+1,1:2)=[round(pos2),round(pos1)];
    end   
    map(cm(1):cm(2),cm(3):cm(4))=zeros((cm(2)-cm(1))+1,(cm(4)-cm(3))+1); 

end


end





function [c,cm]=getPos(mask,maskpos,a,b,tol)
W1=size(mask,1);
W2=size(mask,2);
W1=round(W1*(1+tol(1)));
W2=round(W2*(1+tol(2)));
switch(maskpos)
    case 1
        p11=a;
        p12=a+W1;
        p21=b;
        p22=b+W2;
    
    case 2
        p11=round(a-W1/2);
        p12=round(a+W1/2);
        p21=b;
        p22=b+size(mask,2);    
        
    case 3        
        p11=round(a-W1);
        p12=round(a);
        p21=b;
        p22=b+W2;      
                
    case 4        
        p11=a;
        p12=a+W1;
        p21=round(b-W2/2);
        p22=round(b+W2/2);
    
    case 5        
        p11=round(a-W1/2);
        p12=round(a+W1/2);
        p21=round(b-W2/2);
        p22=round(b+W2/2);
    
    case 6        
        p11=round(a-W1);
        p12=a;
        p21=round(b-W2/2);
        p22=round(b+W2/2);
        
    case 7
        p11=a;
        p12=a+W2;
        p21=b-W2;
        p22=b;
    
    case 8
        p11=round(a-W1/2);
        p12=round(a+W1/2);
        p21=b-W2;
        p22=b;
    case 9
        p11=a-W1;
        p12=a;
        p21=b-W2;
        p22=b;
end   
c=[p11,p12,p21,p22];
        
cm(1)=round(a-W1);
cm(2)=round(a+W1);
cm(3)=round(b-W2);
cm(4)=round(b+W2);


end



