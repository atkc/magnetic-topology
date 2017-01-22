function varargout = Radial_M(varargin)
% RADIAL_M MATLAB code for Radial_M.fig
%      RADIAL_M, by itself, creates a new RADIAL_M or raises the existing
%      singleton*.
%
%      H = RADIAL_M returns the handle to a new RADIAL_M or the handle to
%      the existing singleton*.
%
%      RADIAL_M('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RADIAL_M.M with the given input arguments.
%
%      RADIAL_M('Property','Value',...) creates a new RADIAL_M or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Radial_M_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Radial_M_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Radial_M

% Last Modified by GUIDE v2.5 15-Oct-2016 23:56:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Radial_M_OpeningFcn, ...
                   'gui_OutputFcn',  @Radial_M_OutputFcn, ...
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


% --- Executes just before Radial_M is made visible.
function Radial_M_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Radial_M (see VARARGIN)

% Choose default command line output for Radial_M
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Radial_M wait for user response (see UIRESUME)
% uiwait(handles.skyrmionGUI);


% --- Outputs from this function are returned to the command line.
function varargout = Radial_M_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadim.
function loadim_Callback(hObject, eventdata, handles)
% hObject    handle to loadim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[path,user_cance] = imgetfile();   %Throw out a prompt to choose image
if user_cance
    msgbox(sprintf('Error ... Do not any how do! '),'Error', 'Error');
    return
end
[im, map]=imread(path);

% set(0, 'ShowHiddenHandles', 'on');
% axes(handles.axes1);
% cla(handles.axes1);
% NP = get(handles.skyrmionGUI, 'nextplot');
% set(0, 'ShowHiddenHandles', 'on');

im=im2double(im);  %converts to double

% im2 = im;   %For backup
if isempty(map)
  imageInfo = imfinfo(path);
  if strcmpi(imageInfo.ColorType, 'grayscale')
    colormap(gray(2^imageInfo.BitDepth));
  end
else
  colormap(map);
end

imshow(im,'parent',handles.axes1);
guidata(hObject,handles);

%set( imH, 'ButtonDownFcn', @axes1_ButtonDownFcn );



% --- Executes on button press in resetim.
function resetim_Callback(hObject, eventdata, handles)
% hObject    handle to resetim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im2
axes(handles.axes1);
imshow(im2);




% --- Executes on mouse press over axes background.
function winBtnDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.CurrentPointAxes = get(handles.axes1, 'CurrentPoint');
handles.CurrentPointFig  = get(handles.skyrmionGUI, 'CurrentPoint');
disp(handles.CurrentPointAxes)
disp('hihi')
disp(handles.CurrentPointFig)
guidata(hObject,handles);

function mousyclick(hObject,eventdata,handles)
pos=get(gca,'CurrentPoint');
disp(['You clicked X:',num2str(pos(1)),', Y:',num2str(pos(2))]);
disp(num2str(pos))


% --- Executes on button press in imageCrop.
function imageCrop_Callback(hObject, eventdata, handles)
% hObject    handle to imageCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.I,'Visible','off');
set(handles.imageCrop,'enable','off');
%Do not touch
% % Read image
% I = handles.I;
% hold(handles.axes1,'on');
% 
% % Let user choose rectangle to crop
% h = imrect(handles.I);
% position = round(wait(h));
% % Crop image
% I = imcrop(I,position);
% 
% hold(handles.axes1,'off');
% 
% % Show cropped image
% imshow(I, 'Parent', handles.axes2);
% 
% handles.Icrop = I;
% guidata(hObject, handles);
% set(handles.imageCrop,'enable','on');


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)


function draggingFcn(varargin)
        pt = get(S.fH, 'CurrentPoint');
        x = pt(1,1);
        y = pt(1,2);
        X = x
        Y = y

% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function skyrmionGUI_WindowButtonDownFcn(hObject, eventdata, handles)
%disp(eventdata)
pt=get(handles.axes1 ,'CurrentPoint');
        x = pt(1,1);
        y = pt(1,2);
        X = x
        Y = y
        guidata(hObject,handles);
set(hObject,'WindowButtonMotionFcn',@skyrmionGUI_ButtonDown_WindowButtonMotionFcn);

% hObject    handle to skyrmionGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse motion over figure - except title and menu.
function skyrmionGUI_WindowButtonMotionFcn(hObject, eventdata, handles)

% hObject    handle to skyrmionGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function skyrmionGUI_ButtonDown_WindowButtonMotionFcn(hObject, eventdata, handles)
a=get(gcf,'CurrentAxes');
% objjj=findobj(gcf,'Tag','axes1')
pt=get(a,'CurrentPoint');
         x = pt(1,1);
         y = pt(1,2);
         X = x
         Y = y
set(hObject,'WindowButtonUpFcn',@skyrmionGUI_ButtonMotion_WindowButtonUpFcn);

function skyrmionGUI_ButtonMotion_WindowButtonUpFcn(hObject, eventdata, handles)
set(hObject,'WindowButtonMotionFcn',[]);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function skyrmionGUI_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to skyrmionGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
