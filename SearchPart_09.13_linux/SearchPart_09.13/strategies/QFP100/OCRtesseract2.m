%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output1,output2]=OCRtesseract2(T,NumLinesOCR)

load('QFP100Data/net');
output1=[];
output2=[];
CC = bwconncomp(T,4);
blobs=regionprops(CC,'Image','Centroid');
cent=cat(1,blobs.Centroid);

if(~isempty(cent))
    X=cent(:,2);
    Z = linkage(X);
    class = cluster(Z,'maxclust',NumLinesOCR);
    for l=1:NumLinesOCR
        output1{l}=[];
            for n=1:CC.NumObjects
                if(class(n)==l)
                    I=blobs(n).Image;
                        W2=~imresize(I,[30,15]);
                        X=double(reshape(W2,size(W2,1)*size(W2,2),1));
                        [~,out] = max(sim(net,X));
                        if(out<=10);
                            out=num2str(out-1);
                        else
                            out=char(out+54);
                        end
                        
                    if(~isempty(out))
                        if(strcmp(out,'/') || strcmp(out,':'))
                            out{1}='!';
                        end
                        output1{l}=[output1{l},out];
                    else
                        output1{l}=[output1{l},'!'];
                    end
                end
            end
    end
end
Tes1=[];
for i=1:size(output1,2)
    Tes1=[Tes1,output1{i},'_'];
end
Tes1=Tes1(1:end-1);


T=imrotate(T,180);

CC = bwconncomp(T,4);
blobs=regionprops(CC,'Image','Centroid');
cent=cat(1,blobs.Centroid);
if(~isempty(cent))
    X=cent(:,2);
    Z = linkage(X);
    class = cluster(Z,'maxclust',NumLinesOCR);


    for l=1:NumLinesOCR
        output2{l}=[];
            for n=1:CC.NumObjects
                if(class(n)==l)
                    I=blobs(n).Image;
                        W2=~imresize(I,[30,15]);
                        X=double(reshape(W2,size(W2,1)*size(W2,2),1));
                        [~,out] = max(sim(net,X));
                        if(out<=10);
                            out=num2str(out-1);
                        else
                            out=char(out+54);
                        end

                    if(~isempty(out))
                        if(strcmp(out,'/') || strcmp(out,':'))
                            out{1}='!';
                        end
                        output2{l}=[output2{l},out];
                    else
                        output2{l}=[output2{l},'!'];
                    end
                end
            end
    end
end
Tes2=[];
for i=1:size(output2,2)
    Tes2=[Tes2,output2{i},'_'];
end
Tes2=Tes2(1:end-1);

end


