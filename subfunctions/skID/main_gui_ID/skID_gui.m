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

% Last Modified by GUIDE v2.5 25-Jan-2018 23:22:04

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
global rawIm dgrayIm filIm binIm centroids radius param imageSize;
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
c_th=str2double(get(handles.c_th,'String'));
e_th=str2double(get(handles.e_th,'String'));
imageSize = str2double(get(handles.size_text,'string'));
% threshVal
% adaptArea
% erodeSize
% [threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize]
connect=4;%8
[threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize,c_th,e_th,imageSize,connect]
%[threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize]'
[dgrayIm, filIm, binIm1, binIm2, binIm3, centroids,threshVal]=m1_binarize(rawIm,threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize,c_th,e_th,imageSize,connect);


radius=mean(centroids(:,3));
cla(handles.figBox,'reset');
axes(handles.figBox);
imshow(dgrayIm,[0,255]);


binIm1_fil= filIT( binIm1,minSize,maxSize,c_th,e_th,imageSize,connect,1);
drawBoundaries(handles,binIm1_fil,'r',1,connect);

binIm2_chop=chopIT(binIm2);
binIm2_fil= filIT( binIm2_chop,minSize,maxSize,c_th,e_th,imageSize,connect,2);
%drawBoundaries(handles,binIm2_fil,'r',1,connect);

binIm=binIm2_fil + binIm1_fil;
cc=bwconncomp(binIm,connect);
graindata = regionprops(cc,'centroid','Area','PerimeterOld','MajorAxisLength','MinorAxisLength');
centroids=zeros(length(graindata),5);
if (length(graindata)>1)

    centroids(:,1:2)=cat(1,graindata.Centroid);
    centroids(:,3)=sqrt([graindata.Area]/pi());
    centroids(:,4)=[graindata.PerimeterOld];

    area=[graindata.Area];
    perimeter=[graindata.PerimeterOld]; 
    roundness = 4*pi*area./perimeter.^2;
    centroids(:,5)=roundness;
end
% plot_centers(handles,centroids);
update_count( handles,centroids,imageSize )
%binIm3=chopIT(binIm3);
%binIm3= filIT( binIm3,0.6);
%drawBoundaries(handles,binIm3,'w',1,connect);

assignin('base','binIm1',binIm1);
assignin('base','binIm2',binIm2);
assignin('base','binIm3',binIm3);
assignin('base','binIm1_fil',binIm1_fil);
assignin('base','binIm2_fil',binIm2_fil);
% c=figure;imshow(dgrayIm(479-70:(479+307-70),454+20:(454+307+20)),[0,255]);
% 
% a=figure;imshow(dgrayIm(479-70:(479+307-70),454+20:(454+307+20)),[0,255]);
% 
% drawBoundaries(handles,binIm1_fil(479-70:(479+307-70),454+20:(454+307+20)),'r',1,connect);
% drawBoundaries(handles,binIm2_fil(479-70:(479+307-70),454+20:(454+20+307)),'b',1,connect);
% binIm_temp=binIm1+binIm2+binIm3;
% b=figure;imshow(binIm_temp(479-70:(479+307-70),454+20:(454+20+307)));
% %drawBoundaries(handles,binIm1_fil(479-70:(479+307-70),454+20:(454+20+307)),'r',1,connect);
% 
% drawBoundaries(handles,binIm2_fil(479-70:(479+307-70),454+20:(454+20+307)),'b',1,connect);
% bd=figure;imshow(binIm_temp(479-70:(479+307-70),454+20:(454+20+307)));
% bd=figure;imshow(binIm2(479-70:(479+307-70),454+20:(454+20+307)));
% bd=figure;imshow(binIm1_fil(479-70:(479+307-70),454+20:(454+20+307)));
param=[threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize,c_th,e_th,connect];
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
%fil_basic=[0 1/5 0;1/5 1/5 1/5;0 1/5 0];
%rawIm=imfilter(rawIm,fil_basic);
InvertInd = get(handles.invert_box,'value');
if InvertInd
    rawIm = imcomplement(rawIm);
end
rawIm = imresize(rawIm,1024/length(rawIm),'bicubic');
%rawIm=imcomplement(rawIm);
imshow(rawIm);


function filSize_Callback(hObject, eventdata, handles)
% hObject    handle to filSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)=
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
global dgrayIm rawIm filIm binIm centroids imageSize;
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

update_count( handles,centroids,imageSize);


