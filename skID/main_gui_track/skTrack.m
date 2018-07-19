function varargout = skTrack(varargin)
% SKTRACK MATLAB code for skTrack.fig
%      SKTRACK, by itself, creates a new SKTRACK or raises the existing
%      singleton*.
%
%      H = SKTRACK returns the handle to a new SKTRACK or the handle to
%      the existing singleton*.
%
%      SKTRACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SKTRACK.M with the given input arguments.
%
%      SKTRACK('Property','Value',...) creates a new SKTRACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before skTrack_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to skTrack_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help skTrack

% Last Modified by GUIDE v2.5 18-Jul-2018 00:46:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @skTrack_OpeningFcn, ...
                   'gui_OutputFcn',  @skTrack_OutputFcn, ...
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


% --- Executes just before skTrack is made visible.
function skTrack_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to skTrack (see VARARGIN)

% Choose default command line output for skTrack
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes skTrack wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = skTrack_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadIm_btn.
function loadIm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to loadIm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Main data output:
%1. %fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
%2. %masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode

fileList = dir('*.tiff');
fileList={fileList.name};
p_no=zeros(1,length(fileList));
for file_i=1:length(fileList)
    filename1=fileList{file_i};
    p_no(file_i)= str2double(regexp(filename1, '(?<=_p)\d+', 'match'));
end
[~,p_i]=sort(p_no);

im_pos=zeros(length(fileList),2);%up/down, left/right
im_bank=zeros(length(fileList),1024,1024);
for p_ii=1:length(p_i)
    im=imread(fileList{p_i(p_ii)});
    im_bank(p_ii,:,:) = imresize(im(:,:,1),1024/length(im(:,:,1)),'bicubic');
    display(strcat(fileList{p_i(p_ii)},' loaded\n'));
end
MasterList=zeros(300,50,4);%[#sk]; [frame/pulse no]; [sk-id, x, y, size]
sk_col=zeros(300,3);
im_i=1;
im_i_last=length(p_i);
mouse_mode=0;
updateIm(handles,reshape(im_bank(1,:,:),1024,1024),im_pos(1,:))
updateStatus(handles,2,fileList{p_i(1)});
updateStatus(handles,1,strcat(num2str(length(p_i)),' Images Loaded'));



% --- Executes on button press in idSk_btn.
function idSk_btn_Callback(hObject, eventdata, handles)
% hObject    handle to idSk_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no binIm1 centroids approx_r imageSize im_bank sk_col MasterList mouse_mode im_pos
threshOpt=1;
threshVal=str2double(get(handles.tresh_btn,'String'));
adaptArea=15;
erodeSize=0;
filRpt=0;
filSize=0;
minSize=60;
maxSize=150;
c_th=0.6;
e_th=1.75;
imageSize = 13;
connect=4;%8
rawIm=imtranslate(reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:));
%[threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize]'
[~, ~, binIm1, ~, ~, centroids,threshVal]=m1_binarize(rawIm,threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize,c_th,e_th,imageSize,connect);
set(handles.tresh_btn,'String',num2str(threshVal));
approx_r=mean(centroids(:,3));
updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
sk_col=plot_col_centers( handles, centroids,sk_col,1,0);
[noSk,~]=size(centroids);
MasterList=zeros(300,50,4);
MasterList(1:noSk,p_no(p_i(im_i))+1,2:4)=centroids(:,1:3);
MasterList(1:noSk,p_no(p_i(im_i))+1,1)=1:noSk;
updateStatus(handles,1,sprintf(strcat(num2str(noSk),' Skyrmions Located')));

% --- Executes on button press in prevIm_btn.
function prevIm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to prevIm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode

if (im_i>1)
    im_i=im_i-1;
    updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
    centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
    sk_col=plot_col_centers( handles, centroids,sk_col,2,0);
    updateStatus(handles,2,sprintf(fileList{p_i(im_i)},' displayed'));
else
    updateStatus(handles,1,sprintf('Reached first image, unable to go previous'));
end


% --- Executes on button press in nextIm_btn.
function nextIm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to nextIm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode

if (im_i<im_i_last)
    im_i=im_i+1;
    updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
    centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
    sk_col=plot_col_centers( handles, centroids,sk_col,2,0);
    updateStatus(handles,2,sprintf(fileList{p_i(im_i)},' displayed'));
    if (mouse_mode==1)
        mouse_mode=0;
        updateStatus(handles,1,'Mouse mode exited');
    end
else
    updateStatus(handles,1,sprintf('Reached last image, unable to go next'));
end

% --- Executes on button press in loadIm_pos_btn.
function loadIm_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to loadIm_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadSk_pos_btn.
function LoadSk_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSk_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode
load('MasterList_test.mat')
load('sk_col_test.mat')
updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0);

% --- Executes on button press in imLeft_btn.
function imLeft_btn_Callback(hObject, eventdata, handles)
% hObject    handle to imLeft_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode
im_pos(im_i,1)=im_pos(im_i,1)-1;
updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0);

% --- Executes on button press in imRight_btn.
function imRight_btn_Callback(hObject, eventdata, handles)
% hObject    handle to imRight_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode
im_pos(im_i,1)=im_pos(im_i,1)+1;
updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0);

% --- Executes on button press in imUp_btn.
function imUp_btn_Callback(hObject, eventdata, handles)
% hObject    handle to imUp_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode
im_pos(im_i,2)=im_pos(im_i,2)-1;
updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0);

% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode
im_pos(im_i,2)=im_pos(im_i,2)+1;
updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0);

