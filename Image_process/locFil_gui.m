function varargout = locFil_gui(varargin)
% SKID_GUI MATLAB code for locFil_gui.fig
%      SKID_GUI, by itself, creates a new SKID_GUI or raises the existing
%      singleton*.
%
%      H = locFil_gui returns the handle to a new locFil_gui or the handle to
%      the existing singleton*.
%
%      locFil_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in locFil_gui.M with the given input arguments.
%
%      locFil_gui('Property','Value',...) creates a new locFil_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before locFil_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to locFil_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help locFil_gui

% Last Modified by GUIDE v2.5 25-Aug-2017 09:10:28

% Begin initialization code - DO NOT EDIT
%clear all;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @locFil_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @locFil_gui_OutputFcn, ...
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


% --- Executes just before locFil_gui is made visible.
function locFil_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to locFil_gui (see VARARGIN)

% Choose default command line output for locFil_gui
handles.output = hObject;
set(handles.figure1, 'units', 'normalized', 'position', [0.05 0.15 0.9 0.8]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes locFil_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = locFil_gui_OutputFcn(hObject, eventdata, handles) 
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
global rawIm centroids immean imstd
xy=centroids(:,1:2);
rawIm=average_rec(rawIm,xy);
axes(handles.figBox);
imshow(rawIm,[immean-0.5*imstd,immean+0.5*imstd]);
centroids=[];

% --- Executes on button press in loadBtn.
function loadBtn_Callback(hObject, eventdata, handles)
% hObject    handle to loadBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rawIm rawImraw filename filepath immean imstd;
%clearvars rawIm filIm binIm centroids;
[filename,filepath]=uigetfile({'*.*','All Files'},...
  'Select Data File 1')
rawImraw=imread([filepath filename]);
rawIm=rawImraw(:,:,1);
rawImraw=rawIm;
axes(handles.figBox);
immean=mean(reshape(rawIm(:,:,1),[length(rawIm)^2,1]));
imstd=std(double((reshape(rawIm(:,:,1),[length(rawIm)^2,1]))));
imshow(rawIm,[immean-0.5*imstd,immean+0.5*imstd]);
clearvars centroids



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
global dgrayIm rawIm filIm binIm centroids immean imstd;
F = get(handles.figBox,'currentpoint');
x=round(F(1));
y=round(F(3));

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
    imshow(rawIm,[immean-0.5*imstd,immean+0.5*imstd]);
    hold all;
    %disp(centroids)
    centroids=unique(centroids,'rows');
    plot_centers(handles,centroids);
end


% --- Executes on button press in outputBtn.
function outputBtn_Callback(hObject, eventdata, handles)
% % hObject    handle to outputBtn (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
global rawIm filename filepath
cd(filepath);
[~,name,ext] = fileparts(filename) ;
imwrite(rawIm,strcat(name,'_avg_rec.tiff'));
% % isofit;
% if ~isempty(isofit) 
%     fprintf(fileID,'%2.2f %2.2f %2.2f %2.2f %2.2f\n',isofit(:,1:5)');
% else
%     fprintf(fileID,'%2.2f %2.2f %2.2f %2.2f %2.2f\n',centroids(:,1:2)');
% end
% fclose(fileID);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rawImraw rawIm centroids immean imstd
centroids=[];
rawIm=rawImraw;
axes(handles.figBox);
imshow(rawIm,[immean-0.5*imstd,immean+0.5*imstd]);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rawIm centroids immean imstd
centroids=[];
axes(handles.figBox);
imshow(rawIm,[immean-0.5*imstd,immean+0.5*imstd]);
