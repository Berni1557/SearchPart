%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = GUIsearchPart(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIsearchPart_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIsearchPart_OutputFcn, ...
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


% --- Executes just before GUIsearchPart is made visible.
function GUIsearchPart_OpeningFcn(hObject, eventdata, handles, varargin)
if(size(varargin,2)==1)
    handles.Session=varargin{1};
else
    [filename pathname] = uigetfile('*.mat','Pick a Session');      % open a Session
    if(filename~=0)
        file=load(fullfile(pathname,filename));
        if(isfield(file,'Session'))
            fields = fieldnames(file);
            s=fields(1);
            Session = getfield(file, s{1});
            handles.Session=Session;
        end
    end
end
set(hObject,'Name',handles.Session.Version);
popupComponent1_update(handles,hObject);            %update all handles
popupImage2_update(handles,hObject);
popupParts4_update(handles,hObject);
buttonSearch3_update(handles,hObject);
buttonShow4_update(handles,hObject);
Downladbutton_update(handles,hObject);
editValue2_update(handles,hObject);
popupImage2_update(handles,hObject);
blank_button_update(handles,hObject);
set(handles.text4,'String','Done!')

guidata(handles.figure1, handles);
handles.output = hObject;

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = GUIsearchPart_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



% --- Executes on selection change in popupComponent1.
function popupComponent1_Callback(hObject, eventdata, handles)
buttonSearch3_update(handles,hObject);
popupParts4_update(handles,hObject);
buttonShow4_update(handles,hObject);
Downladbutton_update(handles,hObject);
editValue2_update(handles,hObject);
popupImage2_update(handles,hObject);
blank_button_update(handles,hObject);


% --- Executes during object creation, after setting all properties.
function popupComponent1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupImage2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonSearch3.
function buttonSearch3_Callback(hObject, eventdata, handles)    %search Button
set(handles.text4,'String','Searching!');
searchParts(handles);
popupParts4_update(handles,hObject);
buttonShow4_update(handles,hObject);
Downladbutton_update(handles,hObject);
blank_button_update(handles,hObject);
set(handles.text4,'String','Done!');

guidata(handles.figure1, handles);
guidata(hObject, handles);


% buttonShow4 Callback
function buttonShow4_Callback(hObject, eventdata, handles)

partList=get(handles.popupParts4,'UserData');
val=get(handles.popupParts4,'value');
ImageName=partList{val}.ImageName;
ImData=handles.Session.getImagDatabyName(ImageName);
imagepath=[handles.Session.folderName,'/',ImData.imagepath];
Im=imread(imagepath);
partList=get(handles.popupParts4,'UserData');
val=get(handles.popupParts4,'value');
partListshow{1}=partList{val};
GUIshow(Im,partListshow);

guidata(handles.figure1, handles);
guidata(hObject, handles);


% editValue2 Callback
function editValue2_Callback(hObject, eventdata, handles)


% create editValue2
function editValue2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% create text4
function text4_CreateFcn(hObject, eventdata, handles)


% create text5
function text5_CreateFcn(hObject, eventdata, handles)
set(hObject,'visible','off')


% buttonClose5 Callback
function buttonClose5_Callback(hObject, eventdata, handles)
close(handles.figure1);


% popupParts4 Callback
function popupParts4_Callback(hObject, eventdata, handles)
Downladbutton_update(handles,hObject)
blank_button_update(handles,hObject);


% --- Executes during object creation, after setting all properties.
function popupParts4_CreateFcn(hObject, eventdata, handles)
set(hObject,'visible','off');
strlist{1}='Select part';
set(hObject,'String',strlist);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Downladbutton.
function Downladbutton_Callback(hObject, eventdata, handles)
listpart=get(handles.popupParts4,'UserData');
val=get(handles.popupParts4,'Value');
[filename pathname] = uiputfile('*.pdf','Save Datasheet');
if(filename~=0)    
    set(handles.text4,'String','Downloading datasheet!')
    pause(0.1);
    fp=fullfile(pathname,filename);
    fullpath=['"',fp,'"'];
    part=listpart{val};
    [stat]=part.downloadDatasheet(fullpath);
    if(~stat)
        set(handles.text4,'String','Not possible reading datasheet!')
    else
        set(handles.text4,'String','Done!')
    end
else
    set(handles.text4,'String','Path of download is incorrect!')
end


% --- Executes during object creation, after setting all properties.
function Downladbutton_CreateFcn(hObject, eventdata, handles)
set(hObject,'visible','off');


% --- Executes during object creation, after setting all properties.
function buttonShow4_CreateFcn(hObject, eventdata, handles)
set(hObject,'visible','off');


%update Downladbutton
function Downladbutton_update(handles,hand)
str = get(handles.popupParts4, 'Value');
if(~strcmp(get(handles.popupParts4,'String'),'Select part'))
    searchData=get(handles.figure1,'UserData');
    partList=searchData.partList;
    part=partList{str};
    if(part.hasDatasheet)
        set(handles.Downladbutton,'visible','on'); 
    else
        set(handles.Downladbutton,'visible','off'); 
    end
else
    set(handles.Downladbutton,'visible','off'); 
end
if(hand==handles.popupComponent1)
    set(handles.Downladbutton,'visible','off');
end


%update popupParts4
function popupParts4_update(handles,hand)
searchData=get(handles.figure1,'UserData');
if(~isempty(searchData) && ~(hand==handles.popupComponent1))
    partListName=searchData.partListName;
    partList=searchData.partList;
    for i=1:size(partList,2)
        if(partList{i}.blank)
            partListName{i}=[partListName{i},' (b)'];
        end
    end
    searchData.partListName=partListName;
    set(handles.popupParts4,'UserData',partList);
    set(handles.popupParts4,'String',partListName);
    set(handles.popupParts4,'Value',1);
    set(handles.popupParts4,'visible','on');
    set(handles.figure1,'UserData',searchData);
    pause(0.1);
else
    set(handles.popupParts4,'visible','off');
end


%update buttonShow4
function buttonShow4_update(handles,hand)
liststr=get(handles.popupParts4,'String');
str = get(handles.popupParts4, 'Value');
partList = get(handles.popupParts4, 'UserData');
if(strcmp(liststr{1},'Select part') || (hand==handles.popupComponent1))
    set(handles.buttonShow4,'visible','off');
else
    set(handles.buttonShow4,'visible','on');
end


% update text5
function text5_update(handles,hand)
liststr=get(handles.popupParts4,'String');
if(strcmp(liststr,'Select part'))
    set(handles.text5,'String','No parts where found!');
    set(handles.text5,'visible','on');
else
    set(handles.text5,'String',[num2str(size(liststr,2)),' parts where found!']);
    set(handles.text5,'visible','on');
end


% search for parts
function searchParts(handles)
Session=handles.Session;
compList=get(handles.popupComponent1,'UserData');
valComp = get(handles.popupComponent1, 'Value');
component=compList{valComp};
strList=get(handles.popupImage2,'String');
valImage = get(handles.popupImage2, 'Value');
ImageName=strList{valImage};
partName=get(handles.editValue2,'String');
[partList,partListName]=Session.search(ImageName,component.ComponentID,partName);
searchData.partList=partList;
searchData.partListName=partListName;
set(handles.figure1,'UserData',searchData);


%update popupImage2
function popupImage2_update(handles,hand)
Session=handles.Session;
val = get(handles.popupComponent1, 'Value');
compList=get(handles.popupComponent1, 'UserData');
[imageList,imageListName]=Session.getImageswithComnponent(compList{val});
if(size(imageListName,2)==0)
    imageListName{1}='No parts in images';
    set(handles.popupImage2,'String',imageListName);
else
    set(handles.popupImage2,'String',['All',imageListName]);
end


%update buttonSearch3
function buttonSearch3_update(handles,hand)
Session=handles.Session;
val = get(handles.popupComponent1, 'Value');
compList=get(handles.popupComponent1, 'UserData');

PartExist=false;
for im=1:Session.numImages
    if (Session.imageList{im}.componentList{val}.numParts>0)
        PartExist=true;
    end
end

if(PartExist)
    set(handles.buttonSearch3,'visible','on');
    set(handles.text4,'String','Done');
else
    set(handles.buttonSearch3,'visible','off');
    set(handles.text4,'String','No parts of the selected component');
end


% update editValue2
function editValue2_update(handles,hand)
Session=handles.Session;
val = get(handles.popupComponent1, 'Value');
compList = get(handles.popupComponent1, 'UserData');

PartExist=false;
for im=1:Session.numImages
    if (Session.imageList{im}.componentList{val}.numParts>0)
        PartExist=true;
    end
end

if(PartExist)
    set(handles.editValue2,'visible','on');
else
    set(handles.editValue2,'visible','off');
end


% create label
function label_CreateFcn(hObject, eventdata, handles)
path=pwd;
if(strcmp(getenv('OS'),'Windows_NT'))
    pa=userpath;
    label =imread([pa(1:end-1),'\SearchPart\label.png']);
else
    pa=pwd;
    label =imread([pa,'/SearchPart/label.png']);
end
imshow(label);


% blank button Callback
function blank_button_Callback(hObject, eventdata, handles)
Session=handles.Session;
listdata=get(handles.popupParts4,'UserData');
val = get(handles.popupParts4, 'Value');
part=listdata{val};
part.blank=true;
popupParts4_update(handles,hObject);


% update blank button
function blank_button_update(handles,hand)
Session=handles.Session;
var=get(handles.popupParts4,'Value');
partList=get(handles.popupParts4,'UserData');

if(isempty(partList))
    set(handles.blank_button,'visible','off');
else
    part=partList{var};
    if(part.blank==false)
        set(handles.blank_button,'visible','on');
    else
        set(handles.blank_button,'visible','off');
    end
end
if(hand==handles.popupComponent1)
    set(handles.blank_button,'visible','off');
end


% create blank button
function blank_button_CreateFcn(hObject, eventdata, handles)
set(hObject,'visible','off');


% udate of popupComponent1
function popupComponent1_update(handles,hand)
Session=handles.Session;
[CompListName,CompList]=Session.getCompList();
set(handles.popupComponent1,'String',CompListName);
set(handles.popupComponent1,'UserData',CompList);


% --- Executes on selection change in popupImage2.
function popupImage2_Callback(hObject, eventdata, handles)
