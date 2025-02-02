%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sd]=PCAG(X,Xg,meanR,meanRg,meanNR,meanNRg,R,Rg,NRg,NR)

%disp(2);
%X=double(reshape(W,size(W,1)*size(W,2),1));
%Xg=double(reshape(Wg,size(Wg,1)*size(Wg,2),1));
X=single(X);
Xg=single(Xg);

r_gp=Rg*(Xg-meanRg*ones(1,size(X,2)))+meanRg*ones(1,size(X,2));
r_ep=R*(X-meanR*ones(1,size(X,2)))+meanR*ones(1,size(X,2));
r_gn=NRg*(Xg-meanNRg*ones(1,size(X,2)))+meanNRg*ones(1,size(X,2));
r_en=NR*(X-meanNR*ones(1,size(X,2)))+meanNR*ones(1,size(X,2));

d_gp=abs(r_gp-Xg);
d_ep=abs(r_ep-X);
d_gn=abs(r_gn-Xg);
d_en=abs(r_en-X);

%calculate error value

%d=d_gn+d_en-d_gp-d_ep;

dg=d_gn-d_gp;
de=d_en-d_ep;
sd=sum(dg)+sum(de);

end