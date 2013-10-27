%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = GUIsearchInImages(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIsearchInImages_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIsearchInImages_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUIsearchInImages is made visible.
function GUIsearchInImages_OpeningFcn(hObject, eventdata, handles, varargin)    %input: varargin{1}='load', varargin{2}='on'/'off'

set(hObject, 'units','normalized');
set(hObject,'Position',[0 0 0.95 0.95]);
movegui(hObject,'center');
filename=[];
searchbutton7_update(handles);
if(ischar(varargin{2}) && strcmp(varargin{2},'on'))                                        % load Session from Project
    [filename pathname] = uigetfile('*.mat','Pick a Session');
    if(filename~=0)
        file=load(fullfile(pathname,filename));
        if(isfield(file,'Session'))
            fields = fieldnames(file);
            s=fields(1);
            Session = getfield(file, s{1});
            Session.folderName=pathname;
            handles.Session=Session;
            handles=loadSession(handles);
            selectFolderbutton_update(handles);
            AddImagesbutton_update(handles);
            DeleteImages_update(handles);
            showID_update(handles);
            Aboutbutton_update(handles);
            savebutton_update(handles);
            closebutton_update(handles);
            searchbutton7_update(handles);
        else
            set(handles.infotext,'String','File is not a Session')
        end
    end
end

if(strcmp(class(varargin{2}),'SearchD'))
    handles.Session=varargin{2};
    handles=loadSession(handles);
    selectFolderbutton_update(handles);
    AddImagesbutton_update(handles);
    DeleteImages_update(handles);
    showID_update(handles);
    Aboutbutton_update(handles);
    savebutton_update(handles);
    closebutton_update(handles);
    searchbutton7_update(handles);
    
    %handles=compText_update(handles);
    %handles=StratText_update(handles);
    handles=componenttext_update(handles);
    handles=strategytext_update(handles);
    handles=imageAxes_update(handles);
    handles=imageAxesName_update(handles);
    handles=checkboxArray_update(handles);
    handles=executeButton_update(handles);
    handles=popup_update(handles);
    handles=showbutton_update(handles);

end
selectFolderbutton_update(handles);
searchbutton7_update(handles);
handles.output = hObject;

load('SearchPartVersion','SearchPartVersion');                  %load version
if(~isempty(filename))
    tt=filename(1:end-4);
    t=[SearchPartVersion,' - ','Session: ',tt];
    set(hObject,'Name',t);
end

guidata(handles.figure1, handles);
guidata(hObject, handles);

function GUIsearchInImages_DeleteFcn(hObject, eventdata, handles, varargin) 
%quit();

% --- Outputs from this function are returned to the command line.
function varargout = GUIsearchInImages_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


%select folder button Callback function
function selectFolderbutton_Callback(hObject, eventdata, handles)   %select folder of images
[filenames,pathname] = uigetfile({'*.JPG';'*.png';'*.bmp';'*'}, 'Pick image files','MultiSelect','on');
filedata={pathname,filenames};
if(~pathname==0)
    set(handles.selectFolderbutton,'Userdata',filedata);
end
selectFolderbutton_update(handles);
loadImagesbutton_update(handles);
set(hObject,'visible','off');
guidata(handles.figure1,handles);


% --- Executes on button press in loadImagesbutton.
function loadImagesbutton_Callback(hObject, eventdata, handles)
set(handles.infotext,'String','Loading!');      %load Session
pause(0.1);
handles=loadSession(handles);
%set(handles.infotext,'String','Done!');
loadImagesbutton_update(handles);           %update handles
selectFolderbutton_update(handles);
AddImagesbutton_update(handles);
DeleteImages_update(handles)
showID_update(handles);
Aboutbutton_update(handles);
savebutton_update(handles);
closebutton_update(handles);
searchbutton7_update(handles);

Session=handles.Session;
fullpath=Session.folderName;
set(handles.infotext,'String','Wait: Saving Sessions!')
pause(0.1)
%[start1] = regexpi(fullpath,'/');
%[start2] = regexpi(fullpath,'.prj');
%SessionName=fullpath(start1(end-1)+1:start2-1);
SessionName=Session.SessionName;
%save([fullpath,SessionName],'Session')
Session.saveSession();
set(handles.infotext,'String','Done!')
load('SearchPartVersion','SearchPartVersion');                  %load version
tt=Session.SessionName;
t=[SearchPartVersion,' - ','Session: ',tt];
set(handles.figure1,'Name',t);

guidata(handles.figure1,handles);


%executeAllbutton Callback function
function executeAllbutton_Callback(hObject, eventdata,handles)
bar=progressbar(handles,hObject);
bar.update();
for im=1:handles.Session.numImages
    for co=1:handles.Session.numComp
        if(get(handles.checkbox{im}{co},'value')==1 && (handles.Session.imageList{im}.componentList{co}.active==false))      
        	set(handles.infotext,'String','Busy!')
            pause(0.1);
            %try
                bar.update();
            	handles.Session.exeComponentIDonImage(handles.Session.imageList{im},handles.Session.imageList{im}.componentList{co}.ComponentID,bar) %execute strategy
                %waitupdate(bar,true);            %update waitbar
                bar.update();
                %waitreset(bar);                  %reset waitbar
                bar.waitreset();
                %handles.Session.imageList{im}.componentList{co}.active=true;
                %handles.Session.componentList{co}.active=true;
                set(handles.infotext,'String','Done!')
                set(handles.checkbox{im}{co},'enable','off');   
%             catch err
%                 if(bar.aborted==1)
%                     set(handles.infotext,'String','Stop execution');
%                     error('Aborted!');
%                 else
%                     delete(bar.bar)
%                     set(handles.infotext,'String',['Error occured by exucuting the ', handles.Session.componentList{co}.name, ' component of the image ',handles.Session.imageList{im}.name]);
%                     error('Aborted!');
%                 end
%             end       
        end   
    end
end
bar.waitclose();
for im=1:handles.Session.numImages
    cell_var=[];
    cell_var{1}='...';
    for co=1:handles.Session.imageList{im}.numComp
        if(handles.Session.imageList{im}.componentList{co}.active)
            cell_var{end+1} = [handles.Session.imageList{im}.componentList{co}.name];
        end
    end
    f=guidata(handles.figure1);
    set(f.popup{im},'String',cell_var);
end



%execute button Calback function
function executebutton_Callback(handle1, eventdata,handles)
im=get(handle1,'UserData');
bar=progressbar(handles,handle1);
tic;
bar.update();
for co=1:handles.Session.numComp
    if(get(handles.checkbox{im}{co},'value')==1 && (handles.Session.imageList{im}.componentList{co}.active==false))      
       set(handles.infotext,'String','Busy!')
       pause(0.1); 
       %try
           handles.Session.exeComponentIDonImage(handles.Session.imageList{im},co,bar)
           handles.Session.componentList{co}.active=true;
           bar.updatefull();                  %update waitbar
           bar.waitreset();                             %reset waitbar
           %handles.Session.imageList{im}.componentList{co}.active=true;
           set(handles.infotext,'String','Done!')
           set(handles.checkbox{im}{co},'enable','off'); 
%        catch err
%            set(handles.infotext,'String',['Error occured by exucuting the ', handles.Session.componentList{co}.name, ' component of the image ',handles.Session.imageList{im}.name]);
%        end 
    end   
end
bar.waitclose();
    cell_var=[];
    cell_var{1}='...';
    for co=1:handles.Session.imageList{im}.numComp
        if(handles.Session.imageList{im}.componentList{co}.active)
            cell_var{end+1} = [handles.Session.imageList{im}.componentList{co}.name];
        end
    end
f=guidata(handles.figure1);
set(f.popup{im},'String',cell_var)


% showbutton Callback
function showbutton_Callback(handle1,eventdata,handles)
im=get(handle1,'UserData');
liststr=get(handles.popup{im},'String');
str = get(handles.popup{im}, 'Value');
im=get(handle1,'UserData');
for co=1:handles.Session.imageList{im}.numComp
    if(strcmp(handles.Session.imageList{im}.componentList{co}.name,liststr{str}))
        handles.Session.showComponentIDonImage(handles.Session.imageList{im},handles.Session.imageList{im}.componentList{co}.ComponentID)
    end
end
if(strcmp(liststr{str},'...'))
    handles.Session.showImage(handles.Session.imageList{im});
end

%popup Callback function
function popup_Callback(handle1, eventdata,handles)
im=get(handle1,'UserData');    %check which popup handle was uses (im-Image number, co-component number)
cell_var=[];
cell_var{1}='...';
for co=1:handles.Session.imageList{im}.numComp
    if(handles.Session.imageList{im}.componentList{co}.active)
        cell_var{end+1} = [handles.Session.imageList{im}.componentList{co}.name];   %fill with strings of Components
    end
end


%save Session in project folder
function savebutton_Callback(hObject, eventdata, handles)
Session=handles.Session;
set(handles.infotext,'String','Wait: Saving Sessions!')
pause(0.1)
Session.saveSession();
set(handles.infotext,'String','Done!')


%close Session and window
function closebutton_Callback(hObject, eventdata, handles)
Session=handles.Session;
close(handles.figure1); 
GUIclose(Session);
%quit;


% --- Executes during object creation, after setting all properties.
function infotext_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.01 0.02 0.99 0.07]);

