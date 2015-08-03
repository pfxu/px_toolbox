function varargout = NIU(varargin)
% NIU(NeuroImaging Utilities) MATLAB code for NIU.fig
%      NIU, by itself, creates a new NIU or raises the existing
%      singleton*.
%
%      H = NIU returns the handle to a new NIU or the handle to
%      the existing singleton*.
%
%      NIU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NIU.M with the given input arguments.
%
%      NIU('Property','Value',...) creates a new NIU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NIU_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NIU_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NIU

% Last Modified by GUIDE v2.5 14-Jul-2014 14:41:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NIU_OpeningFcn, ...
                   'gui_OutputFcn',  @NIU_OutputFcn, ...
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


% --- Executes just before NIU is made visible.
function NIU_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NIU (see VARARGIN)

% Choose default command line output for NIU
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%-Open startup window, set window defaults
%-----------------------------------------------------------------------
% Fwelcome = openfig(fullfile(px_toolbox_root,'NIU.fig'),'new','invisible');
% % set(Fwelcome,'name',sprintf('%s%s','NeuroImaging Utilities',NIU_getuser(' (%s)')));
% % set(get(findobj(Fwelcome,'Type','axes'),'children'),'FontName',spm_platform('Font','Times'));
% % set(findobj(Fwelcome,'Tag','SPM_VER'),'String',spm('Ver'));
% RectW = spm('WinSize','W',1); 
% Rect0 = spm('WinSize','0',1);
% set(Fwelcome,'Units','pixels', 'Position',...
%     [Rect0(1)+(Rect0(3)-RectW(3))/2, Rect0(2)+(Rect0(4)-RectW(4))/2, RectW(3), RectW(4)]);

% ScreenSize = get(0,'screensize');
% pos1 = 0.25 * ScreenSize(3);
% pos3 = 0.1 * ScreenSize(4);
% pos4 = 0.05 * ScreenSize(4);
% set(gcf, 'Position', [pos1, 0, pos3, pos4]);%[Position_1, Position_2, 242, 538]);
% % set(Fwelcome,'Visible','on');

    %-Root workspace
    Rect = get(0, 'monitorposition');
    if all(ismember(Rect(:),[0 1]))
        warning('NIU:noDisplay','Unable to open display.');
    end
    win_size = get(0,'PointerLocation');
    set(gcf, 'Position', [round(.25*win_size(1)), round(.25*win_size(2)), round(.2*win_size(1)), round(.2*win_size(2))])
    
    if size(Rect,1) > 1 % Multiple Monitors
        %-Use Monitor containing the Pointer
        pl = get(0,'PointerLocation');
    end


% UIWAIT makes NIU wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NIU_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function functional_Callback(hObject, eventdata, handles)
% hObject    handle to fMRIButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ICA;
% network measures;
% task;
fun_interface;

function structural_Callback(hObject, eventdata, handles)
% hObject    handle to fMRIButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% VBM;
% FSL;
str_interface;

function statistical_Callback(hObject, eventdata, handles)
% hObject    handle to fMRIButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sta_interface;

%=======================================================================
function NIU_getuser(fmt)                                          %-Get user name
%=======================================================================
% str = spm('GetUser',fmt)
%-----------------------------------------------------------------------
str = spm_platform('user');
if ~isempty(str) , str = sprintf(varargin{1},str); end
varargout = {str};

% --- Executes on button press in C_INP1_Browse.
function C_INP1_Browse_Callback(hObject, eventdata, handles)
% hObject    handle to C_INP1_Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.txt','Select the MOS File');
handles.C_INP1 = fullfile(PathName,FileName);
set(handles.C_INP1_Path,'String',handles.C_INP1);
handles.MOS = dlmread(handles.C_INP1)
guidata(hObject, handles);

% --- Executes on button press in plotBut.
function plotBut_Callback(hObject, eventdata, handles)
% hObject    handle to plotBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
 
plot(handles.METRIC,handles.MOS,'o')
%adds a title, x-axis description, and y-axis description


est_t0 = median(handles.METRIC);
xx = handles.METRIC-est_t0;
title('MOS Vs. METRIC')
ylabel('MOS')
xlabel('METRIC')

[max_xx down_idx]= min(xx); 
for idx = 1:size(xx)
    if(xx(idx)<0)
        if(xx(idx)>max_xx)
            max_xx=xx(idx); down_idx = idx;
        end
    end
end
[min_xx up_idx]= max(xx); for idx = 1:size(xx)
    if(xx(idx)>0)
        if(xx(idx)<min_xx)
            min_xx=xx(idx); up_idx = idx;
        end
    end
end

mt0 = (handles.MOS(up_idx)-handles.MOS(down_idx))/(handles.METRIC(up_idx)-handles.METRIC(down_idx));

est_r = 4*mt0;

min_r = est_r/10;
max_r = est_r*10;

set(handles.min_r,'String',num2str(min_r));
set(handles.max_r,'String',num2str(max_r));
set(handles.est_r,'String',num2str(est_r));
set(handles.est_t0,'String',num2str(est_t0));

%Calculate the estimates
guidata(hObject, handles); %updates the handles
