%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Wout1,positionOut]=getTextSMD(Wtext,positionIn,bar)
    
    Wout1=[];
    positionOut=[];
    if(~isempty(Wtext))
        f1=size(Wtext{1},1);                    % horizontal size of the parts
        f2=size(Wtext{1},2);                    % vertical size of the parts

        % cut the margin to extract the numbers (left and right margin is cut1, topand buttom margin is cut2)
        cut1=round(5*(f1/31));
        cut2=round(8*(f2/48));
        for i=1:size(Wtext,2)
            W=Wtext{i};
            Wtext{i}=W(cut1:end-cut1,cut2:end-cut2,:);
        end

        Wout1=[];
        positionOut=[];
        k=0;
        for im=1:size(Wtext,2)
            
            W=Wtext{im};
            pix=10;
            bar.update();

            % appriximated size of characters
            b1=15*(size(W,2)/69);
            b2=32*(size(W,2)/69);

            b11=b1-10;
            b12=b1+10;
            b21=b2-10;
            b22=b2+15;

            Ma=[];
            data=[];
            D=[];
            % get grayscaled image and use median-filter
            BW1=rgb2gray(W);
            BW2=imadjust(BW1);
            %BW3 = medfilt2(BW2, [5 5]);
            BW3=BW2;
            level=-0.2;
            for s=4:1:20
                % use niblack algorithm to get binary image
                [t,~,~] = niblack(BW3, level, s);
                BW4=(BW3 > abs(t));
                CC = bwconncomp(BW4,4);
                blobs=regionprops(CC,'BoundingBox');
                b=cat(1,blobs.BoundingBox);
                % filter possible characters by size of all
                ind=(b(:,3)>b11) .* (b(:,4)>b21) .* (b(:,3)<b12) .* (b(:,4)<b22);

                for o=1:CC.NumObjects 
                    if(ind(o)==1)
                        % get bounding box values
                        x1=round(b(o,1));
                        x2=round(b(o,1)+b(o,3)-1);
                        y1=round(b(o,2));
                        y2=round(b(o,2)+b(o,4)-1);

                        v=[x1,x2,y1,y2,1];
                        % calculate distance between bounding box and bounding box
                        % of other data
                        if(~isempty(data))
                            D = pdist2(data(:,1:4),v(1:4));
                        end
                        % get possible character
                        M=uint8(zeros(size(BW4)));
                        M(CC.PixelIdxList{o}) = 1;                    

                        % marge character with existing character on same position
                        % or create new possible character
                        if (sum(D<pix)>0 && ~isempty(data))
                            Ma{min(find(D<pix))} = Ma{min(find(D<pix))} + M;
                            num=data(min(find(D<pix)),5);
                            % calculate mean of the bounding boxes and a counter
                            % for number of appearances
                            data(min(find(D<pix)),1:4)=(num/(num+1)).*data(min(find(D<pix)),1:4)+(1/(num+1)).*v(1:4);
                            data(min(find(D<pix)),5)=data(min(find(D<pix)),5)+1;
                        else
                            Ma{end+1}=M;
                            data=[data;v];
                        end
                    end
                end
            end
            bar.update();
            if(~isempty(data))
                data(:,5)=data(:,5)/max(data(:,5));
                data(:,1:4)=round(data(:,1:4));


                % filter possible characters by number of appearances
                ind=data(:,5)>0.1;
                data=data(find(ind),:);
                Ma=Ma(find(ind));

                % reducae overlapping characters
                [Ma,data]=reduceOverlappingFirst(Ma,data,W);

                % calculate best number of character-lines
                %[NumLines,c]=getNumLines(data);

                    Dt=[];
                    MB=[];
                    V=[];
                    % filter all characters from a line
                    for i=1:size(data,1)
                            Dt(end+1,:)=data(i,1:4);
                            V(end+1,:)=data(i,5);
                            Mt=Ma{i}./max(max(Ma{i}));
                            Mt(Mt<0.5)=0;
                            Mt(Mt>=0.5)=1;
                            MB=cat(3,MB,Mt);
                     end

                     if(~isempty(Dt))            
                        b=ones(size(Dt,1),1);
                        % check if number of characters is larger than 4

                        for r=1:size(b,1)
                            if(sum(b)==1)
                                iszero=true;
                            else
                                iszero=false;
                            end
                            
                            if(sum(b)>=3)
                                % calculate mean of high of characters
                                meanh2=mean(Dt(:,4)-Dt(:,3));
                                % calculate tolerance of high and width of character bounding box depending on fitted line
                                tolh=4*(meanh2/33);
                                tolg=6*(meanh2/33);

                                % fit the position of the upper and lower points of bounding box to line and claculate the errors
                                %[R11]=createFit1([1:size(Dt,1)]',Dt(:,3),V);
                                R11=abs(mean(Dt(:,3))-Dt(:,3));
                                
                                %[R12]=createFit1([1:size(Dt,1)]',Dt(:,4),V);
                                R12=abs(mean(Dt(:,4))-Dt(:,4));
                                
                                % sum errors
                                Rg=R11+R12;
                                [mRg,pRg]=max(Rg);
                                if(mRg > tolg)
                                    b(pRg)=0;
                                end

                                if(sum(b)==size(b,1))
                                    [mR11,pR11]=max(R11);
                                    [mR12,pR12]=max(R12);
                                    if(mR11>mR12 && mR11>tolh)
                                        b(pR11)=0;
                                    elseif(mR12>=mR11 && mR12>tolh)
                                        b(pR12)=0;
                                    end
                                end

                                % filter data 
                                [Dt,V,MB,b]=reduceData(Dt,V,MB,b);
                                [Dt,V,MB,b]=reduceLargeDistance(Dt,V,MB,b);
                                [Dt,V,MB,b]=reduceData(Dt,V,MB,b);
                                
                            end
                        end

                        if((size(b,1)==3) || iszero)
                            k=k+1;
                            for o=1:size(b,1)
                                Mat=MB(:,:,(b~=0));
                                CC = bwconncomp(Mat(:,:,o),4);
                                blobs=regionprops(CC,'Image');

                                Wout1{k}{o}=blobs(1).Image;
                            end
                            positionOut(end+1,:)=positionIn(im,:);
                        end

                     end
            end
            q=1;
        end
    end
end


function [Dt,V,MB,b]=reduceData(Dt,V,MB,b)
    Dt=Dt(find(b),:);
    V=V(find(b),:);
    MB=MB(:,:,find(b));
    b=b(find(b));
end

function [Dt,V,MB,b]=reduceLargeDistance(Dt,V,MB,b)
    m=round((Dt(:,1)+Dt(:,2))/2);
    sdx=m;
    meanw=mean(Dt(:,2)-Dt(:,1));
    dm=2*meanw;

    if(sdx(2)-sdx(1)>(dm))
        b(1)=0;
    end
    if((sdx(end)-sdx(end-1)>(dm)))
        b(end)=0;
    end

    if(size(b,1)>1)
        for s=2:size(sdx,1)-1
            if((sdx(s)-sdx(s-1)>(dm) && sdx(s+1)-sdx(s)>(dm)))
            b(s)=0;
            end
        end
    else
        b=zeros(size(Dt,1),1);
    end

end

function [Dt,V,MB,b]=reduceOverlapping(Dt,V,MB,b)

    dx=Dt(:,1);
    [sdx,ind]=sort(dx);
    Dt=Dt(ind,:);
    V=V(ind);
    MB=MB(:,:,ind);

    b=ones(size(Dt,1),1);

    for i=1:size(b,1)-1;
        for j=i+1:size(b,1);
            S=MB(:,:,i).*MB(:,:,j);
            if(sum(S(:))>50)
                if(sum(sum(MB(:,:,i)))<sum(sum(MB(:,:,j))))
                    b(i)=0;
                else
                    b(j)=0;
                end
            end
        end
    end 

end


function [Ma,Data]=reduceOverlappingFirst(Ma,Data,W)

    dx=Data(:,1);
    [sdx,ind]=sort(dx);
    Data=Data(ind,:);
    Ma=Ma(ind);                
    b=ones(size(Data,1),1);
    for i=1:size(b,1)-1;
        for j=i+1:size(b,1);
            S=Ma{i}.*Ma{j};
            if(sum(S(:))>50)
                if(sum(sum(Ma{i}))<sum(sum(Ma{j})))
                    b(i)=0;
                else
                    b(j)=0;
                end
            end
        end
    end 

    Ma=Ma(find(b));
    Data=Data(find(b),:);
end

