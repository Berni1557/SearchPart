%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef SearchD < handle
% class SearchD 

  properties(GetAccess=public, SetAccess=public)
    folderName;                                     % name of folder
    imageList;                                      % list of images
    componentList=[];                               % list of components
    numImages=0;                                    % number of Images
    numComp=0;                                      % number of components
    Version='';                                     % version of SearchPart
    SearchPartLibrary;                              % structure of help-functions and datasets
    SessionName;                                    % name of the sission
  end

  methods
%Constructor
    function newSearchD=SearchD(filedata)                
        newSearchD.imageList=[];
        newSearchD.componentList=[];
        load('SearchPartVersion','SearchPartVersion');  %load SearchPart Version
        newSearchD.Version=SearchPartVersion;
        newSearchD=newSearchD.init(filedata);      %initialise SearchPart
        load('SearchPartLibrary/SearchPartLibrary','SearchPartLibrary');  %load library structure
        newSearchD.SearchPartLibrary=SearchPartLibrary;
    end
    

%Setter methods
     function set.SearchPartLibrary(obj,newSearchPartLibrary)               % set SearchPart Version 
        if(isstruct(newSearchPartLibrary))
            obj.SearchPartLibrary = newSearchPartLibrary;
        else
            error('SearchPartLibrary is not a struct!')
        end
     end
     
     function set.Version(obj,newVersion)               % set SearchPart Version 
        if(ischar(newVersion))
            obj.Version = newVersion;
        else
            error('SearchPartVersion is not a string!')
        end
     end
     
     function set.SessionName(obj,newSession)               % set SearchPart Version 
        if(ischar(newSession))
            obj.SessionName = newSession;
        else
            error('SearchPartVersion is not a string!')
        end
     end    
     
     function set.folderName(obj,newfolderName)         % set folder name of SearchPart project 
        if(ischar(newfolderName) && exist(newfolderName,'dir')==7)
            obj.folderName = newfolderName;
        else
            error('Error: Path could not be found!')
        end
     end

     function set.numImages(obj,newnumImages)           %set number of images in SearchPart
        if(isnumeric(newnumImages))
            obj.numImages = newnumImages;
        else
            error('Error: numImages is not an number!')
        end
     end
     
     function set.numComp(obj,newnumComp)               %set number of components
        if(isnumeric(newnumComp))
            obj.numComp = newnumComp;
        else
            error('Error: numComp is not an number!')
        end
     end
     