% --- Executes during object creation, after setting all properties.
function loadImagesbutton_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.42 0.92 0.16 0.05]);
set(hObject,'visible','off')

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
slider1_update(handles);
pause(0.1);
%handles=compText_update(handles);
%handles=StratText_update(handles);
handles=componenttext_update(handles);
handles=strategytext_update(handles);
handles=imageAxes_update(handles);
handles=imageAxesName_update(handles);
handles=checkboxArray_update(handles);
handles=executeButton_update(handles);
handles=popup_update(handles);
handles=showbutton_update(handles);
guidata(handles.figure1,handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
%set(hObject,'Position',[0.01 0.01 0.99 0.85]);
set(hObject,'Position',[0.98 0.05 0.015 0.93]);
set(hObject,'value',1)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function panel_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.01 0.01 0.98 0.88]);

%checkbox All Calllback function
function checkboxAll_Callback(hObject, eventdata, handles)
co=get(hObject,'Userdata');
enable=get(hObject,'value');
if(enable==1)
    for im=1:handles.Session.numImages;
        %set(handles.checkbox{im}{co},'enable','off');
        set(handles.checkbox{im}{co},'value',1);
    end
else
    for im=1:handles.Session.numImages;
        if(~handles.Session.imageList{im}.componentList{co}.active)
            set(handles.checkbox{im}{co},'enable','on');
            set(handles.checkbox{im}{co},'value',0);
        end
    end
