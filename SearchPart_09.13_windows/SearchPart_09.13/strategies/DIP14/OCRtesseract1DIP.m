%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output1,output2]=OCRtesseract1DIP(T,NumLinesOCR)

posChar1=setCharacter(T,NumLinesOCR);
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
        k=0;
            for n=1:CC.NumObjects
                if(class(n)==l)
                    k=k+1;
                    if(posChar1{l}(k)==1)
                        output1{l}=[output1{l},'!'];
                    end
                    I=blobs(n).Image;
                    I1=imresize(I,[70,40]);
                    M=zeros(80,60);
                    M(6:75,6:45)=I1;
                    imwrite(M,'Mes.png','png');
                    system('tesseract Mes.png out -l eng -psm 10');    
                    out=textread('out.txt','%s');

                    if(~isempty(out))
                        if(strcmp(out,'/') || strcmp(out,':') || strcmp(out,'.'))
                            out{1}='!';
                        end
                        output1{l}=[output1{l},out{1}];
                    else
                        output1{l}=[output1{l},'!'];
                    end

                end
            end
            
    end
end

T=imrotate(T,180);
posChar2=setCharacter(T,NumLinesOCR);

CC = bwconncomp(T,4);
blobs=regionprops(CC,'Image','Centroid');
cent=cat(1,blobs.Centroid);
if(~isempty(cent))
    X=cent(:,2);
    Z = linkage(X);
    class = cluster(Z,'maxclust',NumLinesOCR);


    for l=1:NumLinesOCR
        output2{l}=[];
        k=0;
            for n=1:CC.NumObjects
                if(class(n)==l)
                    k=k+1;
                    if(posChar2{l}(k)==1)
                        output2{l}=[output2{l},'!'];
                    end
                    I=blobs(n).Image;
                    I1=imresize(I,[70,40]);
                    M=zeros(80,60);
                    M(6:75,6:45)=I1;
                    imwrite(M,'Mes.png','png');
                    system('tesseract Mes.png out -l eng -psm 10');            
                    out=textread('out.txt','%s');
                    if(~isempty(out))
                        if(strcmp(out,'/') || strcmp(out,':') || strcmp(out,'.'))
                            out{1}='!';
                        end
                        output2{l}=[output2{l},out{1}];
                    else
                        output2{l}=[output2{l},'!'];
                    end
                end
            end
    end
end

delete('Mes.png');
delete('out.txt');
end

function posChar=setCharacter(T,NumLinesOCR)
CC = bwconncomp(T,4);
blobs=regionprops(CC,'Centroid','BoundingBox');
b=cat(1,blobs.BoundingBox);
cent=cat(1,blobs.Centroid);
posChar=[];
if(~isempty(cent))
    X=cent(:,2);
    Z = linkage(X);
    class = cluster(Z,'maxclust',NumLinesOCR);
    for l=1:NumLinesOCR
        posChar{l}=[];
        cline=[];
        for n=1:CC.NumObjects
            if(class(n)==l)
                cline(end+1)=cent(n,1);
            end
        end
        dm=2*mean(b(:,3));
        for s=2:size(cline,2)
            if((cline(s)-cline(s-1)>dm))
                posChar{l}(s)=1;
            else
                posChar{l}(s)=0;
            end
        end
        
    end
end

end