%Getter methods

    function SearchPartLibrary = get.SearchPartLibrary(obj)                 % get SearchPart library
        SearchPartLibrary = obj.SearchPartLibrary;                          
    end
    
    function Version = get.Version(obj)                 % get SearchPart version
        Version = obj.Version;                          
    end
    
    function SessionName = get.SessionName(obj)                 % get SearchPart version
        SessionName = obj.SessionName;                          
    end
    
    function numComp = get.numComp(obj)             % get number of components of SearchPart
        numComp = obj.numComp;                      
    end
    
    function numImages = get.numImages(obj)             % get number of images of SearchPart
        numImages = obj.numImages;                      
    end
    
    function folderName = get.folderName(obj)           % get folder name
        folderName = obj.folderName;              
    end
    
    function imageList = get.imageList(obj)             % get imageList
        imageList = obj.imageList;              
    end
     
 

     function obj=addImagaData(obj,newimageData)        % add new imageData to SearchPart
        if (strcmp(class(newimageData),'ImageData'))
            obj.imageList{end+1}=newimageData;
            obj.numImages=obj.numImages+1;
        else
            error('Error: Passed Value is not  an ImageData!')
        end
     end
     
     
     function obj=addComponent(obj,newComponent)         % add new component to SearchPart
        if (strcmp(class(newComponent),'Component'))
            obj.componentList{end+1}=newComponent;
            obj.numComp=obj.numComp+1;
        else
            error('Error: Passed Value is not  an Component!')
        end
     end     
    
    function exeAllComponentsOnImage(~,imageData)        % execute all components of one imageData
        for i=1:imageData.componentList.size;
            imageData.componentList{i}.executeStrategy(imageData.image);
        end
    end
    
    function exeAll(obj)                                % execute all components of all imageData
        for i=1:obj.imageList.size
            for j=1:obj.imageList{i}.componentList.size;
                obj.imageList{i}.componentList{j}.executeStrategy(obj.imageList{i}.image);
            end
        end
    end
  
    function exeComponentIDonImage(obj,imageData,co,bar)   % execute one component of on imageData
        imagepath=[obj.folderName,'/',imageData.imagepath];
        Im=imread(imagepath);
        imageData.componentList{co}.executeStrategy(Im,imageData.scaleFactor,bar,obj.SearchPartLibrary);
        %obj.componentList{co}.active=true;
    end
    
    function showComponentIDonImage(obj,imageData,ComponentID)        % one show component of one imageData
        for i=1:imageData.numComp
            if(ComponentID==imageData.componentList{i}.ComponentID)
                imageData.showComponent(imageData.componentList{i},obj)
            end
        end
    end
    
    function showImage(obj,imageData)                                 % show imageData
        imageData.showImage(obj);
    end
    
    function saveSession(obj)                                       % save session
        Session=obj;
        fullpath=obj.folderName;
        SessionName=obj.SessionName;
        save([fullpath,'/',SessionName],'Session');
        %save('SearchD','obj');
    end
    
    function obj=loadSession(obj)                                   % load  session
        load('SearchD','obj');
    end
     
    function obj=init(obj,filedata)                            % initialize SearchPart
        
        directoryname=filedata{1};
        filenames=filedata{2};
        if(ischar(filenames))
            f{1}=filenames;
            filenames=f;
        end
        [filename pathname] = uiputfile('*','Select path of Session-Project');  % specify path of SearchPart session
        fullpath=fullfile(pathname,filename);
        %fullpath=[fullpath,'/SessionImages/'];
        if (~isempty(pathname) && exist(pathname,'dir'))
            obj.SessionName=filename;
            mkdir([fullpath,'/SessionImages/']);                                        % copy all images of the selected folder to the SessionImages folder in the Searchpart project folder
            %copyfile(directoryname,[fullpath,'SessionImages']);
        else
            error('Projectpath does not exist');
        end

        obj.folderName=fullpath;
        %fullpath=[obj.folderName,'SessionImages/','*.JPG'];
