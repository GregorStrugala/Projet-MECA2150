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

% Last Modified by GUIDE v2.5 12-Dec-2016 23:12:20

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



function Pe_ENTRY_Callback(hObject, eventdata, handles)
% hObject    handle to Pe_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pe_ENTRY as text
%        str2double(get(hObject,'String')) returns contents of Pe_ENTRY as a double


% --- Executes during object creation, after setting all properties.
function Pe_ENTRY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pe_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ta_ENTRY_Callback(hObject, eventdata, handles)
% hObject    handle to Ta_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ta_ENTRY as text
%        str2double(get(hObject,'String')) returns contents of Ta_ENTRY as a double


% --- Executes during object creation, after setting all properties.
function Ta_ENTRY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ta_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tf_ENTRY_Callback(hObject, eventdata, handles)
% hObject    handle to Tf_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tf_ENTRY as text
%        str2double(get(hObject,'String')) returns contents of Tf_ENTRY as a double


% --- Executes during object creation, after setting all properties.
function Tf_ENTRY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tf_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r_ENTRY_Callback(hObject, eventdata, handles)
% hObject    handle to r_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r_ENTRY as text
%        str2double(get(hObject,'String')) returns contents of r_ENTRY as a double


% --- Executes during object creation, after setting all properties.
function r_ENTRY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kcc_ENTRY_Callback(hObject, eventdata, handles)
% hObject    handle to kcc_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kcc_ENTRY as text
%        str2double(get(hObject,'String')) returns contents of kcc_ENTRY as a double


% --- Executes during object creation, after setting all properties.
function kcc_ENTRY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kcc_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function etaC_ENTRY_Callback(hObject, eventdata, handles)
% hObject    handle to etaC_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etaC_ENTRY as text
%        str2double(get(hObject,'String')) returns contents of etaC_ENTRY as a double


% --- Executes during object creation, after setting all properties.
function etaC_ENTRY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etaC_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function etaT_ENTRY_Callback(hObject, eventdata, handles)
% hObject    handle to etaT_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etaT_ENTRY as text
%        str2double(get(hObject,'String')) returns contents of etaT_ENTRY as a double


% --- Executes during object creation, after setting all properties.
function etaT_ENTRY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etaT_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kmec_ENTRY_Callback(hObject, eventdata, handles)
% hObject    handle to kmec_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kmec_ENTRY as text
%        str2double(get(hObject,'String')) returns contents of kmec_ENTRY as a double


% --- Executes during object creation, after setting all properties.
function kmec_ENTRY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kmec_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fuel_ENTRY_Callback(hObject, eventdata, handles)
% hObject    handle to fuel_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fuel_ENTRY as text
%        str2double(get(hObject,'String')) returns contents of fuel_ENTRY as a double


% --- Executes during object creation, after setting all properties.
function fuel_ENTRY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fuel_ENTRY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start_PB.
function start_PB_Callback(hObject, eventdata, handles)
% hObject    handle to start_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
