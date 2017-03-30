function varargout = indSk_gui(varargin)
% INDSK_GUI MATLAB code for indSk_gui.fig
%      INDSK_GUI, by itself, creates a new INDSK_GUI or raises the existing
%      singleton*.
%
%      H = INDSK_GUI returns the handle to a new INDSK_GUI or the handle to
%      the existing singleton*.
%
%      INDSK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INDSK_GUI.M with the given input arguments.
%
%      INDSK_GUI('Property','Value',...) creates a new INDSK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before indSk_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to indSk_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help indSk_gui

% Last Modified by GUIDE v2.5 28-Mar-2017 16:09:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @indSk_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @indSk_gui_OutputFcn, ...
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


% --- Executes just before indSk_gui is made visible.
function indSk_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to indSk_gui (see VARARGIN)

% Choose default command line output for indSk_gui
handles.output = hObject;

% Update handles structure
load rawIm2.mat
load fitIm.mat
handles.rawIm2 = rawIm2;
handles.fitIm = fitIm;
axes(handles.dataFig);
imshow(handles.rawIm2,[0,255]);
axes(handles.fitDataFig);
imshow(handles.fitIm,[0,255]);
axes(handles.xsecFig);
[sx,sy]=size(rawIm2);
offs=max(max(rawIm2));
[~,midy]=max(max(fitIm));
for i = 1:7
    yq=midy+(3-i)*(sy/16);
    xq=1:0.5:sx;
    Vq = interp2(rawIm2,xq,yq,'spline');
    Vfitq = interp2(fitIm,xq,yq,'spline');
    plot(xq,Vq+(i-1)*offs,'rx');%fit plot
    hold on;
    plot(xq,Vfitq+(i-1)*offs);%fit plot
    hold on;
end
axes(handles.dataFig);
for i = 1:7
    hold on;
    yq=midy-(3-i)*(sy/16);
    line([1,sx],[yq,yq],'Color','red');
end
guidata(hObject, handles);
% UIWAIT makes indSk_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = indSk_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in nextBtn.
function nextBtn_Callback(hObject, eventdata, handles)
% hObject    handle to nextBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(indSk_gui);