end


%load Session and updates figures
function handles=loadSession(handles)      

filedata=get(handles.selectFolderbutton,'Userdata');    
if(~isfield(handles,'Session'))          %create Session if Session doesn't exist
    Session=SearchD(filedata);
    handles.Session=Session;
end
handles=imageAxes_create(handles);          %update handles
handles=imageAxesName_create(handles);
handles=compText_create(handles);
handles=StratText_create(handles);
handles=componenttext_create(handles);
handles=strategytext_create(handles);
handles=checkboxArray_create(handles);
handles=checkboxAll_create(handles);
handles=executeAllButton_create(handles);
handles=executeButton_create(handles);
handles=popup_create(handles);
handles=showbutton_create(handles);
    
guidata(handles.figure1,handles);


% --- Executes on button press in searchbutton7.
function searchbutton7_Callback(hObject, eventdata, handles)
Session=handles.Session;
if(handles.Session.numImages>0)
    GUIsearchPart(Session)
else
    set(handles.infotext,'String','No images found!')
end
    


% --- Executes during object creation, after setting all properties.
function label1_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.01 0.9 0.08 0.08]);
if(strcmp(getenv('OS'),'Windows_NT'))
    pa=userpath;
    label =imread([pa(1:end-1),'\SearchPart\label.png']);
else
    pa=pwd;
    label =imread([pa,'/SearchPart/label.png']);
end
imshow(label);
pause(0.1);


% --- Executes on button press in AddImagesbutton.
function AddImagesbutton_Callback(hObject, eventdata, handles)
handles.Session.addImages();
close(handles.figure1); 
GUIsearchInImages('load',handles.Session);


%create Add Images button
function AddImagesbutton_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.36 0.92 0.08 0.05]);
set(hObject,'visible','off');


%update select Folder button
function selectFolderbutton_update(handles)
if(~isfield(handles,'Session'));
    set(handles.selectFolderbutton,'visible','on');
else
    set(handles.selectFolderbutton,'visible','off');
end

%update load Images button
function loadImagesbutton_update(handles)
if(isfield(handles,'Session'));
    set(handles.loadImagesbutton,'visible','off');
else
    set(handles.loadImagesbutton,'visible','on');
end

%update Image button
function AddImagesbutton_update(handles)
if(isfield(handles,'Session'));
    set(handles.AddImagesbutton,'visible','on');
else
    set(handles.AddImagesbutton,'visible','off');
end

%create image axes
function handles=imageAxes_create(handles)
position=get(handles.panel,'position');
posY0=position(2)+position(4)-0.08;
posX0=position(1)+0.035;
diffY=0.1;
sliderDistY=0;
    for im=1:handles.Session.numImages
        posY=posY0+sliderDistY-im*diffY;
        posX=posX0;
        handles.images{im} = axes('units','normalized','Position', [posX posY 0.05 0.05],'YTickLabel',[]);
        I=handles.Session.imageList{im}.image;
        imshow(I);
        set(handles.images{im},'NextPlot','replacechildren')
        set(handles.images{im},'UserData',I);
        
        %if(posY > 390 || posY < 74 || posX<40 || posX>1020)                         %make images invisible if position is out of range
        if(posY > 0.72 || posY < 0.1 || posX<0.02 || posX>0.9)
            set(handles.images{im},'visible','off');
            cla(handles.images{im});
            set(handles.images{im},'UserData',[]);
        else
            imshow(handles.Session.imageList{im}.image,'Parent',handles.images{im});
            set(handles.images{im},'UserData',handles.Session.imageList{im}.image);
        end
        
    end

%update position of images
function handles=imageAxes_update(handles)
slider1_update(handles);
slider2_update(handles);
sliderDistY=get(handles.slider1,'UserData');
sliderDistX=get(handles.slider2,'UserData');
position=get(handles.panel,'position');
posY0=position(2)+position(4)-0.08;
posX0=position(1)+0.035;
diffY=0.1;
position=get(handles.panel,'position');
for im=1:handles.Session.numImages
    posY=posY0+sliderDistY-im*diffY;
    %posX=posX0-sliderDistX;
    posX=posX0;
    set(handles.images{im},'position',[posX posY 0.05 0.05]);
    
    if(posY > 0.72 || posY < 0.1 || posX<0.02 || posX>0.9)
        set(handles.images{im},'visible','off');
        cla(handles.images{im});
        set(handles.images{im},'UserData',[]);
    else
        imshow(handles.Session.imageList{im}.image,'Parent',handles.images{im});
        set(handles.images{im},'UserData',handles.Session.imageList{im}.image);
    end
