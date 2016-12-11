function varargout = gasTurbineGUI(varargin)
% GASTURBINEGUI MATLAB code for gasTurbineGUI.fig
%      GASTURBINEGUI, by itself, creates a new GASTURBINEGUI or raises the existing
%      singleton*.
%
%      H = GASTURBINEGUI returns the handle to a new GASTURBINEGUI or the handle to
%      the existing singleton*.
%
%      GASTURBINEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GASTURBINEGUI.M with the given input arguments.
%
%      GASTURBINEGUI('Property','Value',...) creates a new GASTURBINEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gasTurbineGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gasTurbineGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gasTurbineGUI

% Last Modified by GUIDE v2.5 11-Dec-2016 23:11:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gasTurbineGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @gasTurbineGUI_OutputFcn, ...
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


% --- Executes just before gasTurbineGUI is made visible.
function gasTurbineGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gasTurbineGUI (see VARARGIN)

% Choose default command line output for gasTurbineGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gasTurbineGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gasTurbineGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cycleSelection_PB.
function cycleSelection_PB_Callback(hObject, eventdata, handles)
% hObject    handle to cycleSelection_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
main
close gasTurbineGUI


% --- Executes on button press in enPie_PB.
function enPie_PB_Callback(hObject, eventdata, handles)
% hObject    handle to enPie_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gasTurbine(230e3, 273.15+15, 1673.15, 18, 0.95, 0.9, 0.9, 0.015,{'EnPie'});
