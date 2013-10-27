%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Wout2]=reduceReflexion(Wcut2)
Pmax=220;                           % threshold for reflexion in gray image
Wout2=[];
for i=1:size(Wcut2,2)
    W=Wcut2{i};
    Wgray=rgb2gray(W);              % convert to gray scaled image
    Wreflex=W;
    pixmean=[];
    for l=1:size(W,2)
        k=0;                        % k is number of non reflexion pixel for each column
        pixtemp=[0,0,0];
        for m=1:size(W,1)
            if(Wgray(m,l)<Pmax)
                pixtemp=pixtemp+double(reshape(W(m,l,:),1,3));      % pixtemp is sum of all non reflexion pixel of a column
                k=k+1;
            end
        end
        if(k>10)
            pixmean(l,1:3)=pixtemp./k;                  % pixmean is the mean value of all non reflexion pixel of a column. If k smaller 10 pixmean is the mean of the column.
        else
            pt=double(mean(W(:,l,:),1));
            pixmean(l,1:3)=reshape(pt,1,3);
        end
    end
    for l=1:size(W,2)                                   % replace all reflexion pixelin the image by the pixmean value
        for m=1:size(W,1)
            if(Wgray(m,l)>Pmax)
                Wreflex(m,l,:)=reshape(pixmean(l,1:3),1,1,3);
            end
        end
    end

    W=[];
    W=cat(3,W,medfilt2(Wreflex(:,:,1),[4 4]));              % use median filter with 4x4 stecil to smooth image
    W=cat(3,W,medfilt2(Wreflex(:,:,2),[4 4]));
    W=cat(3,W,medfilt2(Wreflex(:,:,3),[4 4]));
    Wout2{i}=W(1:end-1,1:end-1,:);
end

