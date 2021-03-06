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

% Last Modified by GUIDE v2.5 20-Dec-2016 21:02:24

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

function [Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,fuel] = inputArgs(handles)
Pe = str2double(get(handles.Pe_ENTRY,'String'));
Ta = str2double(get(handles.Ta_ENTRY,'String'));
Tf = str2double(get(handles.Tf_ENTRY,'String'));
r = str2double(get(handles.r_ENTRY,'String'));
kcc = str2double(get(handles.kcc_ENTRY,'String'));
etaC = str2double(get(handles.etaC_ENTRY,'String'));
etaT = str2double(get(handles.etaT_ENTRY,'String'));
kmec = str2double(get(handles.kmec_ENTRY,'String'));
fuel = get(handles.fuel_ENTRY,'String');

% --- Executes on button press in exPie_PB.
function exPie_PB_Callback(hObject, eventdata, handles)
% hObject    handle to exPie_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,fuel] = inputArgs(handles);
gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,{'ExPie'},fuel);


% --- Executes on button press in enPie_PB.
function enPie_PB_Callback(hObject, eventdata, handles)
% hObject    handle to enPie_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,fuel] = inputArgs(handles);
gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,{'EnPie'},fuel);


% --- Executes on button press in ts_PB.
function ts_PB_Callback(hObject, eventdata, handles)
% hObject    handle to ts_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,fuel] = inputArgs(handles);
gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,{'ts'},fuel);

% --- Executes on button press in hs_PB.
function hs_PB_Callback(hObject, eventdata, handles)
% hObject    handle to hs_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,fuel] = inputArgs(handles);
gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,{'hs'},fuel);


% --- Executes on button press in dispFlowRates_PB.
function dispFlowRates_PB_Callback(hObject, eventdata, handles)
% hObject    handle to dispFlowRates_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,fuel] = inputArgs(handles);
[~,mg,~,~,~,~,~,ma,mc] = gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,{},fuel);
set(handles.ma_ST,'string',[num2str(ma) ' kg/s']);
set(handles.mc_ST,'string',[num2str(mc) ' kg/s']);
set(handles.mg_ST,'string',[num2str(mg) ' kg/s']);

% --- Executes on button press in clearFlowRates_PB.
function clearFlowRates_PB_Callback(hObject, eventdata, handles)
% hObject    handle to clearFlowRates_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ma_ST,'string','-');
set(handles.mc_ST,'string','-');
set(handles.mg_ST,'string','-');


% --- Executes on button press in dispState_PB.
function dispState_PB_Callback(hObject, eventdata, handles)
% hObject    handle to dispState_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,fuel] = inputArgs(handles);
state = gasTurbine(Pe,Ta,Tf,r,kcc,etaC,etaT,kmec,{},fuel);
Array = (reshape(struct2array(state),5,4))';
set(handles.stateTable, 'Data', Array, 'ColumnName', {'p [bar]', 'T [�C]', 'h [kJ/kg]', 's [kJ/(kgK)]', 'e [kJ/kg]'});


% --- Executes on button press in clearState_PB.
function clearState_PB_Callback(hObject, eventdata, handles)
% hObject    handle to clearState_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.stateTable, 'Data', cell(size(get(handles.stateTable,'Data'))));
