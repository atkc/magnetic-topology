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

% Last Modified by GUIDE v2.5 23-Oct-2019 10:12:16

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
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode zmode fit_resize im_lx im_ly

format_h=get(handles.filetype_rBtn_grp,'SelectedObject');
format_mode_tag=get(format_h,'Tag');

if strcmp(format_mode_tag,'tiff_btn')
    filetype='*.tiff';
elseif strcmp(format_mode_tag,'png_btn')
    filetype='*.png';
end

fileList = dir(filetype);
fileList={fileList.name};
p_no=zeros(1,length(fileList));
for file_i=1:length(fileList)
    filename1=fileList{file_i};
    p_no(file_i)= str2double(regexp(filename1, '((?<=_p)\d+)|((?<=_p..)\d+)', 'match'));
end
[~,p_i]=sort(p_no);

%***pre-reading of file to determine var size***
im=imread(fileList{p_i(1)});
[im_lx,im_ly]=size(im(:,:,1));
if im_ly==im_lx
    fit_resize=im_ly/1080;%square image
    im_ly=1080;
    im_lx=1080;
else
    fit_resize=1; %rectangle image
end
%***********************************************

im_pos=zeros(length(fileList),2);%up/down, left/right
im_bank=zeros(length(fileList),im_lx,im_ly);
InvertInd = get(handles.invert_box,'value');
for p_ii=1:length(p_i)
    if InvertInd
        im=imcomplement(imread(fileList{p_i(p_ii)}));
    else
        im=(imread(fileList{p_i(p_ii)}));
    end
    im_bank(p_ii,:,:) = imresize(im(:,:,1),max([im_ly im_lx])/length(im(:,:,1)),'bicubic');
    display(strcat(fileList{p_i(p_ii)},' loaded\n'));
end
MasterList=zeros(300,50,4);%[#sk]; [frame/pulse no]; [sk-id, x, y, radius]
sk_col=zeros(300,3);
im_i=1;
im_i_last=length(p_i);
mouse_mode=0;
zmode=1;
updateIm(handles,reshape(im_bank(1,:,:),im_lx,im_ly),im_pos(1,:),zmode)
updateStatus(handles,2,fileList{p_i(1)});
updateStatus(handles,1,strcat(num2str(length(p_i)),' Images Loaded'));



% --- Executes on button press in idSk_btn.
function idSk_btn_Callback(hObject, eventdata, handles)
% hObject    handle to idSk_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no binIm1 centroids approx_r imageSize im_bank sk_col MasterList mouse_mode im_pos zmode im_lx im_ly
threshOpt=1;
threshVal=str2double(get(handles.tresh_btn,'String'));
adaptArea=15;
erodeSize=0;
filRpt=0;
filSize=0;
minSize=40;
maxSize=300;
c_th=0.6;
e_th=1.75;
imageSize = str2double(get(handles.imSize_btn,'String'));;
connect=4;%8
rawIm=imtranslate(reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:));
%[threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize]'
[~, ~, binIm1, ~, ~, centroids,threshVal]=m1_binarize(rawIm,threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize,c_th,e_th,imageSize,connect,0);
set(handles.tresh_btn,'String',num2str(threshVal));
approx_r=mean(centroids(:,3));
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
sk_col=plot_col_centers( handles, centroids,sk_col,1,0,zmode);
[noSk,~]=size(centroids);
MasterList=zeros(300,50,4);
MasterList(1:noSk,p_no(p_i(im_i)),2:4)=centroids(:,1:3);
MasterList(1:noSk,p_no(p_i(im_i)),1)=1:noSk;
updateStatus(handles,1,sprintf(strcat(num2str(noSk),' Skyrmions Located')));

% --- Executes on button press in prevIm_btn.
function prevIm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to prevIm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode zmode im_lx im_ly

if (im_i>1)
    im_i=im_i-1;
    updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
    centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
    sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);
    updateStatus(handles,2,sprintf(fileList{p_i(im_i)},' displayed'));
else
    updateStatus(handles,1,sprintf('Reached first image, unable to go previous'));
end


% --- Executes on button press in nextIm_btn.
function nextIm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to nextIm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode zmode im_lx im_ly

if (im_i<im_i_last)
    im_i=im_i+1;
    updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
    centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
    sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);
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
global im_pos
load('im_pos.mat')