end

%update component text and conponent ID text
function handles=componenttext_create(handles)
componentDistance=0.07;
position=get(handles.panel,'position');
posY0=position(2)+position(4);
posX0=position(1)+0.05;
posY=posY0-0.08;
for co=1:handles.Session.numComp
    posX=posX0+(co*componentDistance);
    handles.componenttext{co}=uicontrol('Style', 'text','units','normalized', 'String', [' ID: ',num2str(handles.Session.componentList{co}.ComponentID)],'Position', [posX posY 0.03 0.05]);
end

% update componenttext
function handles=componenttext_update(handles)
sliderDistX=get(handles.slider2,'UserData');
componentDistance=0.07;
position=get(handles.panel,'position');
posX0=position(1)+0.05;
for co=1:handles.Session.numComp
    posX=posX0+(co*componentDistance)-sliderDistX;
    position=get(handles.componenttext{co},'position');
    posY=position(2);
    set(handles.componenttext{co},'position',[posX posY 0.03 0.05]);
    if(posX<0.12 || posX>0.85)
        set(handles.componenttext{co},'visible','off');     %make visible if image is visible
    else
        set(handles.componenttext{co},'visible','on');      %make unvisible if image is unvisible
    end
end


%create compText
function handles=compText_create(handles)
%set(hObject, 'units','normalized');
%set(hObject,'Position',[0.01 0.01 0.99 0.85]);
position=get(handles.panel,'position');
posY0=position(2)+position(4);
posX0=position(1);
posY=posY0-0.05;
posX=posX0+0.01;
handles.compText=uicontrol('Style', 'text', 'String', 'Components: ','units','normalized','Position',[posX posY 0.1 0.02]);


%update compText
% function handles=compText_update(handles)
% position=get(handles.panel,'position');
% posX0=position(1);
% sliderDistX=get(handles.slider2,'UserData');
% posX=posX0+50-sliderDistX;
% position=get(handles.compText,'position');
% position(1)=posX;
% set(handles.compText,'position',position);
% if(posX<40 || posX>1020)
%     set(handles.compText,'visible','off');     %make visible if image is visible
% else
%     set(handles.compText,'visible','on');      %make unvisible if image is unvisible
% end

%create StratText
function handles=StratText_create(handles)
position=get(handles.panel,'position');
posY0=position(2)+position(4);
posX0=position(1);
posY=posY0-0.08;
posX=posX0+0.01;
handles.StratText=uicontrol('Style', 'text', 'String', 'Strategies: ','units','normalized','Position',[posX posY 0.1 0.02]);


%update StratText
% function handles=StratText_update(handles)
% position=get(handles.panel,'position');
% posX0=position(1);
% sliderDistX=get(handles.slider2,'UserData');
% posX=posX0+50-sliderDistX;
% position=get(handles.StratText,'position');
% position(1)=posX;
% set(handles.StratText,'position',position);
% if(posX<40 || posX>1020)
%     set(handles.StratText,'visible','off');     %make visible if image is visible
% else
%     set(handles.StratText,'visible','on');      %make unvisible if image is unvisible
% end

%update strategytext
% componentDistance=0.07;
% position=get(handles.panel,'position');
% posY0=position(2)+position(4);
% posX0=position(1)+0.05;
% posY=posY0-0.08;
% for co=1:handles.Session.numComp
%     posX=posX0+(co*componentDistance);
%     handles.componenttext{co}=uicontrol('Style', 'text','units','normalized', 'String', [' ID: ',num2str(handles.Session.componentList{co}.ComponentID)],'Position', [posX posY 0.02 0.05]);
% end

function handles=strategytext_create(handles)
componentDistance=0.07;
position=get(handles.panel,'position');
posY0=position(2)+position(4);
posX0=position(1)+0.03;
posY=posY0-0.08;
for co=1:handles.Session.numComp
    posX=posX0+(co*componentDistance);
    st1=class(handles.Session.componentList{co}.strategy);
    if(size(st1,2)<14)
        string=[st1,'.'];
    else
        string=[st1(1:14),'.'];
    end
    handles.strategytext{co}=uicontrol('Style', 'text', 'String', string,'units','normalized','FontSize',8,'Position', [posX posY 0.07 0.02]);
end

% posY=posY0-0.08;
% posX=posX0+0.01;
% handles.StratText=uicontrol('Style', 'text', 'String', 'Strategies: ','units','normalized','Position',[posX posY 0.1 0.02]);


