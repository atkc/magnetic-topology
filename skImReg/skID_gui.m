function varargout = skID_gui(varargin)
% SKID_GUI MATLAB code for skID_gui.fig
%      SKID_GUI, by itself, creates a new SKID_GUI or raises the existing
%      singleton*.
%
%      H = SKID_GUI returns the handle to a new SKID_GUI or the handle to
%      the existing singleton*.
%
%      SKID_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SKID_GUI.M with the given input arguments.
%
%      SKID_GUI('Property','Value',...) creates a new SKID_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before skID_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to skID_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help skID_gui

% Last Modified by GUIDE v2.5 24-Mar-2017 19:06:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @skID_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @skID_gui_OutputFcn, ...
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


% --- Executes just before skID_gui is made visible.
function skID_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to skID_gui (see VARARGIN)

% Choose default command line output for skID_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes skID_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = skID_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in executeBtn.
function executeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to executeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
th = get(get(handles.threshOpt,'SelectedObject'), 'Tag')
threshOpt=[];
switch th
    case 'threshOpt1'
        threshOpt=1;
    case 'threshOpt2'
        threshOpt=2;
end
threshVal=get(handles.threshVal,value);
adaptArea=get(handles.adaptArea,value);
erodeSize=get(handles.erodeSize,value);
filRpt=get(handles.filRpt,value);
filSize=get(handles.filSize,value);
% threshVal
% adaptArea
% erodeSize
m1_binarize(im,threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize);

% --- Executes on button press in doneBtn.
function doneBtn_Callback(hObject, eventdata, handles)
% hObject    handle to doneBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of doneBtn





function threshVal_Callback(hObject, eventdata, handles)
% hObject    handle to threshVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshVal as text
%        str2double(get(hObject,'String')) returns contents of threshVal as a double


% --- Executes during object creation, after setting all properties.
function threshVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function adaptArea_Callback(hObject, eventdata, handles)
% hObject    handle to adaptArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adaptArea as text
%        str2double(get(hObject,'String')) returns contents of adaptArea as a double


% --- Executes during object creation, after setting all properties.
function adaptArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adaptArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function erodeSize_Callback(hObject, eventdata, handles)
% hObject    handle to erodeSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of erodeSize as text
%        str2double(get(hObject,'String')) returns contents of erodeSize as a double
%disp('1');
str=hObject.String;
if isempty(str2num(str))
    set(hObject,'string','1');
    warndlg('Input must be numerical');
end


% --- Executes during object creation, after setting all properties.
function erodeSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to erodeSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in threshOpt1.
function threshOpt1_Callback(hObject, eventdata, handles)
% hObject    handle to threshOpt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of threshOpt1


% --- Executes on button press in threshOpt2.
function threshOpt2_Callback(hObject, eventdata, handles)
% hObject    handle to threshOpt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of threshOpt2


% --- Executes on button press in loadBtn.
function loadBtn_Callback(hObject, eventdata, handles)
% hObject    handle to loadBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function filSize_Callback(hObject, eventdata, handles)
% hObject    handle to filSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filSize as text
%        str2double(get(hObject,'String')) returns contents of filSize as a double


% --- Executes during object creation, after setting all properties.
function filSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filRpt_Callback(hObject, eventdata, handles)
% hObject    handle to filRpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filRpt as text
%        str2double(get(hObject,'String')) returns contents of filRpt as a double


% --- Executes during object creation, after setting all properties.
function filRpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filRpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
