function varargout = combinedGUI(varargin)
% COMBINEDGUI MATLAB code for combinedGUI.fig
%      COMBINEDGUI, by itself, creates a new COMBINEDGUI or raises the existing
%      singleton*.
%
%      H = COMBINEDGUI returns the handle to a new COMBINEDGUI or the handle to
%      the existing singleton*.
%
%      COMBINEDGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMBINEDGUI.M with the given input arguments.
%
%      COMBINEDGUI('Property','Value',...) creates a new COMBINEDGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before combinedGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to combinedGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help combinedGUI

% Last Modified by GUIDE v2.5 19-Dec-2016 15:10:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @combinedGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @combinedGUI_OutputFcn, ...
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


% --- Executes just before combinedGUI is made visible.
function combinedGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to combinedGUI (see VARARGIN)

% Choose default command line output for combinedGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes combinedGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = combinedGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in TwoP_PB.
function TwoP_PB_Callback(hObject, eventdata, handles)
% hObject    handle to TwoP_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
combined2PGUI
close combinedGUI


% --- Executes on button press in ThreeP_PB.
function ThreeP_PB_Callback(hObject, eventdata, handles)
% hObject    handle to ThreeP_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
combined3PGUI
close combinedGUI


% --- Executes on button press in cycleSelection.
function cycleSelection_Callback(hObject, eventdata, handles)
% hObject    handle to cycleSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
main
close combinedGUI