% update strategytext
function handles=strategytext_update(handles)
sliderDistX=get(handles.slider2,'UserData');
componentDistance=0.07;
position=get(handles.panel,'position');
posX0=position(1)+0.03;
for co=1:handles.Session.numComp
    vis=get(handles.componenttext{co},'visible');
    if(strcmp(vis,'off'))
        set(handles.strategytext{co},'visible','off');     %make visible if image is visible
    else
        set(handles.strategytext{co},'visible','on');      %make unvisible if image is unvisible
    end
    posX=posX0+(co*componentDistance)-sliderDistX;
    position=get(handles.strategytext{co},'position');
    position(1)=posX;
    %posY=position(2);
    set(handles.strategytext{co},'position',position);

end

%create imageAxesName
function handles=imageAxesName_create(handles)
handles.imageName=[];
for im=1:handles.Session.numImages
    posIm=get(handles.images{im},'position');
    posX=posIm(1)-0.025;
    posY=posIm(2)-0.025;
    if(size(handles.Session.imageList{im}.name,2)<14)
        Iname=handles.Session.imageList{im}.name;
    else
        Iname=handles.Session.imageList{im}.name;
        Iname=[Iname(1:14),'.'];
    end
    handles.imageName{im}=uicontrol('Style', 'Text','units','normalized', 'Position', [posX posY 0.1 0.02],'String',[num2str(im),'. ',Iname]);
    if(isempty(get(handles.images{im},'UserData')))
        set(handles.imageName{im},'visible','off');     %make visible if image is visible
    else
        set(handles.imageName{im},'visible','on');      %make unvisible if image is unvisible
    end
end
    
    
%update image name depending on slider and visibility of the image
function handles=imageAxesName_update(handles)
for im=1:handles.Session.numImages
    posIm=get(handles.images{im},'position');
    posX=posIm(1)-0.025;
    posY=posIm(2)-0.025;
    set(handles.imageName{im},'position',[posX posY 0.1 0.02]);     %update position of the image name depending on image position

    if(isempty(get(handles.images{im},'UserData')))
        set(handles.imageName{im},'visible','off');     %make visible if image is visible
    else
        set(handles.imageName{im},'visible','on');      %make unvisible if image is unvisible
    end
end


%create checkbox array
function handles=checkboxArray_create(handles)
handles.checkbox=[];
sliderDistX=0;
sliderDistY=0;
componentDistance=0.07;
position=get(handles.panel,'position');
posX0=position(1)+0.055;
posY0=position(2)+position(4)-0.1;
diffY=0.1;
for im=1:handles.Session.numImages
    posY=posY0+sliderDistY-im*diffY;
    for co=1:handles.Session.numComp
        if(handles.Session.imageList{im}.componentList{co}.active)  %if component was already searched in image checkbox is disable
            CompEnable='off';
            value=1;
        else
            CompEnable='on';
            value=0;
        end
        posX=posX0+(co*componentDistance);
        handles.checkbox{im}{co}=uicontrol('Style', 'checkbox','units','normalized', 'Position', [posX posY 0.1 0.1],'enable',CompEnable,'Value',value);   %create checkbox-array
        set(handles.checkbox{im}{co},'UserData',[im,co]);
           
        vis=get(handles.componenttext{co},'visible');
        if(isempty(get(handles.images{im},'UserData')) || strcmp(vis,'off'))
            set(handles.checkbox{im}{co},'visible','off');     %make visible if image is visible
        else
            set(handles.checkbox{im}{co},'visible','on');      %make unvisible if image is unvisible
        end
            
    end
end


%update checkbox array
function handles=checkboxArray_update(handles)
sliderDistX=get(handles.slider2,'UserData');
sliderDistY=get(handles.slider1,'UserData');
position=get(handles.panel,'position');
posX0=position(1)+0.055;
componentDistance=0.07;
diffY=0.1;
posY0=position(2)+position(4)-0.1;
for im=1:handles.Session.numImages
    posY=posY0+sliderDistY-im*diffY;
    for co=1:handles.Session.numComp
        posX=posX0+(co*componentDistance)-sliderDistX;
        
        %for co=1:handles.Session.numComp
    %posX=posX0+(co*componentDistance)-sliderDistX;
        vis=get(handles.componenttext{co},'visible');
        %|| posX<0.12 || posX>0.85
        if(isempty(get(handles.images{im},'UserData')) || strcmp(vis,'off'))
            set(handles.checkbox{im}{co},'visible','off');     %make visible if image is visible
        else
            set(handles.checkbox{im}{co},'visible','on');      %make unvisible if image is unvisible
        end        
        
        if(handles.Session.imageList{im}.componentList{co}.active)  %if component was already searched in image checkbox is disable
            CompEnable='off';
            value=1;
        else
            CompEnable='on';
            value=0;
        end
        
        
        set(handles.checkbox{im}{co},'position',[posX posY 0.1 0.1]);
        

            
    end
