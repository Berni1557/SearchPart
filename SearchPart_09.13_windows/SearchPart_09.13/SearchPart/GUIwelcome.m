%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = GUIwelcome(varargin)
%author: Bernhard Föllmer
%Email: SearchPart@yahoo.com
%Description:
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIwelcome_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIwelcome_OutputFcn, ...
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


% --- Executes just before GUIwelcome is made visible.
function GUIwelcome_OpeningFcn(hObject, eventdata, handles, varargin)
set(hObject, 'DeleteFcn', @GUIwelcome_DeleteFcn)
%load SearchPart Version string
load('SearchPartVersion','SearchPartVersion');
set(hObject,'Name',SearchPartVersion);
movegui(hObject,'center');


% Choose default command line output for GUIwelcome
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIwelcome wait for user response (see UIRESUME)
%uiwait(handles.figure1);


function GUIwelcome_DeleteFcn(hObject, eventdata, handles, varargin) 
%quit();

% --- Outputs from this function are returned to the command line.
function varargout = GUIwelcome_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
%load SearchPart Version string
load ('SearchPartVersion','SearchPartVersion');
set(hObject,'String',SearchPartVersion);



% --- Executes during object creation, after setting all properties.
% function label_CreateFcn(hObject, eventdata, handles)
% path=pwd;
% label =imread([path,'/label/label.jpg']);
% imshow(label);
% pause(0.1);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
set(handles.figure1,'visible','off');
GUIsessionQuestion();

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function label1_CreateFcn(hObject, eventdata, handles)
filepath=mfilename('fullpath');
[folder, name, ext] = fileparts(filepath);
label =imread([folder,'/label.png']);
imshow(label);
pause(0.1);
% hObject    handle to label1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate label1
