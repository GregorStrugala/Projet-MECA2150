function varargout = steamGUI(varargin)
% STEAMGUI MATLAB code for steamGUI.fig
%      STEAMGUI, by itself, creates a new STEAMGUI or raises the existing
%      singleton*.
%
%      H = STEAMGUI returns the handle to a new STEAMGUI or the handle to
%      the existing singleton*.
%
%      STEAMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEAMGUI.M with the given input arguments.
%
%      STEAMGUI('Property','Value',...) creates a new STEAMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before steamGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to steamGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help steamGUI

% Last Modified by GUIDE v2.5 19-Dec-2016 18:46:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @steamGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @steamGUI_OutputFcn, ...
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


% --- Executes just before steamGUI is made visible.
function steamGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to steamGUI (see VARARGIN)

% Choose default command line output for steamGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes steamGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = steamGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function [Tambiant,Triver,deltaT,Tmax,dTpinch,TflueGas,Pe,nF,nR,deGazing,steamPressure,fuel,lambda] = inputArgs(hObject,eventdata,handles)
Tambiant = str2double(get(handles.Tambiant_ET,'string'));
Triver = str2double(get(handles.Triver_ET,'string'));
deltaT = str2double(get(handles.deltaT_ET,'string'));
Tmax = str2double(get(handles.Tmax_ET,'string'));
dTpinch = str2double(get(handles.dTpinch_ET,'string'));
TflueGas = str2double(get(handles.TflueGas_ET,'string'));
Pe = str2double(get(handles.Pe_ET,'string'));
nF = str2double(get(handles.nF_ET,'string'));
nR = str2double(get(handles.nR_ET,'string'));
deGazing = get(handles.deaerator_CB,'Value');
steamPressure = str2double(get(handles.steamPressure_ET,'string'));
fuel = get(handles.fuel_ET,'string');
lambda = str2double(get(handles.lambda_ET,'string'));

function Tambiant_ET_Callback(hObject, eventdata, handles)
% hObject    handle to Tambiant_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tambiant_ET as text
%        str2double(get(hObject,'String')) returns contents of Tambiant_ET as a double


% --- Executes during object creation, after setting all properties.
function Tambiant_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tambiant_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Triver_ET_Callback(hObject, eventdata, handles)
% hObject    handle to Triver_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Triver_ET as text
%        str2double(get(hObject,'String')) returns contents of Triver_ET as a double


% --- Executes during object creation, after setting all properties.
function Triver_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Triver_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tmax_ET_Callback(hObject, eventdata, handles)
% hObject    handle to Tmax_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tmax_ET as text
%        str2double(get(hObject,'String')) returns contents of Tmax_ET as a double


% --- Executes during object creation, after setting all properties.
function Tmax_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tmax_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dTpinch_ET_Callback(hObject, eventdata, handles)
% hObject    handle to dTpinch_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dTpinch_ET as text
%        str2double(get(hObject,'String')) returns contents of dTpinch_ET as a double


% --- Executes during object creation, after setting all properties.
function dTpinch_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dTpinch_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TflueGas_ET_Callback(hObject, eventdata, handles)
% hObject    handle to TflueGas_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TflueGas_ET as text
%        str2double(get(hObject,'String')) returns contents of TflueGas_ET as a double


% --- Executes during object creation, after setting all properties.
function TflueGas_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TflueGas_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaT_ET_Callback(hObject, eventdata, handles)
% hObject    handle to deltaT_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaT_ET as text
%        str2double(get(hObject,'String')) returns contents of deltaT_ET as a double


% --- Executes during object creation, after setting all properties.
function deltaT_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaT_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pe_ET_Callback(hObject, eventdata, handles)
% hObject    handle to Pe_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pe_ET as text
%        str2double(get(hObject,'String')) returns contents of Pe_ET as a double


% --- Executes during object creation, after setting all properties.
function Pe_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pe_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nF_ET_Callback(hObject, eventdata, handles)
% hObject    handle to nF_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nF_ET as text
%        str2double(get(hObject,'String')) returns contents of nF_ET as a double


% --- Executes during object creation, after setting all properties.
function nF_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nF_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nR_ET_Callback(hObject, eventdata, handles)
% hObject    handle to nR_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nR_ET as text
%        str2double(get(hObject,'String')) returns contents of nR_ET as a double


% --- Executes during object creation, after setting all properties.
function nR_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nR_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function steamPressure_ET_Callback(hObject, eventdata, handles)
% hObject    handle to steamPressure_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of steamPressure_ET as text
%        str2double(get(hObject,'String')) returns contents of steamPressure_ET as a double