end


    
%create checkbox All
function handles=checkboxAll_create(handles)
componentDistance=0.07;
position=get(handles.panel,'position');
posX0=position(1)+0.055;
posY=position(2)+position(4)-0.12;
handles.checkboxAll=[];
for co=1:handles.Session.numComp
    numIm=0;
    for im=1:handles.Session.numImages      
        if(handles.Session.imageList{im}.componentList{co}.active)  %if component was already searched in image checkbox is disable
            numIm=numIm+1;
        end
    end
    if(numIm==handles.Session.numImages && handles.Session.numImages>0)        % checkbox is disable if component is active in all images
        value=1;
        CompEnable='off';
    else
        value=0;
        CompEnable='on';
    end
    %posComp=get(handles.componenttext{co},'position');
    posX=posX0+(componentDistance*co);
    handles.checkboxAll{co}=uicontrol('Style', 'checkbox','units','normalized', 'Position', [posX posY 0.03 0.03],'enable',CompEnable,'Userdata',co,'Value',value,'Callback',  {@checkboxAll_Callback, handles});
    if(handles.Session.numImages==0)
        set(handles.checkboxAll{co},'visible','off');
    end
end


%update checkboxAll
function handles=checkboxAll_update(handles)
sliderDistX=get(handles.slider2,'UserData');
componentDistance=0.07;
position=get(handles.panel,'position');
posX0=position(1)+0.055;
posY=position(2)+position(4)-0.12;
for co=1:handles.Session.numComp
    CompEnable='off';
    value=1;
    for im=1:handles.Session.numImages      
        if(~handles.Session.imageList{im}.componentList{co}.active)  %if component was already searched in image checkbox is disable
            CompEnable='on';
            value=0;
        end
    end
    posX=posX0+(componentDistance*co)-sliderDistX;
    posImage=get(handles.images{im},'position');
    set(handles.checkboxAll{co},'position',[posX posY 0.03 0.03]);
    set(handles.checkboxAll{co},'enable',CompEnable);
    set(handles.checkboxAll{co},'Value',value);
    
    vis=get(handles.componenttext{co},'visible');
    if(strcmp(vis,'off'))
        set(handles.checkboxAll{co},'visible','off');     %make visible if image is visible
    else
             %make unvisible if image is unvisible
        if(handles.Session.numImages==0)
            set(handles.checkboxAll{co},'visible','off');
        else
            set(handles.checkboxAll{co},'visible','on'); 
        end
    end

end    


%create executeAll button
function handles=executeAllButton_create(handles) 
handles.executeAllbutton=[];
if(~isempty(handles.checkboxAll))
    posComp=get(handles.checkboxAll{end},'position');
    posX=posComp(1)+0.07;
    posY=posComp(2);
    handles.executeAllbutton=uicontrol('units','normalized','Style', 'pushbutton', 'String','Execute all','Position', [posX posY 0.07 0.035],'Callback',  {@executeAllbutton_Callback, handles});
end
if(handles.Session.numImages==0)
    set(handles.executeAllbutton,'visible','off');
else
    set(handles.executeAllbutton,'visible','on'); 
end


% execute Allbutton
function handles=executeAllButton_update(handles)
posComp=get(handles.checkboxAll{end},'position');
posX=posComp(1)+0.07;
posY=posComp(2);
set(handles.executeAllbutton,'position',[posX posY 0.07 0.035]);
if(posX<0.12 || posX>0.9)
    set(handles.executeAllbutton,'visible','off');     %make visible if image is visible
else
    if(handles.Session.numImages==0)
        set(handles.executeAllbutton,'visible','off');
    else
        set(handles.executeAllbutton,'visible','on'); 
    end
end     

%create execute button
function handles=executeButton_create(handles)
%diffY=0.1;
%position=get(handles.panel,'position');
%posY0=position(2)+position(4)-0.01;
%sliderDistY=0;
for im=1:handles.Session.numImages
    %posY=posY0+sliderDistY-im*diffY;
    posComp=get(handles.checkboxAll{end},'position');
    posImage=get(handles.images{im},'position');
    posX=posComp(1)+0.07;
    posY=posImage(2)+0.01;
    handles.executebutton{im}=uicontrol('units','normalized','Style', 'pushbutton', 'String','Execute','Position', [posX posY 0.07 0.035],'Callback',  {@executebutton_Callback, handles});
    set(handles.executebutton{im},'UserData',im);
%     if(posX<40 || posX>1020 || posY>400 || posY < 80)
%         set(handles.executebutton{im},'visible','off');     %make visible if image is visible
%     else
%         set(handles.executebutton{im},'visible','on');      %make unvisible if image is unvisible
%     end
    if(isempty(get(handles.images{im},'UserData')))
        set(handles.executebutton{im},'visible','off');     %make visible if image is visible
    else
        set(handles.executebutton{im},'visible','on');      %make unvisible if image is unvisible
    end      
end


%update execute button
function handles=executeButton_update(handles)
%diffY=0.1;
%position=get(handles.panel,'position');
%posY0=position(2)+position(4)-0.01;
%sliderDistX=get(handles.slider2,'UserData');
for im=1:handles.Session.numImages
    posComp=get(handles.checkboxAll{end},'position');
    posImage=get(handles.images{im},'position');
    posX=posComp(1)+0.07;
    posY=posImage(2)+0.01;
    if(isempty(get(handles.images{im},'UserData')) || posX<0.12 || posX>0.9)
        set(handles.executebutton{im},'visible','off');     %make visible if image is visible
    else
        set(handles.executebutton{im},'visible','on');      %make unvisible if image is unvisible
    end 
    

    set(handles.executebutton{im},'position',[posX posY 0.07 0.035]);
    
