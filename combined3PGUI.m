function varargout = combined3P(varargin)
% COMBINED3P MATLAB code for combined3P.fig
%      COMBINED3P, by itself, creates a new COMBINED3P or raises the existing
%      singleton*.
%
%      H = COMBINED3P returns the handle to a new COMBINED3P or the handle to
%      the existing singleton*.
%
%      COMBINED3P('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMBINED3P.M with the given input arguments.
%
%      COMBINED3P('Property','Value',...) creates a new COMBINED3P or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before combined3P_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to combined3P_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help combined3P

% Last Modified by GUIDE v2.5 19-Dec-2016 13:18:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @combined3P_OpeningFcn, ...
                   'gui_OutputFcn',  @combined3P_OutputFcn, ...
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


% --- Executes just before combined3P is made visible.
function combined3P_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to combined3P (see VARARGIN)

% Choose default command line output for combined3P
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes combined3P wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = combined3P_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
