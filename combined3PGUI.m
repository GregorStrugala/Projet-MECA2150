function varargout = combined3PGUI(varargin)
% COMBINED3PGUI MATLAB code for combined3PGUI.fig
%      COMBINED3PGUI, by itself, creates a new COMBINED3PGUI or raises the existing
%      singleton*.
%
%      H = COMBINED3PGUI returns the handle to a new COMBINED3PGUI or the handle to
%      the existing singleton*.
%
%      COMBINED3PGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMBINED3PGUI.M with the given input arguments.
%
%      COMBINED3PGUI('Property','Value',...) creates a new COMBINED3PGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before combined3PGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to combined3PGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help combined3PGUI

% Last Modified by GUIDE v2.5 19-Dec-2016 22:29:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @combined3PGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @combined3PGUI_OutputFcn, ...
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


% --- Executes just before combined3PGUI is made visible.
function combined3PGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to combined3PGUI (see VARARGIN)

% Choose default command line output for combined3PGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes combined3PGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = combined3PGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PLselection_PB.
function PLselection_PB_Callback(hObject, eventdata, handles)
% hObject    handle to PLselection_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
combinedGUI
close combined3PGUI



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



function dTapproach_ET_Callback(hObject, eventdata, handles)
% hObject    handle to dTapproach_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dTapproach_ET as text
%        str2double(get(hObject,'String')) returns contents of dTapproach_ET as a double


% --- Executes during object creation, after setting all properties.
function dTapproach_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dTapproach_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ts_PB.
function ts_PB_Callback(hObject, eventdata, handles)
% hObject    handle to ts_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles);
combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,r,PeGT,{'ts'},{})


% --- Executes on button press in enPie_PB.
function enPie_PB_Callback(hObject, eventdata, handles)
% hObject    handle to enPie_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles);
combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,r,PeGT,{'EnPie'},{})


% --- Executes on button press in hs_PB.
function hs_PB_Callback(hObject, eventdata, handles)
% hObject    handle to hs_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles);
combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,r,PeGT,{'hs'},{})


% --- Executes on button press in exPie_PB.
function exPie_PB_Callback(hObject, eventdata, handles)
% hObject    handle to exPie_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles);
combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,r,PeGT,{'ExPie'},{})


% --- Executes on button press in tq_PB.
function tq_PB_Callback(hObject, eventdata, handles)
% hObject    handle to tq_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles);
combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,r,PeGT,{'tq'},{})



function HPsteamPressure_ET_Callback(hObject, eventdata, handles)
% hObject    handle to HPsteamPressure_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HPsteamPressure_ET as text
%        str2double(get(hObject,'String')) returns contents of HPsteamPressure_ET as a double


% --- Executes during object creation, after setting all properties.
function HPsteamPressure_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HPsteamPressure_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xOturbineLP_ET_Callback(hObject, eventdata, handles)
% hObject    handle to xOturbineLP_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xOturbineLP_ET as text
%        str2double(get(hObject,'String')) returns contents of xOturbineLP_ET as a double


% --- Executes during object creation, after setting all properties.
function xOturbineLP_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xOturbineLP_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PeGT_ET_Callback(hObject, eventdata, handles)
% hObject    handle to PeGT_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PeGT_ET as text
%        str2double(get(hObject,'String')) returns contents of PeGT_ET as a double


% --- Executes during object creation, after setting all properties.
function PeGT_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PeGT_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ta_ET_Callback(hObject, eventdata, handles)
% hObject    handle to Ta_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ta_ET as text
%        str2double(get(hObject,'String')) returns contents of Ta_ET as a double


% --- Executes during object creation, after setting all properties.
function Ta_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ta_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tf_ET_Callback(hObject, eventdata, handles)
% hObject    handle to Tf_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tf_ET as text
%        str2double(get(hObject,'String')) returns contents of Tf_ET as a double


% --- Executes during object creation, after setting all properties.
function Tf_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tf_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r_ET_Callback(hObject, eventdata, handles)
% hObject    handle to r_ET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r_ET as text
%        str2double(get(hObject,'String')) returns contents of r_ET as a double


% --- Executes during object creation, after setting all properties.
function r_ET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_ET (see GCBO)
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


% --- Executes on button press in tsGT_PB.
function tsGT_PB_Callback(hObject, eventdata, handles)
% hObject    handle to tsGT_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles);
combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,r,PeGT,{},{'ts'})


% --- Executes on button press in enPieGT_PB.
function enPieGT_PB_Callback(hObject, eventdata, handles)
% hObject    handle to enPieGT_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles);
combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,r,PeGT,{},{'EnPie'})


% --- Executes on button press in hsGT_PB.
function hsGT_PB_Callback(hObject, eventdata, handles)
% hObject    handle to hsGT_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles);
combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,r,PeGT,{},{'hs'})


% --- Executes on button press in exPieGT_PB.
function exPieGT_PB_Callback(hObject, eventdata, handles)
% hObject    handle to exPieGT_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles);
combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,r,PeGT,{},{'ExPie'})


% --- Executes on button press in dispFlowRates_PB.
function dispFlowRates_PB_Callback(hObject, eventdata, handles)
% hObject    handle to dispFlowRates_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles);
[~,~,msLP,msIP,msHP,msTot,mg,ma,mc] = combinedCyclePowerPlant3P(deltaT,Triver,HPsteamPressure,dTpinch,dTapproach,xOturbineLP,Ta,Tf,fuel,r,PeGT,{},{});
set(handles.ma_ST,'string',[num2str(ma) ' kg/s']);
set(handles.mc_ST,'string',[num2str(mc) ' kg/s']);
set(handles.mg_ST,'string',[num2str(mg) ' kg/s']);
set(handles.msLP_ST,'string',[num2str(msLP) ' kg/s']);
set(handles.msIP_ST,'string',[num2str(msIP) ' kg/s']);
set(handles.msHP_ST,'string',[num2str(msHP) ' kg/s']);
set(handles.msTot_ST,'string',[num2str(msTot) ' kg/s']);

% --- Executes on button press in clearFlowRates_PB.
function clearFlowRates_PB_Callback(hObject, eventdata, handles)
% hObject    handle to clearFlowRates_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ma_ST,'string','-');
set(handles.mc_ST,'string','-');
set(handles.mg_ST,'string','-');
set(handles.msLP_ST,'string','-');
set(handles.msIP_ST,'string','-');
set(handles.msHP_ST,'string','-');
set(handles.msTot_ST,'string','-');

function [Ta,Triver,deltaT,dTpinch,dTapproach,xOturbineLP,Tf,PeGT,HPsteamPressure,r,fuel] = inputArgs(hObject,eventdata,handles)
Ta = str2double(get(handles.Ta_ET,'string'));
Triver = str2double(get(handles.Triver_ET,'string'));
deltaT = str2double(get(handles.deltaT_ET,'string'));
dTpinch = str2double(get(handles.dTpinch_ET,'string'));
dTapproach = str2double(get(handles.dTapproach_ET,'string'));
xOturbineLP = str2double(get(handles.xOturbineLP_ET,'string'));
Tf = str2double(get(handles.Tf_ET,'string'));
PeGT = str2double(get(handles.PeGT_ET,'string'));
HPsteamPressure = str2double(get(handles.HPsteamPressure_ET,'string'));
r = str2double(get(handles.r_ET,'string'));
fuel = get(handles.fuel_ET,'string');