%     if(posX<40 || posX>1020 || posY>400 || posY < 80)
%         set(handles.executebutton{im},'visible','off');     %make visible if image is visible
%     else
%         set(handles.executebutton{im},'visible','on');      %make unvisible if image is unvisible
%     end
   
end


%update popups
function handles=popup_update(handles)
%diffY=70;
%posY0=470;
%sliderDistY=get(handles.slider1,'UserData');
for im=1:handles.Session.numImages
    
    posComp=get(handles.executebutton{end},'position');
    posexe=get(handles.images{im},'position');
    posX=posComp(1)+0.08;
    posY=posexe(2)+0.01;
    
    if(isempty(get(handles.images{im},'UserData')) || posX<0.12 || posX>0.87)
        set(handles.popup{im},'visible','off');     %make visible if image is visible
    else
        set(handles.popup{im},'visible','on');      %make unvisible if image is unvisible
    end
    

    
    cell_var=[];
    cell_var{1}='...';
    for co=1:handles.Session.imageList{im}.numComp
        if(handles.Session.imageList{im}.componentList{co}.active)
           cell_var{end+1} = [handles.Session.imageList{im}.componentList{co}.name];
        end
    end
    set(handles.popup{im},'position',[posX posY 0.1 0.033]);
    set(handles.popup{im},'String',cell_var);


end

    
% create popups
function handles=popup_create(handles)
for im=1:handles.Session.numImages
%     posImage=get(handles.images{im},'position');
%     posexe=get(handles.executebutton{im},'position');
%     posX=posexe(1)+150;
%     posY=posImage(2)+10;
    
    posComp=get(handles.executebutton{end},'position');
    posexe=get(handles.images{im},'position');
    posX=posComp(1)+0.08;
    posY=posexe(2)+0.01;
    
    cell_var=[];
    cell_var{1}='...';
    for co=1:handles.Session.imageList{im}.numComp
        if(handles.Session.imageList{im}.componentList{co}.active)
            cell_var{end+1} = [handles.Session.imageList{im}.componentList{co}.name];
        end
    end
    handles.popup{im}=uicontrol('units','normalized','Style', 'popupmenu', 'String',cell_var,'Position', [posX posY 0.1 0.033],'Callback',  {@popup_Callback, handles});
    set(handles.popup{im},'UserData',im);
    if(isempty(get(handles.images{im},'UserData')) || posX<0.12 || posX>0.87)
        set(handles.popup{im},'visible','off');     %make visible if image is visible
    else
        set(handles.popup{im},'visible','on');      %make unvisible if image is unvisible
    end
   
end
    
    
%update show buttons
function handles=showbutton_update(handles)
%diffY=70;
%posY0=470;
%sliderDistY=get(handles.slider1,'UserData');
for im=1:handles.Session.numImages
%     posY=posY0+sliderDistY-im*diffY;
%     posComp=get(handles.popup{end},'position');
%     %posImage=get(handles.images{im},'position');
%     posX=posComp(1)+180;
    posComp=get(handles.popup{end},'position');
    posexe=get(handles.images{im},'position');
    posX=posComp(1)+0.11;
    posY=posexe(2)+0.01;
    if(isempty(get(handles.images{im},'UserData')) || posX<0.12 || posX>0.9)
        set(handles.showbutton{im},'visible','off');     %make visible if image is visible
    else
        set(handles.showbutton{im},'visible','on');      %make unvisible if image is unvisible
    end

    set(handles.showbutton{im},'position',[posX posY 0.07 0.035]);
    

end       


%create show buttons
function handles=showbutton_create(handles)
%diffY=70;
%posY0=470;
%sliderDistY=0;
for im=1:handles.Session.numImages
    %posY=posY0+sliderDistY-im*diffY;
    %posComp=get(handles.popup{end},'position');
    %posImage=get(handles.images{im},'position');
    %posX=posComp(1)+180;
    %posY=posImage(2)+10;
    posComp=get(handles.popup{end},'position');
    posexe=get(handles.images{im},'position');
    posX=posComp(1)+0.11;
    posY=posexe(2)+0.01;
    
    handles.showbutton{im}=uicontrol('units','normalized','Style', 'pushbutton', 'String','Show','Position', [posX posY 0.07 0.035],'Callback',  {@showbutton_Callback, handles});
    set(handles.showbutton{im},'UserData',im);
    if(isempty(get(handles.images{im},'UserData')) || posX<0.12 || posX>0.9)
        set(handles.showbutton{im},'visible','off');     %make visible if image is visible
    else
        set(handles.showbutton{im},'visible','on');      %make unvisible if image is unvisible
    end
end        


