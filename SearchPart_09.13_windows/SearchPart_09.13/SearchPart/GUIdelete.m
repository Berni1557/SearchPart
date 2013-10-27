%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = GUIdelete(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIdelete_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIdelete_OutputFcn, ...
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


% --- Executes just before GUIdelete is made visible.
function GUIdelete_OpeningFcn(hObject, eventdata, handles, varargin)    %input: varargin{1}='load', varargin{2}='on'/'off'
handles.Session=varargin{1};
load('SearchPartVersion','SearchPartVersion');                  %load version
set(hObject,'Name',SearchPartVersion);
handles=imageAxes_create(handles);
handles=imageAxesName_create(handles);
handles=deleteButton_create(handles);
handles.output = hObject;

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = GUIdelete_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


%delete button Calback function
function deleteButton_Callback(hObject, eventdata,handles)
f=guidata(handles.figure1);
[Session,handles]=handles.Session.deleteImages(hObject,f);
handles.Session=Session;
handles=imageAxes_update(handles);
handles=imageAxesName_update(handles);
handles=deleteButton_update(handles);
guidata(handles.figure1, handles);


% Callback slider1
function slider1_Callback(hObject, eventdata, handles)
pause(0.1);
handles=imageAxes_update(handles);
handles=imageAxesName_update(handles);
handles=deleteButton_update(handles);
guidata(hObject, handles);


% create slider1
function slider1_CreateFcn(hObject, eventdata, handles)
set(hObject,'value',1)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%load Session and updates figures
function handles=loadSession(handles)      
directoryname=get(handles.selectFolderbutton,'Userdata');    
if(~isfield(handles,'Session'))          %create Session if Session doesn't exist
    Session=SearchD(directoryname);
    handles.Session=Session;
end
handles=imageAxes_create(handles);          %update handles
handles=imageAxesName_create(handles);
handles=deleteButton_create(handles);


%create imageAxes
function handles=imageAxes_create(handles)
handles.images=[];
posY0=550;                                          %set fix start position
posX0=420;
diffY=120;
for im=1:handles.Session.numImages
    posY=posY0-im*diffY;
    handles.images{im} = axes('Units','pixels','Position', [posX0 posY 100 100],'YTickLabel',[]);
    I=handles.Session.imageList{im}.image;
    imshow(I);
    set(handles.images{im},'NextPlot','replacechildren')
    set(handles.images{im},'UserData',I);
    if(posY > 450 || posY < 60)                         %make images invisible if position is out of range
        set(handles.images{im},'visible','off');
        cla(handles.images{im});
        set(handles.images{im},'UserData',[]);
    else
        imshow(handles.Session.imageList{im}.image,'Parent',handles.images{im});
        set(handles.images{im},'UserData',handles.Session.imageList{im}.image);
    end
end

%update imageAxes
function handles=imageAxes_update(handles)
slider1_update(handles);
sliderDist=get(handles.slider1,'UserData');  
posY0=550;
posX0=420;
diffY=120;
for im=1:handles.Session.numImages
    posY=posY0+sliderDist-im*diffY; 
    set(handles.images{im},'position',[posX0 posY 100 100]);
    if(posY > 450 || posY < 60)
        set(handles.images{im},'visible','off');
        cla(handles.images{im});
        set(handles.images{im},'UserData',[]);
    else
        imshow(handles.Session.imageList{im}.image,'Parent',handles.images{im});
        set(handles.images{im},'UserData',handles.Session.imageList{im}.image);
    end
end


%create imageAxesName
function handles=imageAxesName_create(handles)
handles.imageName=[];
for im=1:handles.Session.numImages
    posIm=get(handles.images{im},'position');
    posX=posIm(1)-40;
    posY=posIm(2)-20;
    handles.imageName{im}=uicontrol('Style', 'Text', 'Position', [posX posY 170 20],'String',['Nr.:',num2str(im),' ',handles.Session.imageList{im}.name]);
end
    
    
%update imageAxesName
function handles=imageAxesName_update(handles)
for im=1:handles.Session.numImages
    posIm=get(handles.images{im},'position');
    posX=posIm(1)-40;
    posY=posIm(2)-20;
    set(handles.imageName{im},'position',[posX posY 170 20]);     %update position of the image name depending on image position
    set(handles.imageName{im},'String',['Nr.:',num2str(im),' ',handles.Session.imageList{im}.name]);
    if(isempty(get(handles.images{im},'UserData')))
        set(handles.imageName{im},'visible','off');     %make visible if image is visible
    else
        set(handles.imageName{im},'visible','on');      %make unvisible if image is unvisible
    end
end
    
    
%update delete buttons
function handles=deleteButton_update(handles)
for im=1:handles.Session.numImages
    posImage=get(handles.images{im},'position');
    posX=600;
    posY=posImage(2)+30;
    set(handles.deleteButton{im},'position',[posX posY 100 25]);
    set(handles.deleteButton{im},'UserData',im)
    if(isempty(get(handles.images{im},'UserData')))
        set(handles.deleteButton{im},'visible','off');     %make visible if image is visible
    else
        set(handles.deleteButton{im},'visible','on');      %make unvisible if image is unvisible
    end
end       

%create delete buttons
function handles=deleteButton_create(handles)
for im=1:handles.Session.numImages
    posImage=get(handles.images{im},'position');
    posX=600;
    posY=posImage(2)+30;
    handles.deleteButton{im}=uicontrol('Units','pixels','Style', 'pushbutton', 'String','Delete','Position', [posX posY 100 25],'Callback',  {@deleteButton_Callback, handles});
    set(handles.deleteButton{im},'UserData',im);
    if(isempty(get(handles.images{im},'UserData')))
        set(handles.deleteButton{im},'visible','off');     %make visible if image is visible
    else
        set(handles.deleteButton{im},'visible','on');      %make unvisible if image is unvisible
    end
end        

% update slider1 (slider top <-> bottom)
function slider1_update(handles)
value=get(handles.slider1,'Value');
position=get(handles.images{end},'position');
posMinY=position(2);
position=get(handles.images{1},'position');
posMaxY=position(2);
posDist=abs(posMaxY-posMinY)-200;
sliderDist=(1-value)*posDist;
set(handles.slider1,'UserData',sliderDist);


% --- Executes on button press in closeButton.
function closeButton_Callback(hObject, eventdata, handles)
close(handles.figure1); 
GUIsearchInImages('load',handles.Session);


% --- Executes during object creation, after setting all properties.
function panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function label1_CreateFcn(hObject, eventdata, handles)
path=pwd;
label =imread([path,'/label/label.jpg']);
imshow(label);
pause(0.1);


% --- Executes during object creation, after setting all properties.
function label2_CreateFcn(hObject, eventdata, handles)
path=pwd;
label =imread([path,'/label/label.jpg']);
imshow(label);
pause(0.1);