% --- Executes on button press in LoadSk_pos_btn.
function LoadSk_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSk_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode zmode im_lx im_ly
load('MasterList.mat')
load('sk_col.mat')
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);

% --- Executes on button press in imLeft_btn.
function imLeft_btn_Callback(hObject, eventdata, handles)
% hObject    handle to imLeft_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode zmode im_lx im_ly
im_pos(im_i,1)=im_pos(im_i,1)-1;
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);

% --- Executes on button press in imRight_btn.
function imRight_btn_Callback(hObject, eventdata, handles)
% hObject    handle to imRight_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode zmode im_lx im_ly
im_pos(im_i,1)=im_pos(im_i,1)+1;
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);

% --- Executes on button press in imUp_btn.
function imUp_btn_Callback(hObject, eventdata, handles)
% hObject    handle to imUp_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode zmode im_lx im_ly
im_pos(im_i,2)=im_pos(im_i,2)-1;
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);

% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode zmode im_lx im_ly
im_pos(im_i,2)=im_pos(im_i,2)+1;
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);

% --- Executes on button press in resetIm_btn.
function resetIm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to resetIm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode zmode im_lx im_ly
im_pos(im_i,:)=[0,0]
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);


% --- Executes on button press in putPrevPos_btn.
function putPrevPos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to putPrevPos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode zmode im_lx im_ly

if (im_i>1)
    updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
    MasterList(:,p_no(p_i(im_i)),:)=MasterList(:,p_no(p_i(im_i-1)),:);
    centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
    sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);
    updateStatus(handles,1,sprintf('Retrieved Skyrmion positions from previous image'));
else
    updateStatus(handles,1,sprintf('Unable to retrieve Skyrmion positions, this is the first image'));
end

% --- Executes on button press in putPrevSelSk_pos_btn.
function putPrevSelSk_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to putPrevSelSk_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode skN zmode im_lx im_ly
if (mouse_mode==1)
    if im_i>1
        mouse_mode=0;
        updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
        MasterList(skN,p_no(p_i(im_i)),2:3)=MasterList(skN,p_no(p_i(im_i-1)),2:3);
        centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
        sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);
        updateStatus(handles,1,sprintf('Skyrmion %i returned to previous image position',skN));
        skN=0;
    else
        updateStatus(handles,1,sprintf('Unable to retrieve Skyrmion %i position, this is the first image',skN));
    end
end

% --- Executes on button press in putDel_pos_btn.
function putDel_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to putDel_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of putDel_pos_btn

% --- Executes on button press in putNextSelSk_pos_btn.
function putNextSelSk_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to putNextSelSk_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of putNextSelSk_pos_btn
global im_i p_i p_no fileList im_i_last im_bank im_pos sk_col MasterList mouse_mode skN zmode im_lx im_ly
if (mouse_mode==1)
    if im_i<im_i_last
        mouse_mode=0;
        updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
        MasterList(skN,p_no(p_i(im_i+1)),:)=MasterList(skN,p_no(p_i(im_i)),:);
        centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
        sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);
        updateStatus(handles,1,sprintf('Skyrmion %i sent to next image position',skN));
        skN=0;
    else
        updateStatus(handles,1,sprintf('Unable to send Skyrmion %i position, this is the last image',skN));
    end
end

% --- Executes on button press in saveIm_pos_btn.
function saveIm_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to saveIm_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_pos
save('im_pos.mat','im_pos');

% --- Executes on button press in saveSk_pos_btn.
function saveSk_pos_btn_Callback(hObject, eventdata, handles)
% hObject    handle to saveSk_pos_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MasterList sk_col
[MasterList,sk_col_l]=cleanML(MasterList);
save('MasterList.mat','MasterList');
sk_col=sk_col(1:sk_col_l,:);
save('sk_col.mat','sk_col');

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


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no approx_r im_bank sk_col MasterList mouse_mode skN im_pos zmode im_lx im_ly
F = get(handles.figBox,'currentpoint');
x=F(1);
y=F(3);