% --- Executes on button press in showID.
function showID_Callback(hObject, eventdata, handles)
web('ID-List/ID-List.html')


% --- Executes during object creation, after setting all properties.
function showID_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.46 0.92 0.08 0.05]);
set(hObject,'visible','off');


% show ID
function showID_update(handles)
if(isfield(handles,'Session'))
    set(handles.showID,'visible','on');
else
    set(handles.showID,'visible','off');
end


% update slider1
function slider1_update(handles)
value=get(handles.slider1,'Value');
if(isfield(handles,'images'))
    position=get(handles.images{end},'position');
    posMinY=position(2);
    position=get(handles.images{1},'position');
    posMaxY=position(2);
    %posDist=abs(posMaxY-posMinY)-200;
    posDist=abs(posMaxY-posMinY)-0.6;
    sliderDist=(1-value)*posDist;
else
    sliderDist=0;
end
set(handles.slider1,'UserData',sliderDist);


%update searchbutton
function searchbutton7_update(handles)
if(isfield(handles,'Session'));
    set(handles.searchbutton7,'visible','on');
else
    set(handles.searchbutton7,'visible','off');
end


%delete Images of a session
function DeleteImages_Callback(hObject, eventdata, handles)
Session=handles.Session;
close(handles.figure1); 
GUIdelete(Session);


% create DeleteImages
function DeleteImages_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.66 0.92 0.1 0.05]);
set(hObject,'visible','off');


function handles=DeleteImages_update(handles)
if(isfield(handles,'Session'))
    set(handles.DeleteImages,'visible','on');
else
    set(handles.DeleteImages,'visible','off');
end


% create label2
function label2_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.9 0.9 0.08 0.08]);
if(strcmp(getenv('OS'),'Windows_NT'))
    pa=userpath;
    label =imread([pa(1:end-1),'\SearchPart\label.png']);
else
    pa=pwd;
    label =imread([pa,'/SearchPart/label.png']);
end
imshow(label);
pause(0.1);

% slider2 Callback
function slider2_Callback(hObject, eventdata, handles)

slider2_update(handles);
pause(0.1);
%handles=compText_update(handles);
%handles=StratText_update(handles);
handles=componenttext_update(handles);
handles=strategytext_update(handles);
handles=checkboxAll_update(handles);
handles=imageAxes_update(handles);
handles=imageAxesName_update(handles);
handles=checkboxArray_update(handles);
handles=executeAllButton_update(handles);
handles=executeButton_update(handles);
handles=popup_update(handles);
handles=showbutton_update(handles);
guidata(handles.figure1,handles);


% create slider2
function slider2_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.01 0.01 0.97 0.03]);
%set(hObject,'Position',[0.94 0.01 0.05 0.85]);
set(hObject,'value',0)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'UserData',0);


% update slider2
function slider2_update(handles)
value=get(handles.slider2,'Value');
%position=get(handles.showbutton{1},'position');
%posMaxX=position(1);

position=get(handles.panel,'position');
posX0=position(1)+0.055;
componentDistance=0.07;
posMaxX=posX0+(handles.Session.numComp*componentDistance)+0.3;
if(isfield(handles,'images'))
    position=get(handles.images{1},'position');
    posMinX=position(1);
%posDist=abs(posMaxX-posMinX)-920;
    posDist=abs(posMaxX-posMinX)-0.87;

    if(posMaxX>0.9)
        sliderDist=(value)*posDist;
    else
        sliderDist=0;
    end
else
    sliderDist=0;
end


set(handles.slider2,'UserData',sliderDist);


% --- Executes on button press in Aboutbutton.
function Aboutbutton_Callback(hObject, eventdata, handles)
GUIabout(); 
% hObject    handle to Aboutbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function Aboutbutton_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.56 0.92 0.08 0.05]);
set(hObject,'visible','off');
% hObject    handle to Aboutbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function Aboutbutton_update(handles)
if(isfield(handles,'Session'))
    set(handles.Aboutbutton,'visible','on');
else
    set(handles.Aboutbutton,'visible','off');
end


% --- Executes during object creation, after setting all properties.
function searchbutton7_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.26 0.92 0.08 0.05]);


% --- Executes during object creation, after setting all properties.
function savebutton_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.16 0.92 0.08 0.05]);
set(hObject,'visible','off');

function savebutton_update(handles)
if(isfield(handles,'Session'))
    set(handles.savebutton,'visible','on');
else
    set(handles.savebutton,'visible','off');
end


% --- Executes during object creation, after setting all properties.
function selectFolderbutton_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.45 0.92 0.1 0.05]);
set(hObject, 'String','Select images');


% --- Executes during object creation, after setting all properties.
function closebutton_CreateFcn(hObject, eventdata, handles)
set(hObject, 'units','normalized');
set(hObject,'Position',[0.78 0.92 0.08 0.05]);
set(hObject,'visible','off');

function closebutton_update(handles)
if(isfield(handles,'Session'))
    set(handles.closebutton,'visible','on');
else
    set(handles.closebutton,'visible','off');
end
