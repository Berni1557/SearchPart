%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Ir,phig]=rotCorrection(Iin)
    
    % resize image 
    I=imresize(Iin,[3000,4000]);
    I1=imrotate(I,5);
    I1=I1(500:2500,500:2500,:);
    
    % use gaussfilter for edge detection
    I2=imageprocessing(I1);
    % do 2d -fft of the image
    f=fft2(double(I2));
    f1=abs(f);
    % shift frequency domaine
    f2=fftshift(f1);
    f3=imresize(f2,[500,500]);
    % normalize frequencies
    f4=f3./max(f3(:));

 
    h=round(size(f4,1)/2);
    phib=linspace(0,pi/2,360);
    phiv=zeros(1,size(phib,2));
    
    % 1. Quadrant
    % create array of first quadrant with content of the angles
    x=1:h;
    y=1:h;
    xA=(ones(1,h)'*x)';
    yA=ones(1,h)'*y;
    dx=h-xA;
    dy=h-yA;
    phi=atan(dy./dx);

    
    f5=f4(1:h,1:h);
    for b=1:size(phiv,2)-1
        pos=(phi>=phib(b)) .* (phi<phib(b+1));
        logi=logical(pos);

        f6=zeros(size(f5));
        f6(logi)=f5(logi);
        v=(sum(f6(:)))/(sum(logi(:)));
        phiv(b)=v;
    end

    phiv1=phiv;
    % 2. Quadrant

    x=1:h;
    y=h+1:size(f4,1);
    xA=(ones(1,h)'*x)';
    yA=ones(1,h)'*y;
    dx=h-xA;
    dy=yA-h;
    phi=atan(dx./dy);

    
    f5=f4(1:h,h+1:size(f4,1));
    for b=1:size(phiv,2)-1

        pos=(phi>=phib(b)) .* (phi<phib(b+1));
        logi=logical(pos);

        f6=zeros(size(f5));
        f6(logi)=f5(logi);

        v=(sum(f6(:)))/(sum(logi(:)));
        phiv(b)=v;
    end

    phiv2=phiv;

    % 3. Quadrant

    x=h+1:size(f4,1);
    y=h+1:size(f4,1);
    xA=(ones(1,h)'*x)';
    yA=ones(1,h)'*y;
    dx=h-xA;
    dy=h-yA;
    phi=atan(dy./dx);

    f5=f4(h+1:size(f4,1),h+1:size(f4,1));
    for b=1:size(phiv,2)-1

        pos=(phi>=phib(b)) .* (phi<phib(b+1));
        logi=logical(pos);

        f6=zeros(size(f5));
        f6(logi)=f5(logi);

        v=(sum(f6(:)))/(sum(logi(:)));
        phiv(b)=v;
    end

    phiv3=phiv;
    
    % 4. Quadrant

    x=h+1:size(f4,1);
    y=1:h;
    xA=(ones(1,h)'*x)';
    yA=ones(1,h)'*y;
    dx=xA-h;
    dy=h-yA;
    phi=atan(dx./dy);

    f5=f4(h+1:size(f4,1),1:h);
    for b=1:size(phiv,2)-1

        pos=(phi>=phib(b)) .* (phi<phib(b+1));
        logi=logical(pos);

        f6=zeros(size(f5));
        f6(logi)=f5(logi);

        v=(sum(f6(:)))/(sum(logi(:)));
        phiv(b)=v;
    end

    phiv4=phiv;

    
    value=phiv1+phiv2+phiv3+phiv4;
    value(isnan(value))=0;
    [b,a]=butter(5,1000/5000,'low');
    y = filtfilt(b,a,value);

    [~,phipos]=max(y(10:end-10));
    phig=(phib(phipos+10)*180/pi);
    
    %correct the initial rotation
    phig=phig-5;
    
    if(phig>45)
        phig=phig-90;
    end
    % correct rotation of image
    Ir=imrotate(Iin,-phig);

end

function Iout=imageprocessing(I)

I1=rgb2gray(I);
I2 = imadjust(I1);
I3=medfilt2(I2,[3 3]);
[gx,gy]=gaussgradient(I3,3);
Iout=(abs(gx)+abs(gy));

end