xlim=get(handles.figBox,'xLim');
ylim=get(handles.figBox,'yLim');
centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
if strcmp( get(handles.figure1,'selectionType') , 'normal')
if (x>xlim(1))&&(x<xlim(2))&&(y>ylim(1))&&(y<ylim(2));
    
    h=get(handles.mouse_rBtn_grp,'SelectedObject');
    mouse_mode_tag=get(h,'Tag');
    updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
    if (mouse_mode==0)%fresh mouse event
        if strcmp(mouse_mode_tag,'moveSk_rBtn')
            skN=idSk(centroids,x,y);
            sk_col=plot_col_centers( handles, centroids,sk_col,2,skN,zmode);
            mouse_mode=1;
            updateStatus(handles,1,sprintf('Mouse Mode = Move Skyrmion\n Skyrmion %i selected',skN));
        elseif strcmp(mouse_mode_tag,'addSk_rBtn')
            mouse_mode=0;
            l=sum(any(sk_col,2));
            MasterList(l+1,p_no(p_i(im_i)),1:3)=[l+1,x,y];
            centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
            sk_col=plot_col_centers( handles, centroids,sk_col,2,skN,zmode);
            updateStatus(handles,1,sprintf('Skyrmion %i added\nMouse Mode exited',l+1));
        else
            mouse_mode=0;
            skN=idSk(centroids,x,y);
            MasterList(skN,p_no(p_i(im_i)),2:3)=[0,0];
            centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
            sk_col=plot_col_centers( handles, centroids,sk_col,2,skN,zmode);
            updateStatus(handles,1,sprintf('Skyrmion %i deleted\nMouse Mode exited',skN));
            skN=0;
        end
    else %mouse event triggered before this event at moveSk_rBtn
        mouse_mode=0;
        centroids(skN,:)=[x,y];
        sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);
        MasterList(:,p_no(p_i(im_i)),2:3)=centroids;
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
global im_i p_i p_no binIm1 centroids approx_r imageSize im_bank sk_col MasterList mouse_mode im_pos zmode im_lx im_ly
conv=imageSize/max([im_lx im_ly]);
imageSize
flip_n=0;
p_width=1e9;%ns
[ fullstat2,theta_cor,r_cor,MasterList ]= processML_nn( MasterList, p_no, conv,p_width,flip_n);
save('MasterList.mat','MasterList');
save(strcat('r_cor','.mat'),'r_cor');
save(strcat('theta_cor','.mat'),'theta_cor');
save(strcat('fullstat2','.mat'),'fullstat2');




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


% --- Executes on button press in zoomAll_btn.
function zoomAll_btn_Callback(hObject, eventdata, handles)
% hObject    handle to zoomAll_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no im_bank sk_col MasterList im_pos zmode im_lx im_ly
zmode=1;
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);


% --- Executes on button press in zoomTop_btn.
function zoomTop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to zoomTop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no im_bank sk_col MasterList im_pos zmode im_lx im_ly
zmode=2;
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);

% --- Executes on button press in zoomMid_btn.
function zoomMid_btn_Callback(hObject, eventdata, handles)
% hObject    handle to zoomMid_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no im_bank sk_col MasterList im_pos zmode im_lx im_ly
zmode=3;
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);

% --- Executes on button press in zoomBtm_btn.
function zoomBtm_btn_Callback(hObject, eventdata, handles)
% hObject    handle to zoomBtm_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im_i p_i p_no im_bank sk_col MasterList im_pos zmode im_lx im_ly
zmode=4;
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
centroids=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,2,0,zmode);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
%display (eventdata.Key);
key=eventdata.Key;
if strcmp(key,'uparrow')
    nextIm_btn_Callback(hObject,eventdata,handles);
elseif strcmp(key,'rightarrow')
    nextIm_btn_Callback(hObject,eventdata,handles);
elseif strcmp(key,'downarrow')
    prevIm_btn_Callback(hObject,eventdata,handles);
elseif strcmp(key,'leftarrow')
    prevIm_btn_Callback(hObject,eventdata,handles);
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over fitSizeAll.


% --- Executes on button press in fitSize.
function fitSize_Callback(hObject, eventdata, handles)
% hObject    handle to fitSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fileList im_i p_i p_no im_bank sk_col MasterList im_pos approx_r zmode centroids_temp fit_resize im_lx im_ly
display('ininnn');
im_fit=imread(fileList{p_i(im_i)});
im_fit=double(im_fit);%imresize(im_fit,4,'nearest');
%[im_fit_size,~]=size(im_fit);
%fit_resize=im_fit_size/1080;
im_fit_pos=im_pos(im_i,:)*fit_resize;
im_fit=imtranslate(im_fit,im_fit_pos);