%         D1 = dir([directoryname,'/*.JPG']); 
%         D2 = dir([directoryname,'/*.png']);
%         D3 = dir([directoryname,'/*.bmp']);
%         D=[D1,D2,D3];
               
        timeLoad=1/size(filenames,2);                
        barLoad = waitbar(0,'Please wait...');                      % use waitbar for loading images
        
        componentListTemp=initComponent();                      % initialize componentList
        for c=1:size(componentListTemp,2)
            obj.addComponent(componentListTemp{c});
        end
        
        for i = 1:size(filenames,2)
            componentListTemp=initComponent();
            %copyfile([directoryname,'/SessionImages/',D(i).name],[fullpath,'SessionImages/',D(i).name]);
            filepath=fullfile(directoryname, filenames{i});
            copyfile(filepath,[fullpath,'/SessionImages/',filenames{i}]);
            imagepath=[obj.folderName,'/SessionImages/',filenames{i}];
            
            imageData=ImageData(imagepath,filenames{i});    
            for c=1:size(componentListTemp,2)
                component=componentListTemp{c};
                component.ImageName=imageData.name;
                imageData.addComponent(component);                  % add components to imageData
                %if i==1
                %    obj.addComponent(componentListTemp{c});
                %end
            end
            if(imageData.scaleFactor~=false)
                obj.addImagaData(imageData);                            % add imagedata to SearchPart
                t=['Please wait... Loading image: ',num2str(i),'/',num2str(size(filenames,2))];
                waitbar((i-1)*timeLoad,barLoad,t);
            else
                t=['Image ', filenames{i}, ' could not be loaded!'];
                waitbar((i-1)*timeLoad,barLoad,t);
            end
        end 
        close(barLoad);
    end
    
    
    %get Image by name
    function ImData=getImagDatabyName(obj,ImageName)                
        for i=1:obj.numImages
            if(strcmp(obj.imageList{i}.name,ImageName))     
                ImData=obj.imageList{i};
            end
        end
    end
    
    
    % get part of imageData and component by partID
    function part=getPart(obj,ImageName,ComponentID,partID)         
        for i=1:obj.numImages
            if(strcmp(obj.imageList{i}.name,ImageName)) 
                part=obj.imageList{i}.getPart(ComponentID,partID);     
            end
        end
    end
    
    
    %  get list of image names
    function ImageNameList=getImageNameList(obj)                    
        for i=1:obj.numImages
            ImageNameList{i}=obj.imageList{i}.name;
        end
    end
    
    
    %  get list of components and list of component names
    function [CompListName,CompList]=getCompList(obj)   
        CompListName=[];
        for i=1:obj.numComp
            CompListName{i}=obj.componentList{i}.name;  
        end
        CompList=obj.componentList;
    end
    
    
    %get list of all part and list of partnames of imageData and component
    function [partListOut,partListNameOut]=search(obj,ImageName,ComponentID,PartName)   
        partListOut=[];
        partListNameOut=[];
        distance=[];
        partListT=[];
        partValueT=[];
        for im=1:obj.numImages
            if(strcmp(obj.imageList{im}.name,ImageName) || strcmp(ImageName,'All'))
                for c=1:obj.imageList{im}.numComp
                    if(obj.componentList{c}.ComponentID==ComponentID)
                        obj.imageList{im}.componentList{c}.active=true;
                        for p=1:obj.imageList{im}.componentList{c}.numParts
                            distance(end+1)=strdist(PartName,obj.imageList{im}.componentList{c}.partList{p}.value);  
                            partListT{end+1}=obj.imageList{im}.componentList{c}.partList{p};
                            partValueT{end+1}=obj.imageList{im}.componentList{c}.partList{p}.value;
                        end
                    end
                end
            end
        end
        
        [~,pos]=sort(distance);
        partList=partListT(pos);
        partValue=partValueT(pos);
        
        partUni=unique(partValue);     
        
        num=ones(1,size(partValue,2));
        for i=1:size(partList,2)
            for j=1:size(partUni,2)
                if(strcmp(partValue{i},partUni{j}))
                    partListNameOut{i}=[partValue{i},' (',num2str(num(j)),')     ',partList{i}.ImageName];
                    partListOut{i}=partList{i};
                    num(j)=num(j)+1;
                end
            end 
        end
        
    end
    
    
    % get list of imageData and list of image names depending on part name
    function [imageList,imageListName]=getImageswithPart(obj,part)      
        imageList=[];
        imageListName=[];
        for i=1:obj.numImages
            if(strcmp(obj.imageList{i}.name,part.ImageName))
                imageList{end+1}=obj.imageList{i};
                imageListName{end+1}=obj.imageList{i}.name;
            end
        end
    end
    
    
    % get list of imageData wit specified component
    function [imageList,imageListName]=getImageswithComnponent(obj,componente)  
        imageList=[];
        imageListName=[];
        for i=1:obj.numImages
            for c=1:obj.imageList{i}.numComp
                if((obj.imageList{i}.componentList{c}.ComponentID==componente.ComponentID) && (obj.imageList{i}.componentList{c}.numParts>0))
                    imageList{end+1}=obj.imageList{i};
                    imageListName{end+1}=obj.imageList{i}.name;
                end
            end
        end
    end
    
    
    % get execution-time of all components to be searched
    function [timeAll]=getTimeRest(obj,handles,handle1)                     
        out=get(handle1,'UserData');
        impos=out;
        if(strcmp(get(handle1,'String'),'Execute all'))
            timeAll=[];
            for im=1:obj.numImages
                for co=1:obj.numComp
                    if((get(handles.checkbox{im}{co},'value')==1)  && (obj.imageList{im}.componentList{co}.active==false))
                        timeAll(end+1)=obj.componentList{co}.strategy.time;
                    end
                end
            end
        else
            timeAll=[];
            for co=1:obj.numComp
                if((get(handles.checkbox{impos}{co},'value')==1) && (obj.imageList{impos}.componentList{co}.active==false))
                    timeAll(end+1)=obj.componentList{co}.strategy.time;
                end
            end
        end
        if(isempty(timeAll))
            timeAll=0;
        end
    end
    
    
    % add new images to session
    function addImages(obj)                                             % add images of folder to SearchPart
        [filenames,directoryname] = uigetfile({'*.JPG';'*.png';'*.bmp';'*'}, 'Pick image files','MultiSelect','on'); % pick image files
        fullpath=obj.folderName;        
        if(directoryname~=0)
            if (~isempty(directoryname) && exist(directoryname,'dir'))
                %endIndex = regexp(fullpath,'SessionImages','end');
                %copyfile(directoryname,[fullpath,'SessionImages']);
            else
                error('Projectpath is does not exist');
            end

            newIm=[];
            if(ischar(filenames))
                newIm(1)=1;
                for j=1:obj.numImages
                    if(strcmp(obj.imageList{j}.name,filenames))
                        newIm(1)=0;
                    end
                end
                filenames1=filenames;
            else
                for i=1:size(filenames,2)
                    newIm(i)=1;
                    for j=1:obj.numImages
                        if(strcmp(obj.imageList{j}.name,filenames{i}))
                            newIm(i)=0;
                        end
                    end
                end
                filenames1=filenames(find(newIm));
            end
            
            timeLoad=1/size(filenames,2);
            barLoad = waitbar(0,'Please wait...');

            if(ischar(filenames))
                    copyfile([directoryname,'/',filenames1],[fullpath,'/SessionImages/',filenames1]);
                    t=['Please wait... Loading image: 1/1'];
                    waitbar(0.5,barLoad,t);
                    imagepath=[obj.folderName,'/SessionImages/',filenames1];
                    componentListTemp=initComponent();        
                    imageData=ImageData(imagepath,filenames1);    
                    
                    imageData.name=filenames1;
                    for c=1:size(componentListTemp,2)
                        component=componentListTemp{c};
                        component.ImageName=imageData.name;
                        imageData.addComponent(component);
                    end

                   if(imageData.scaleFactor~=false)
                        obj.addImagaData(imageData);                            % add imagedata to SearchPart
                        t=['Please wait... Loading image: ',num2str(i),'/',num2str(size(filenames,2))];
                        waitbar((i-1)*timeLoad,barLoad,t);
                    else
                        t=['Image ', filenames{i}, ' could not be loaded!'];
                        waitbar((i-1)*timeLoad,barLoad,t);
                    end
            else
                for i=1:size(filenames1,2)
                    copyfile([directoryname,'/',filenames1{i}],[fullpath,'/SessionImages/',filenames1{i}]);
                    %t=['Please wait... Loading image: ',num2str(i),'/',num2str(size(filenames1,2))];
                    %waitbar((i-1)*timeLoad,barLoad,t);
                    imagepath=[obj.folderName,'/SessionImages/',filenames1{i}];
                    componentListTemp=initComponent();        
                    imageData=ImageData(imagepath,filenames1{i});    
                    imageData.name=filenames1{i};
                    for c=1:size(componentListTemp,2)
                        component=componentListTemp{c};
                        component.ImageName=imageData.name;
                        imageData.addComponent(component);
                    end

                    if(imageData.scaleFactor~=false)
                        obj.addImagaData(imageData);                            % add imagedata to SearchPart
                        t=['Please wait... Loading image: ',num2str(i),'/',num2str(size(filenames,2))];
                        waitbar((i-1)*timeLoad,barLoad,t);
                    else
                        t=['Image ', filenames{i}, ' could not be loaded!'];
                        waitbar((i-1)*timeLoad,barLoad,t);
                    end
            
                    %obj.addImagaData(imageData);          
                end 
            end
            close(barLoad);
        end
    end
    
    
    %delete images of the session
    function [obj,handles]=deleteImages(obj,deleteButton,handles)
        im=get(deleteButton,'UserData');
        delete(handles.images{im});
        delete(handles.deleteButton{im});
        delete(handles.imageName{im});
        handles.images(im)=[];
        handles.deleteButton(im)=[];
        handles.imageName(im)=[];
        obj.imageList(im)=[];
        obj.numImages=obj.numImages-1;
    end
    
  end
 
end

