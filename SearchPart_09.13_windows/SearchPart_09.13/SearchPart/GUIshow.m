%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of SearchPart                                                                                                               %
% Copyright (C) 2013  Bernhard Föllmer                                                                                                          %
% SearchPart is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License                       %
% as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.                         %
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;                                                     %
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.%                                                                                        %
% You should have received a copy of the GNU General Public License alongwith this program; if not, see <http://www.gnu.org/licenses/>.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = GUIshow(varargin)
% GUIshow MATLAB code for GUIshow.fig
%      GUIshow, by itself, creates a new GUIshow or raises the existing
%      singleton*.
%
%      H = GUIshow returns the handle to a new GUIshow or the handle to
%      the existing singleton*.
%
%      GUIshow('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIshow.M with the given input arguments.
%
%      GUIshow('Property','Value',...) creates a new GUIshow or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIshow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIshow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIshow

% Last Modified by GUIDE v2.5 06-Aug-2013 22:32:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIshow_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIshow_OutputFcn, ...
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


% --- Executes just before GUIshow is made visible.
function GUIshow_OpeningFcn(hObject, eventdata, handles, varargin)
load('SearchPartVersion','SearchPartVersion');
set(hObject,'Name',SearchPartVersion);

if(size(varargin,2)==1)
    I=varargin{1};
    imshow(I)
    set(handles.text1,'String','Original Image');
else
    I=varargin{1};
    partList=varargin{2};

    imshow(I)
    hold on;
    for i=1:size(partList,2)
        position=partList{i}.position;
        b=round(position(1,1));
        a=round(position(1,2));

        if(partList{i}.blank==false)
            plot(b,a,'r+','MarkerSize',20);
            text(b,a,partList{i}.value,'FontSize',20);
        else
            plot(b,a,'b+','MarkerSize',20);
        end
    end
    num=size(partList,2);
    t=[num2str(num),' parts found'];
    set(handles.text1,'String',t);
end
% Choose default command line output for GUIshow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIshow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIshow_OutputFcn(hObject, eventdata, handles) 


% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Closebutton.
function Closebutton_Callback(hObject, eventdata, handles)
close(handles.figure1); 



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)



function text1_Callback(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text1 as text
%        str2double(get(hObject,'String')) returns contents of text1 as a double


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