% --- Executes on button press in resetIm_btn.
function resetIm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to resetIm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode
im_pos(im_i,:)=[0,0]
updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0);


% --- Executes on button press in putPrevPos_btn.
function putPrevPos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to putPrevPos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode

if (im_i>1)
    updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
    MasterList(:,p_no(p_i(im_i))+1,:)=MasterList(:,p_no(p_i(im_i)),:);
    centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
    sk_col=plot_col_centers( handles, centroids,sk_col,2,0);
    updateStatus(handles,1,sprintf('Retrieved Skyrmion positions from previous image'));
else
    updateStatus(handles,1,sprintf('Unable to retrieve Skyrmion positions, this is the first image'));
end

% --- Executes on button press in putPrevSelSk_pos_btn.
function putPrevSelSk_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to putPrevSelSk_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode skN
if (mouse_mode==1)
    if im_i>1
        mouse_mode=0;
        updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
        MasterList(skN,p_no(p_i(im_i))+1,2:3)=MasterList(skN,p_no(p_i(im_i)),2:3);
        centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
        sk_col=plot_col_centers( handles, centroids,sk_col,2,0);
        updateStatus(handles,1,sprintf('Skyrmion %i returned to previous image position',skN));
        skN=0;
    else
        updateStatus(handles,1,sprintf('Unable to retrieve Skyrmion %i position, this is the first image',skN));
    end
end

% --- Executes on button press in saveIm_pos_btn.
function saveIm_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to saveIm_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveSk_pos_btn.
function saveSk_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to saveSk_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MasterList sk_col
save('MasterList_test.mat','MasterList');
save('sk_col_test.mat','sk_col');



% --- Executes on button press in putDel_pos_btn.
function putDel_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to putDel_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of putDel_pos_btn


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
    
    set(handles.xPos_txt,'String',x);
    set(handles.yPos_txt,'String',y);
end



function tresh_btn_Callback(hObject, eventdata, handles)
% hObject    handle to tresh_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tresh_btn as text
%        str2double(get(hObject,'String')) returns contents of tresh_btn as a double


% --- Executes during object creation, after setting all properties.
function tresh_btn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tresh_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no approx_r im_bank sk_col MasterList mouse_mode skN im_pos
F = get(handles.figBox,'currentpoint');
x=F(1);
y=F(3);

xlim=get(handles.figBox,'xLim');
ylim=get(handles.figBox,'yLim');
centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
if strcmp( get(handles.figure1,'selectionType') , 'normal')
if (x>xlim(1))&&(x<xlim(2))&&(y>ylim(1))&&(y<ylim(2));
    
    h=get(handles.mouse_rBtn_grp,'SelectedObject');
    mouse_mode_tag=get(h,'Tag');
    updateIm(handles,reshape(im_bank(im_i,:,:),1024,1024),im_pos(im_i,:))
    if (mouse_mode==0)%fresh mouse event
        if strcmp(mouse_mode_tag,'moveSk_rBtn')
            skN=idSk(centroids,x,y);
            sk_col=plot_col_centers( handles, centroids,sk_col,2,skN);
            mouse_mode=1;
            updateStatus(handles,1,sprintf('Mouse Mode = Move Skyrmion\n Skyrmion %i selected',skN));
        elseif strcmp(mouse_mode_tag,'addSk_rBtn')
            mouse_mode=0;
            l=sum(any(sk_col,2));
            MasterList(l+1,p_no(p_i(im_i))+1,1:3)=[l+1,x,y];
            centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
            sk_col=plot_col_centers( handles, centroids,sk_col,2,skN);
            updateStatus(handles,1,sprintf('Skyrmion %i added\nMouse Mode exited',l+1));
        else
            mouse_mode=0;
            skN=idSk(centroids,x,y);
            MasterList(skN,p_no(p_i(im_i))+1,2:3)=[0,0];
            centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
            sk_col=plot_col_centers( handles, centroids,sk_col,2,skN);
            updateStatus(handles,1,sprintf('Skyrmion %i deleted\nMouse Mode exited',skN));
            skN=0;
        end
    else %mouse event triggered before this event at moveSk_rBtn
        mouse_mode=0;
        centroids(skN,:)=[x,y];
        sk_col=plot_col_centers( handles, centroids,sk_col,2,0);
        MasterList(:,p_no(p_i(im_i))+1,2:3)=centroids;
        updateStatus(handles,1,sprintf('Skyrmion %i moved to new position\nMouse Mode exited',skN));
        skN=0;
    end
end
%         
%     if strcmp( get(handles.figure1,'selectionType') , 'alt')
%         if ~isempty(centroids)
%             centroids=removePT(centroids,x,y);
%             disp('1 point removed');
%         end
%     elseif strcmp( get(handles.figure1,'selectionType') , 'normal')
%         centroids=[centroids;[x y 0 0 0]];
%     end

end

%update_count( handles,centroids,imageSize);


% --- Executes on button press in saveResults_btn.
function saveResults_btn_Callback(hObject, eventdata, handles)
% hObject    handle to saveResults_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function imSize_btn_Callback(hObject, eventdata, handles)
% hObject    handle to imSize_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imSize_btn as text
%        str2double(get(hObject,'String')) returns contents of imSize_btn as a double


% --- Executes during object creation, after setting all properties.
function imSize_btn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imSize_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pulseW_btn_Callback(hObject, eventdata, handles)
% hObject    handle to pulseW_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pulseW_btn as text
%        str2double(get(hObject,'String')) returns contents of pulseW_btn as a double


% --- Executes during object creation, after setting all properties.
function pulseW_btn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pulseW_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