centroids_temp=reshape(MasterList(:,p_no(p_i(im_i)),2:3),[300,2]);
centroids_fit=centroids_temp*fit_resize;
imageSize=str2double(get(handles.imSize_btn,'String'));
maxr=1.25;
[sk_l,~]=size(centroids_fit);
for sk_i=1:sk_l
    if (~all(centroids_fit(sk_i,:)==0))    
    saveInd = get(handles.saveInd_box,'value');  
    % if fitOpt==1
    [isofit,~]=m2_fit2d(approx_r*fit_resize, centroids_fit(sk_i,:),im_fit,fileList{p_i(im_i)},maxr,saveInd,imageSize,0);
%     approx_r=80*(1080/13000);
%     %Fitting algorithm
%     %1. Estimating the window size (weighted fit)
%     %disp('Estimate');
%     [estfit,~,ex1,~]=m2_fit2d((approx_r/fit_resize), [xy(sk_i,1)+xcor,xy(sk_i,2)],dgrayIm,fullfilename,1.5,0,imageSize,0);        
%     new_xy=(estfit(1:2));
%     %2. Actual Fit (weighted fit)
%     %disp('Final Fit');
%     [isofit,~,fitstatus,res1]=m2_fit2d(estfit(4)/2, new_xy-1,dgrayIm,fullfilename,maxr,saveInd,imageSize,0);    
    % elseif fitOpt==2
    %     [xyfit,unfitno]=m2_fit2d_aniso(radius, centroids,dgrayIm,name,maxr,saveInd,imageSize);
    %     centroids=xyfit;
    %     clearvars isofit
    % end
    new_xy=(isofit(1:2))/fit_resize;
    FWHM=isofit(4)/fit_resize;
    centroids_temp(sk_i,1:3)=[new_xy-1,FWHM];    
    end
end
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode);
sk_col=plot_col_centers( handles, centroids_temp(:,1:2),sk_col,2,0,zmode);

% --- Executes on button press in fitSizeAll.
function fitSizeAll_Callback(hObject, eventdata, handles)
% hObject    handle to fitSizeAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in invert_box.
function invert_box_Callback(hObject, eventdata, handles)
% hObject    handle to invert_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of invert_box


% --- Executes on button press in idSkAll_btn.
function idSkAll_btn_Callback(hObject, eventdata, handles)
% hObject    handle to idSkAll_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p_i p_no binIm1 centroids approx_r imageSize im_bank sk_col MasterList mouse_mode im_pos zmode im_lx im_ly im_i_last im_i
threshOpt=1;
threshVal=str2double(get(handles.tresh_btn,'String'));
adaptArea=15;
erodeSize=0;
filRpt=0;
filSize=0;
minSize=40;
maxSize=300;
c_th=0.6;
e_th=1.75;
imageSize = str2double(get(handles.imSize_btn,'String'));
connect=4;%8
MasterList=zeros(300,50,4);
for im_i_id_all=1:im_i_last
    rawIm=imtranslate(reshape(im_bank(im_i_id_all,:,:),im_lx,im_ly),im_pos(im_i_id_all,:));
    %[threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize]'
    [~, ~, binIm1, ~, ~, centroids,threshVal]=m1_binarize(rawIm,threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize,c_th,e_th,imageSize,connect,0);
    set(handles.tresh_btn,'String',num2str(threshVal));
    approx_r=mean(centroids(:,3));
    %updateIm(handles,reshape(im_bank(im_i_id_all,:,:),im_lx,im_ly),im_pos(im_i_id_all,:),zmode)
    sk_col=plot_col_centers( handles, centroids,sk_col,1,0,zmode);
    [noSk,~]=size(centroids);
    MasterList(1:noSk,p_no(p_i(im_i_id_all)),2:4)=centroids(:,1:3);
    MasterList(1:noSk,p_no(p_i(im_i_id_all)),1)=1:noSk;
end
updateIm(handles,reshape(im_bank(im_i,:,:),im_lx,im_ly),im_pos(im_i,:),zmode)
updateStatus(handles,1,sprintf(strcat(num2str(noSk),' Skyrmions Located')));
centroids=reshape(MasterList(:,p_no(p_i(im_i))+1,2:3),[300,2]);
sk_col=plot_col_centers( handles, centroids,sk_col,1,0,zmode);