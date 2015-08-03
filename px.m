function varargout = px(varargin)
% PX MATLAB code for px.fig
%      PX, by itself, creates a new PX or raises the existing
%      singleton*.
%
%      H = PX returns the handle to a new PX or the handle to
%      the existing singleton*.
%
%      PX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PX.M with the given input arguments.
%
%      PX('Property','Value',...) creates a new PX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before px_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to px_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help px

% Last Modified by GUIDE v2.5 14-Jul-2014 13:41:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @px_OpeningFcn, ...
                   'gui_OutputFcn',  @px_OutputFcn, ...
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


% --- Executes just before px is made visible.
function px_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to px (see VARARGIN)

% Choose default command line output for px
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes px wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = px_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