% --- Executes during object creation, after setting all properties.
function steamPressure_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to steamPressure_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fuel_ET_Callback(hObject, eventdata, handles)
% hObject    handle to fuel_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fuel_ET as text
%        str2double(get(hObject,'String')) returns contents of fuel_ET as a double


% --- Executes during object creation, after setting all properties.
function fuel_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fuel_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambda_ET_Callback(hObject, eventdata, handles)
% hObject    handle to lambda_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambda_ET as text
%        str2double(get(hObject,'String')) returns contents of lambda_ET as a double


% --- Executes during object creation, after setting all properties.
function lambda_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambda_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in deaerator_CB.
function deaerator_CB_Callback(hObject, eventdata, handles)
% hObject    handle to deaerator_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deaerator_CB


% --- Executes on button press in ts_PB.
function ts_PB_Callback(hObject, eventdata, handles)
% hObject    handle to ts_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Tambiant,Triver,deltaT,Tmax,dTpinch,TflueGas,Pe,nF,nR,deGazing,steamPressure,fuel,lambda] = inputArgs(hObject,eventdata,handles);
steamPowerPlant(deltaT,Triver,Tmax,steamPressure,Pe,nF,nR,dTpinch,deGazing,fuel,lambda,TflueGas,Tambiant,{'ts'});


% --- Executes on button press in enPie_PB.
function enPie_PB_Callback(hObject, eventdata, handles)
% hObject    handle to enPie_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Tambiant,Triver,deltaT,Tmax,dTpinch,TflueGas,Pe,nF,nR,deGazing,steamPressure,fuel,lambda] = inputArgs(hObject,eventdata,handles);
steamPowerPlant(deltaT,Triver,Tmax,steamPressure,Pe,nF,nR,dTpinch,deGazing,fuel,lambda,TflueGas,Tambiant,{'EnPie'});


% --- Executes on button press in cycleSelection_PB.
function cycleSelection_PB_Callback(hObject, eventdata, handles)
% hObject    handle to cycleSelection_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
main
close steamGUI


% --- Executes on button press in hs_PB.
function hs_PB_Callback(hObject, eventdata, handles)
% hObject    handle to hs_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Tambiant,Triver,deltaT,Tmax,dTpinch,TflueGas,Pe,nF,nR,deGazing,steamPressure,fuel,lambda] = inputArgs(hObject,eventdata,handles);
steamPowerPlant(deltaT,Triver,Tmax,steamPressure,Pe,nF,nR,dTpinch,deGazing,fuel,lambda,TflueGas,Tambiant,{'hs'});


% --- Executes on button press in exPie_PB.
function exPie_PB_Callback(hObject, eventdata, handles)
% hObject    handle to exPie_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Tambiant,Triver,deltaT,Tmax,dTpinch,TflueGas,Pe,nF,nR,deGazing,steamPressure,fuel,lambda] = inputArgs(hObject,eventdata,handles);
steamPowerPlant(deltaT,Triver,Tmax,steamPressure,Pe,nF,nR,dTpinch,deGazing,fuel,lambda,TflueGas,Tambiant,{'ExPie'});


% --- Executes on button press in dispFlowRates_PB.
function dispFlowRates_PB_Callback(hObject, eventdata, handles)
% hObject    handle to dispFlowRates_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Tambiant,Triver,deltaT,Tmax,dTpinch,TflueGas,Pe,nF,nR,deGazing,steamPressure,fuel,lambda] = inputArgs(hObject,eventdata,handles);
[~,BleedFlows,SteamGenFlow,CondFlow,FGflow,negFlowRate] = steamPowerPlant(deltaT,Triver,Tmax,steamPressure,Pe,nF,nR,dTpinch,deGazing,fuel,lambda,TflueGas,Tambiant,{});
if ~negFlowRate
set(handles.steamGenFlow_ST,'string',[num2str(SteamGenFlow) ' kg/s']);
set(handles.condenserFlow_ST,'string',[num2str(CondFlow) ' kg/s']);
set(handles.flueGasFlow_ST,'string',[num2str(FGflow) ' kg/s']);
if nF ~= 0
    n=1:nF;
    axes(handles.bleedFlows_Ax)
    bar(BleedFlows,0.4)
    xlabel('Bleed number')
    ylabel('Mass flow rate [kg/s]')
    text(n,BleedFlows,num2str(BleedFlows,'%0.2f'),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom') 
    guidata(hObject,handles);
end
end


% --- Executes on button press in clearFlowRates_PB.
function clearFlowRates_PB_Callback(hObject, eventdata, handles)
% hObject    handle to clearFlowRates_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.steamGenFlow_ST,'string','-');
set(handles.condenserFlow_ST,'string','-');
set(handles.flueGasFlow_ST,'string','-');
cla(handles.bleedFlows_Ax,'reset')
guidata(hObject,handles)