% --- Executes on button press in fitBtn.
function fitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.text31,'String','Fitting...');
global xyfit isofit dgrayIm centroids radius filename imageSize
ft = get(get(handles.fitOpt,'SelectedObject'), 'Tag');
fitOpt=[];
switch ft
    case 'fitOpt1'
        fitOpt=1;
    case 'fitOpt2'
        fitOpt=2;
end


if ~isempty(centroids)
    maxr = str2double(get(handles.maxr_edit,'string'));
    imageSize = str2double(get(handles.size_text,'string'));
    saveInd = get(handles.saveInd_box,'value');    
    [~,name,ext] = fileparts(filename);
    if fitOpt==1
        [isofit,unfitno]=m2_fit2d(radius, centroids,dgrayIm,name,maxr,saveInd,imageSize);
        centroids=isofit;
        clearvars xyfit
    elseif fitOpt==2
        [xyfit,unfitno]=m2_fit2d_aniso(radius, centroids,dgrayIm,name,maxr,saveInd,imageSize);
        centroids=xyfit;
        clearvars isofit
    end
    
    %set(handles.text31,'String',strcat('Fitting done, Unable to fit  ',num2str(unfitno),' sk'));

    cla(handles.figBox,'reset');
    axes(handles.figBox);
    imshow(dgrayIm,[0,255]);
    hold all;
    plot_centers(handles,centroids);
    update_count( handles,centroids,imageSize);
end


% --- Executes on button press in outputBtn.
function outputBtn_Callback(hObject, eventdata, handles)
% hObject    handle to outputBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global centroids xyfit isofit filepath filename param imageSize;
cd(filepath);
[~,name,ext] = fileparts(filename) ;
fileID = fopen(strcat(name,'_skyrmion_xy.txt'),'wt');
% isofit;
% print a title, followed by a blank line
%parameters
%threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize,c_th,e_th,imageSize,connect


if ~isempty(centroids) 
    fprintf(fileID, '\n%s %s %s\n\n','Sk no(#)','Density (#/um^2)');
    [skno,~]=size(centroids);
    fprintf(fileID,'\n%2.2f %2.2f',skno,skno/(imageSize)^2);
end
    
fprintf(fileID, '\n\n%s %s %s %s %s %s %s %s %s %s %s %s','threshOpt(#)','threshVal(#)','adaptArea(px)','erodeSize(px)','filRpt(#)','filSize(px^2)','minSize(px^2)','maxSize(px^2)','c_th(#)','e_th(#)','connect(px)','image length(um)');
if ~isempty(param) 
    fprintf(fileID, '\n%2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f',param,imageSize);
else
    fprintf(fileID, '\n%2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f',zeros(1,12));
end

fprintf(fileID, '\n\n%s %s %s %s %s\n\n','x (px)','y (px)','sigma (px)','fwhm (px)');

if ~isempty(isofit) 
    fprintf(fileID,'\n%2.2f %2.2f %2.2f %2.2f',isofit(:,1:4)');
else
    fprintf(fileID,'\n%2.2f %2.2f %2.2f %2.2f',centroids(:,1:2)');
end

fclose(fileID);

if ~isempty(xyfit)
    fileID = fopen(strcat(name,'_skyrmion_xy.txt'),'wt');
    fprintf(fileID, '%s %s %s %s %s %s %s','x (px)','y (px)','sigma1 (px)','sigma2 (px)','theta (o)','noise','amplitude');
    fprintf(fileID,'\n%2.2f %2.2f %2.2f %2.2f %2.2f %2.2f %2.2f',xyfit(:,1:7)');
    fclose(fileID);
end


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
% --- Executes on button press in invert_box.
function invert_checkbox_Callback(hObject, eventdata, handles)
global rawIm
% hObject    handle to invert_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rawIm = imcomplement(rawIm);
cla(handles.figBox,'reset');
axes(handles.figBox);
imshow(rawIm,[0,255]);
% Hint: get(hObject,'Value') returns toggle state of invert_box



% --- Executes on button press in checkEdge.
function checkEdge_Callback(hObject, eventdata, handles)
global centroids radius dgrayIm imageSize
centroids=checkEdge(centroids,2*radius,size(dgrayIm));
cla(handles.figBox,'reset');
axes(handles.figBox);
imshow(dgrayIm,[0,255]);
plot_centers(handles,centroids);
update_count( handles,centroids,imageSize);
% hObject    handle to checkEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function c_th_Callback(hObject, eventdata, handles)

function c_th_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function e_th_Callback(hObject, eventdata, handles)

function e_th_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
