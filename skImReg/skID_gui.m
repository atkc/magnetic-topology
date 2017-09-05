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

% Last Modified by GUIDE v2.5 05-Jun-2017 16:05:16

% Begin initialization code - DO NOT EDIT
%clear global;
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
set(handles.figure1, 'units', 'normalized', 'position', [0.05 0.15 0.9 0.8]);
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
global rawIm dgrayIm filIm binIm centroids radius;
th = get(get(handles.threshOpt,'SelectedObject'), 'Tag');
threshOpt=[];
switch th
    case 'threshOpt1'
        threshOpt=1;
    case 'threshOpt2'
        threshOpt=2;
end
threshVal=str2double(get(handles.threshVal,'String'));
adaptArea=str2double(get(handles.adaptArea,'String'));
erodeSize=str2double(get(handles.erodeSize,'String'));
filRpt=str2double(get(handles.filRpt,'String'));
filSize=str2double(get(handles.filSize,'String'));
minSize=str2double(get(handles.minSize,'String'));
maxSize=str2double(get(handles.maxSize,'String'));
% threshVal
% adaptArea
% erodeSize
% [threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize]
[dgrayIm, filIm, ~, centroids]=m1_binarize(rawIm,threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize);
[threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize];
radius=max(centroids(:,3));
cla(handles.figBox,'reset');
axes(handles.figBox);
imshow(dgrayIm,[0,255]);
plot_centers(handles,centroids);
set(handles.figBox, 'ButtonDownFcn', @figBox_ButtonDownFcn); 

% --- Executes on button press in filBtn.
function filBtn_Callback(hObject, eventdata, handles)
% hObject    handle to filBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filBtn





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
global rawIm filename filepath;
%clearvars rawIm filIm binIm centroids;
[filename,filepath]=uigetfile({'*.*','All Files'},...
  'Select Data File 1')
rawIm=imread([filepath filename]);
axes(handles.figBox);
imshow(rawIm);


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



function minSize_Callback(hObject, eventdata, handles)
% hObject    handle to minSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minSize as text
%        str2double(get(hObject,'String')) returns contents of minSize as a double


% --- Executes during object creation, after setting all properties.
function minSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxSize_Callback(hObject, eventdata, handles)
% hObject    handle to maxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxSize as text
%        str2double(get(hObject,'String')) returns contents of maxSize as a double


% --- Executes during object creation, after setting all properties.
function maxSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function figBox_ButtonDownFcn(hObject, eventdata, handles)
% global rawIm filIm binIm centroids;
% F=get(handles.figBox,'currentpoint')
% x=F(1);
% y=F(3);
% size(centroids)
% 
% if strcmp( get(handles.figure1,'selectionType') , 'alt')
%     if ~isempty(centroids)
%         centroids=removePT(centroids,x,y);
%         disp('1 point removed');
%     end
% elseif strcmp( get(handles.figure1,'selectionType') , 'normal')
%     temp=zeros(size(centroids)+[1 0])
%     temp=[centroids;[x y 0 0 0]]
%     centroids=temp;
% end
% 
% centroids
% hObject    handle to figBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function centroidsR = removePT(centroids,x,y)
global radius;
distxy=abs((centroids(:,1)-x).^2+(centroids(:,2)-y).^2);
[~,i]=min(distxy);
%disp('1 point removed');
centroids(i,:)=[];
centroidsR=centroids;
radius =max(centroids(:,3));
%radius =1.5* max(centroids(:,3));



% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F = get(handles.figBox,'currentpoint');
x=F(1);
y=F(3);

xlim=get(handles.figBox,'xLim');
ylim=get(handles.figBox,'yLim');

if (x>xlim(1))&&(x<xlim(2))&&(y>ylim(1))&&(y<ylim(2));
    
    set(handles.xpos,'String',x);
    set(handles.ypos,'String',y);
end


function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dgrayIm rawIm filIm binIm centroids;
F = get(handles.figBox,'currentpoint');
x=F(1);
y=F(3);

xlim=get(handles.figBox,'xLim');
ylim=get(handles.figBox,'yLim');

if (x>xlim(1))&&(x<xlim(2))&&(y>ylim(1))&&(y<ylim(2));
    
    %size(centroids)

    if strcmp( get(handles.figure1,'selectionType') , 'alt')
        if ~isempty(centroids)
            centroids=removePT(centroids,x,y);
            disp('1 point removed');
        end
    elseif strcmp( get(handles.figure1,'selectionType') , 'normal')
        centroids=[centroids;[x y 0 0 0]];
    end
    cla(handles.figBox,'reset');
    axes(handles.figBox);
    imshow(dgrayIm,[0,255]);
    hold all;
    %disp(centroids)
    plot_centers(handles,centroids);
end


% --- Executes on button press in fitBtn.
function fitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global isofit dgrayIm centroids radius filename 
if ~isempty(centroids)
    maxr = str2double(get(handles.maxr_edit,'string'));
    imageSize = str2double(get(handles.size_text,'string'));
    saveInd = get(handles.saveInd_box,'value');
    [~,name,ext] = fileparts(filename) ;
    [isofit]=m2_fit2d(radius, centroids,dgrayIm,name,maxr,saveInd,imageSize);
    
    centroids=isofit;
    cla(handles.figBox,'reset');
    axes(handles.figBox);
    imshow(dgrayIm,[0,255]);
    hold all;
    plot_centers(handles,centroids);
end


% --- Executes on button press in outputBtn.
function outputBtn_Callback(hObject, eventdata, handles)
% hObject    handle to outputBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global centroids isofit filepath filename;
cd(filepath);
[~,name,ext] = fileparts(filename) ;
fileID = fopen(strcat(name,'_skyrmion_xy.txt'),'wt');
% isofit;
if ~isempty(isofit) 
    fprintf(fileID,'%2.2f %2.2f %2.2f %2.2f %2.2f\n',isofit(:,1:5)');
else
    fprintf(fileID,'%2.2f %2.2f %2.2f %2.2f %2.2f\n',centroids(:,1:2)');
end
fclose(fileID);


% --- Executes on button press in saveInd_box.
function saveInd_box_Callback(hObject, eventdata, handles)
% hObject    handle to saveInd_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveInd_box



function maxr_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxr_edit as text
%        str2double(get(hObject,'String')) returns contents of maxr_edit as a double


% --- Executes during object creation, after setting all properties.
function maxr_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function size_text_Callback(hObject, eventdata, handles)
% hObject    handle to size_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of size_text as text
%        str2double(get(hObject,'String')) returns contents of size_text as a double


% --- Executes during object creation, after setting all properties.
function size_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to size_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
