%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef ImageData < handle
  %TARGET Class for representing a target
  %   A target class knows its angle, signal and range

  % Copyright 2008 The MathWorks, Inc.

  properties
      componentList;            % list of all components of the ImageData
      image;                    % image of Imagedate (100 x 150)
      name='';                  % name of ImageData
      imagepath;                % path to the original image
      imagesize;                % size of the original image
      numComp=0;                % number of components in ImageData
      scaleFactor;              % scaleFacor of the image
  end

  methods
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Constructor
    function newImageData = ImageData(newimagepath,newname)
            newImageData.name=newname;
            newimage = imread(newimagepath);
            I=imresize(newimage,[100,150]);
            newImageData.image=I;
            newImageData.componentList=[];
            startIndex = regexp(newimagepath,'SessionImages/');
            newImageData.imagepath=newimagepath(startIndex:end);
            newImageData.imagesize=size(newimage);
            newImageData.scaleFactor=newImageData.scaleCircle(newimage);
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     function set.scaleFactor(obj,newscaleFactor)                   % set scaleFactor
        if(true)
            obj.scaleFactor=newscaleFactor;
        else
            error('Error: Passed scaleFactor is not a Number!')
        end
     end
    
     function set.numComp(obj,newnumComp)                           % set number of components
        if(isnumeric(newnumComp))
            obj.numComp=newnumComp;
        else
            error('Error: Passed Value is not a Number!')
        end
     end
     
     function set.image(obj,image)                                  % set image of ImageData
        if(strcmp(class(image),'uint8'))
            obj.image=image;
        else
            error('Error: Passed Value is not an image!')
        end
     end
     
     function set.imagesize(obj,imagesize)                          % set imagesize
        if(isnumeric(imagesize) && imagesize(3)==3)
            obj.imagesize=imagesize;
        else
            error('Error: Passed Imagesize is not possible!')
        end
     end
     
     function set.imagepath(obj,imagepath)                          % set path of the image
        if(ischar(imagepath))
            obj.imagepath=imagepath;
        else
            error('Error: Passed Imagepath does not exist!')
        end
     end
     
     function set.name(obj,name)                                    % set name of image to ImageData
        if(ischar(name))
            obj.name=name;
        else
            error('Error: Passed Value is not a LinkedComponentList!')
        end
     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Getter methods

    function scaleFactor = get.scaleFactor(obj)                     % get scaleFactor
        scaleFactor = obj.scaleFactor;             
    end
    
    function components = get.componentList(obj)                    % get components
        components = obj.componentList;              
    end
    
    function numComp = get.numComp(obj)                             % get number of components
        numComp = obj.numComp;              
    end
    
    function image = get.image(obj)                                 % get image of Imagedata
        image = obj.image;              
    end
     
    function name = get.name(obj)                                   % get name of ImageData
        name = obj.name;              
    end
    
    function imagepath = get.imagepath(obj)                         % get path of image
        imagepath = obj.imagepath;             
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    % add components to ImageData
    function addComponent(obj,component)
        if(strcmp(class(component),'Component'))
            obj.componentList{end+1}=component;
            obj.numComp=obj.numComp+1;
        else
            error('component is nt from Class Component')
        end
    end
    
    % execute component on ImageData
    function exeComponent(obj,component)
            if(component.active==false)
                component.executeStrategy(obj.image);
            else
                disp('Component was already used!')
            end
    end
    
    % execute all components of ImageData
    function exeAll(obj)
        for i=1:obj.numComp;
            obj.componentList{i}.executeStrategy(obj.image);
        end
    end
    
    % show component of ImageData
    function showComponent(obj,component,Session)
        imagepath=[Session.folderName,'/',obj.imagepath];
        if(component.active)
            Im=imread(imagepath);
            GUIshow(Im,component.partList);
        else
            disp('Component is not active!')
        end
    end
    
    % show image of ImageData
    function showImage(obj,Session)
        imagepath=[Session.folderName,'/',obj.imagepath];
        Im=imread(imagepath);
        GUIshow(Im);
    end
    
    % get part by partID and ComponentID
    function part=getPart(obj,ComponentID,partID)
        for i=1:obj.numComp
            if(obj.componentList{i}.ComponentID==ComponentID)
                part=obj.componentList{i}.getPart(partID);
            end
        end
    end
    
    % calculate scaleFactor of image
    function [scale_factor]=scaleCircle(obj,I)
        sc=2000/size(I,2);
        I1=imresize(I,sc);
        ecc=0.7;
        %se1 = strel('square',3);
        Ig1=rgb2gray(I1);
        Ig2 = imadjust(Ig1);
        %Ig3 = imerode(Ig2,se1);
        Ig3=Ig2;
        BW=adaptivethreshold(Ig3,[20,20],0,0);
        BW=~BW;
        se = strel('rectangle',[5,5]);
        BW = imclose(BW,se);
        STATS = regionprops(BW,'Centroid','Eccentricity','EulerNumber','BoundingBox');
        %CC = bwconncomp(BW);
        Eccentricity = cat(1, STATS.Eccentricity);
        Centroid = cat(1, STATS.Centroid);
        %EulerNumber = cat(1, STATS.EulerNumber);
        BoundingBox = cat(1, STATS.BoundingBox);
        %EulerNumber=EulerNumber(Eccentricity<ecc,:);
        BoundingBox=BoundingBox(Eccentricity<ecc,:);
        Centroid=Centroid(Eccentricity<ecc,:);
        D = pdist2(Centroid,Centroid);
        
        D=D+diag(ones(size(D,1),1)*100);
        [C,rowmaxarray]=min(D);
        [~,b]=min(C);
        a=rowmaxarray(b);
        
        if(mean(BoundingBox(a,3:4))>mean(BoundingBox(b,3:4)))
            d = mean(BoundingBox(a,3:4))/sc;
        else
            d = mean(BoundingBox(b,3:4))/sc;
        end
        %scale_factor=14.2235*(d/116);
        scale_factor=25.86*(d/198);
        if d<50
            scale_factor=false;
        end
    end

    
  end
end

