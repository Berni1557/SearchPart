%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sd]=PCA(W,Wg,meanR,meanRg,meanNR,meanNRg,R,Rg,NRg,NR)

%W=imresize(W,0.5);
%Wg=imresize(Wg,0.5);

X=double(reshape(W,size(W,1)*size(W,2),1));
Xg=double(reshape(Wg,size(Wg,1)*size(Wg,2)*3,1));


r_gp=Rg*(Xg-meanRg)+meanRg;
r_ep=R*(X-meanR)+meanR;
%r_ep=P1*(X-meanR)+meanR;

r_gn=NRg*(Xg-meanNRg)+meanNRg;
r_en=NR*(X-meanNR)+meanNR;

d_gp=abs(r_gp-Xg);
d_ep=abs(r_ep-X);
%sd=sum(d_gp);
d_gn=abs(r_gn-Xg);
d_en=abs(r_en-X);


%d=d_gn+d_en-d_gp-d_ep;
%d=d_en-d_ep;
%d=d_gn-d_gp;
sd=sum(d_gn)+sum(d_en)-sum(d_gp)-sum(d_ep);
%Wn=reshape(r_gp,size(W,1),size(W,2));
%Wn=uint8(Wn-min(Wn(:)));

end



