function freezeColors(varargin)
% freezeColors  Lock colors of plot, enabling multiple colormaps per figure. (v2.3)
%
%   Problem: There is only one colormap per figure. This function provides
%       an easy solution when plots using different colomaps are desired
%       in the same figure.
%
%   freezeColors freezes the colors of graphics objects in the current axis so
%       that subsequent changes to the colormap (or caxis) will not change the
%       colors of these objects. freezeColors works on any graphics object
%       with CData in indexed-color mode: surfaces, images, scattergroups,
%       bargroups, patches, etc. It works by converting CData to true-color rgb
%       based on the colormap active at the time freezeColors is called.
%
%   The original indexed color data is saved, and can be restored using
%       unfreezeColors, making the plot once again subject to the colormap and
%       caxis.
%
%
%   Usage:
%       freezeColors        applies to all objects in current axis (gca),
%       freezeColors(axh)   same, but works on axis axh.
%
%   Example:
%       subplot(2,1,1); imagesc(X); colormap hot; freezeColors
%       subplot(2,1,2); imagesc(Y); colormap hsv; freezeColors etc...
%
%       Note: colorbars must also be frozen. Due to Matlab 'improvements' this can
%    no longer be done with freezeColors. Instead, please
%    use the function CBFREEZE by Carlos Adrian Vargas Aguilera
%    that can be downloaded from the MATLAB File Exchange
%    (http://www.mathworks.com/matlabcentral/fileexchange/24371)
%
%       h=colorbar; cbfreeze(h), or simply cbfreeze(colorbar)
%
%       For additional examples, see test/test_main.m
%
%   Side effect on render mode: freezeColors does not work with the painters
%       renderer, because Matlab doesn't support rgb color data in
%       painters mode. If the current renderer is painters, freezeColors
%       changes it to zbuffer. This may have unexpected effects on other aspects
%       of your plots.
%
%       See also unfreezeColors, freezeColors_pub.html, cbfreeze.
%
%
%   John Iversen (iversen@nsi.edu) 3/23/05
%
%   Changes:
%   JRI (iversen@nsi.edu) 4/19/06   Correctly handles scaled integer cdata
%   JRI 9/1/06   should now handle all objects with cdata: images, surfaces,
%                scatterplots. (v 2.1)
%   JRI 11/11/06 Preserves NaN colors. Hidden option (v 2.2, not uploaded)
%   JRI 3/17/07  Preserve caxis after freezing--maintains colorbar scale (v 2.3)
%   JRI 4/12/07  Check for painters mode as Matlab doesn't support rgb in it.
%   JRI 4/9/08   Fix preserving caxis for objects within hggroups (e.g. contourf)
%   JRI 4/7/10   Change documentation for colorbars
% Hidden option for NaN colors:
%   Missing data are often represented by NaN in the indexed color
%   data, which renders transparently. This transparency will be preserved
%   when freezing colors. If instead you wish such gaps to be filled with
%   a real color, add 'nancolor',[r g b] to the end of the arguments. E.g.
%   freezeColors('nancolor',[r g b]) or freezeColors(axh,'nancolor',[r g b]),
%   where [r g b] is a color vector. This works on images & pcolor, but not on
%   surfaces.
%   Thanks to Fabiano Busdraghi and Jody Klymak for the suggestions. Bugfixes
%   attributed in the code.
% Free for all uses, but please retain the following:
%   Original Author:
%   John Iversen, 2005-10
%   john_iversen@post.harvard.edu
appdatacode = 'JRI__freezeColorsData';
[h, nancolor] = checkArgs(varargin);
%gather all children with scaled or indexed CData
cdatah = getCDataHandles(h);
%current colormap
cmap = colormap;
nColors = size(cmap,1);
cax = caxis;
% convert object color indexes into colormap to true-color data using
%  current colormap
for hh = cdatah',
    g = get(hh);
   
    %preserve parent axis clim
    parentAx = getParentAxes(hh);
    originalClim = get(parentAx, 'clim');   
  
    %   Note: Special handling of patches: For some reason, setting
    %   cdata on patches created by bar() yields an error,
    %   so instead we'll set facevertexcdata instead for patches.
    if ~strcmp(g.Type,'patch'),
        cdata = g.CData;
    else
        cdata = g.FaceVertexCData;
    end
   
    %get cdata mapping (most objects (except scattergroup) have it)
    if isfield(g,'CDataMapping'),
        scalemode = g.CDataMapping;
    else
        scalemode = 'scaled';
    end
   
    %save original indexed data for use with unfreezeColors
    siz = size(cdata);
    setappdata(hh, appdatacode, {cdata scalemode});
    %convert cdata to indexes into colormap
    if strcmp(scalemode,'scaled'),
        %4/19/06 JRI, Accommodate scaled display of integer cdata:
        %       in MATLAB, uint * double = uint, so must coerce cdata to double
        %       Thanks to O Yamashita for pointing this need out
        idx = ceil( (double(cdata) - cax(1)) / (cax(2)-cax(1)) * nColors);
    else %direct mapping
        idx = cdata;
        /8/09 in case direct data is non-int (e.g. image;freezeColors)
        % (Floor mimics how matlab converts data into colormap index.)
        % Thanks to D Armyr for the catch
        idx = floor(idx);
    end
   
    %clamp to [1, nColors]
    idx(idx<1) = 1;
    idx(idx>nColors) = nColors;
    %handle nans in idx
    nanmask = isnan(idx);
    idx(nanmask)=1; %temporarily replace w/ a valid colormap index
    %make true-color data--using current colormap
    realcolor = zeros(siz);
    for i = 1:3,
        c = cmap(idx,i);
        c = reshape(c,siz);
        c(nanmask) = nancolor(i); %restore Nan (or nancolor if specified)
        realcolor(:,:,i) = c;
    end
   
    %apply new true-color color data
   
    %true-color is not supported in painters renderer, so switch out of that
    if strcmp(get(gcf,'renderer'), 'painters'),
        set(gcf,'renderer','zbuffer');
    end
   
    %replace original CData with true-color data
    if ~strcmp(g.Type,'patch'),
        set(hh,'CData',realcolor);
    else
        set(hh,'faceVertexCData',permute(realcolor,[1 3 2]))
    end
   
    %restore clim (so colorbar will show correct limits)
    if ~isempty(parentAx),
        set(parentAx,'clim',originalClim)
    end
   
end %loop on indexed-color objects

% ============================================================================ %
% Local functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% getCDataHandles -- get handles of all descendents with indexed CData
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hout = getCDataHandles(h)
% getCDataHandles  Find all objects with indexed CData
%recursively descend object tree, finding objects with indexed CData
% An exception: don't include children of objects that themselves have CData:
%   for example, scattergroups are non-standard hggroups, with CData. Changing
%   such a group's CData automatically changes the CData of its children,
%   (as well as the children's handles), so there's no need to act on them.
error(nargchk(1,1,nargin,'struct'))
hout = [];
if isempty(h),return;end
ch = get(h,'children');
for hh = ch'
    g = get(hh);
    if isfield(g,'CData'),     %does object have CData?
        %is it indexed/scaled?
        if ~isempty(g.CData) && isnumeric(g.CData) && size(g.CData,3)==1,
            hout = [hout; hh]; %#ok<AGROW> %yes, add to list
        end
    else %no CData, see if object has any interesting children
            hout = [hout; getCDataHandles(hh)]; %#ok<AGROW>
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% getParentAxes -- return handle of axes object to which a given object belongs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hAx = getParentAxes(h)
% getParentAxes  Return enclosing axes of a given object (could be self)
error(nargchk(1,1,nargin,'struct'))
%object itself may be an axis
if strcmp(get(h,'type'),'axes'),
    hAx = h;
    return
end
parent = get(h,'parent');
if (strcmp(get(parent,'type'), 'axes')),
    hAx = parent;
else
    hAx = getParentAxes(parent);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% checkArgs -- Validate input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h, nancolor] = checkArgs(args)
% checkArgs  Validate input arguments to freezeColors
nargs = length(args);
error(nargchk(0,3,nargs,'struct'))
%grab handle from first argument if we have an odd number of arguments
if mod(nargs,2),
    h = args{1};
    if ~ishandle(h),
        error('JRI:freezeColors:checkArgs:invalidHandle',...
            'The first argument must be a valid graphics handle (to an axis)')
    end
    % 4/2010 check if object to be frozen is a colorbar
    if strcmp(get(h,'Tag'),'Colorbar'),
      if ~exist('cbfreeze.m'),
        warning('JRI:freezeColors:checkArgs:cannotFreezeColorbar',...
            ['You seem to be attempting to freeze a colorbar. This no longer'...
            'works. Please read the help for freezeColors for the solution.'])
      else
        cbfreeze(h);
        return
      end
    end
    args{1} = [];
    nargs = nargs-1;
else
    h = gca;
end
%set nancolor if that option was specified
nancolor = [nan nan nan];
if nargs == 2,
    if strcmpi(args{end-1},'nancolor'),
        nancolor = args{end};
        if ~all(size(nancolor)==[1 3]),
            error('JRI:freezeColors:checkArgs:badColorArgument',...
                'nancolor must be [r g b] vector');
        end
        nancolor(nancolor>1) = 1; nancolor(nancolor<0) = 0;
    else
        error('JRI:freezeColors:checkArgs:unrecognizedOption',...
            'Unrecognized option (%s). Only ''nancolor'' is valid.',args{end-1})
    end
end
 
 
function CBH = cbfreeze(varargin)
�FREEZE   Freezes the colormap of a colorbar.
%
%   SYNTAX:
%           cbfreeze
%           cbfreeze('off')
%           cbfreeze(H,...)
%     CBH = cbfreeze(...);
%
%   INPUT:
%     H     - Handles of colorbars to be freezed, or from figures to search
%             for them or from peer axes (see COLORBAR).
%             DEFAULT: gcf (freezes all colorbars from the current figure)
%     'off' - Unfreezes the colorbars, other options are:
%               'on'    Freezes
%               'un'    same as 'off'
%               'del'   Deletes the colormap(s).
%             DEFAULT: 'on' (of course)
%
%   OUTPUT (all optional):
%     CBH - Color bar handle(s).
%
%   DESCRIPTION:
%     MATLAB works with a unique COLORMAP by figure which is a big
%     limitation. Function FREEZECOLORS by John Iversen allows to use
%     different COLORMAPs in a single figure, but it fails freezing the
%     COLORBAR. This program handles this problem.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * If no colorbar is found, one is created.
%     * The new frozen colorbar is an axes object and does not behaves
%       as normally colorbars when resizing the peer axes. Although, some
%       time the normal behavior is not that good.
%     * Besides, it does not have the 'Location' property anymore.
%     * But, it does acts normally: no ZOOM, no PAN, no ROTATE3D and no
%       mouse selectable.
%     * No need to say that CAXIS and COLORMAP must be defined before using
%       this function. Besides, the colorbar location. Anyway, 'off' or
%       'del' may help.
%     * The 'del' functionality may be used whether or not the colorbar(s)
%       is(are) froozen. The peer axes are resized back. Try:
%        >> colorbar, cbfreeze del
%
%   EXAMPLE:
%     surf(peaks(30))
%     colormap jet
%     cbfreeze
%     colormap gray
%     title('What...?')
%
%   SEE ALSO:
%     COLORMAP, COLORBAR, CAXIS
%     and
%     FREEZECOLORS by John Iversen
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   cbfreeze.m
%   VERSION: 1.1 (Sep 02, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>)
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com
%   REVISIONS:
%   1.0      Released. (Jun 08, 2009)
%   1.1      Fixed BUG with image handle on MATLAB R2009a. Thanks to Sergio
%            Muniz. (Sep 02, 2009)
%   DISCLAIMER:
%   cbfreeze.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.
%   Copyright (c) 2009 Carlos Adrian Vargas Aguilera

% INPUTS CHECK-IN
% -------------------------------------------------------------------------
% Parameters:
cbappname = 'Frozen';         % Colorbar application data with fields:
                              % 'Location' from colorbar
                              % 'Position' from peer axes befor colorbar
                              % 'pax'      handle from peer axes.
axappname = 'FrozenColorbar'; % Peer axes application data with frozen
                              % colorbar handle.
 
% Set defaults:
S = 'on';                   Sopt = {'on','un','off','del'};
H = get(0,'CurrentFig');
% Check inputs:
if nargin==2 && (~isempty(varargin{1}) && all(ishandle(varargin{1})) && ...
  isempty(varargin{2}))
 
 % Check for CallBacks functionalities:
 % ------------------------------------
 
 varargin{1} = double(varargin{1});
 
 if strcmp(get(varargin{1},'BeingDelete'),'on')
  % Working as DeletFcn:
  if (ishandle(get(varargin{1},'Parent')) && ...
      ~strcmpi(get(get(varargin{1},'Parent'),'BeingDeleted'),'on'))
    % The handle input is being deleted so do the colorbar:
    S = 'del';
   
   if ~isempty(getappdata(varargin{1},cbappname))
    % The frozen colorbar is being deleted:
    H = varargin{1};
   else
    % The peer axes is being deleted:
    H = ancestor(varargin{1},{'figure','uipanel'});
   end
  
  else
   % The figure is getting close:
   return
  end
 
 elseif (gca==varargin{1} && ...
                     gcf==ancestor(varargin{1},{'figure','uipanel'}))
  % Working as ButtonDownFcn:
 
  cbfreezedata = getappdata(varargin{1},cbappname);
  if ~isempty(cbfreezedata)
   if ishandle(cbfreezedata.ax)
    % Turns the peer axes as current (ignores mouse click-over):
    set(gcf,'CurrentAxes',cbfreezedata.ax);
    return
   end
  else
   % Clears application data:
   rmappdata(varargin{1},cbappname)
  end
  H = varargin{1};
 end
 
else
 
 % Checks for normal calling:
 % --------------------------
 
 % Looks for H:
 if nargin && ~isempty(varargin{1}) && all(ishandle(varargin{1}))
  H = varargin{1};
  varargin(1) = [];
 end
 % Looks for S:
 if ~isempty(varargin) && (isempty(varargin{1}) || ischar(varargin{1}))
  S = varargin{1};
 end
end
% Checks S:
if isempty(S)
 S = 'on';
end
S = lower(S);
iS = strmatch(S,Sopt);
if isempty(iS)
 error('CVARGAS:cbfreeze:IncorrectStringOption',...
  ['Unrecognized ''' S ''' argument.' ])
else
 S = Sopt{iS};
end
% Looks for CBH:
CBH = cbfreeze(H); �H = cbhandle(H);
if ~strcmp(S,'del') && isempty(CBH)
 % Creates a colorbar and peer axes:
 pax = gca;
 CBH = colorbar('peer',pax);
else
 pax = [];
end

% -------------------------------------------------------------------------
% MAIN
% -------------------------------------------------------------------------
% Note: only CBH and S are necesary, but I use pax to avoid the use of the
%       "hidden" 'Axes' COLORBAR's property. Why... �
% Saves current position:
fig = get(  0,'CurrentFigure');
cax = get(fig,'CurrentAxes');
% Works on every colorbar:
for icb = 1:length(CBH)
 
 % Colorbar axes handle:
 h  = double(CBH(icb));
 
 % This application data:
 cbfreezedata = getappdata(h,cbappname);
 
 % Gets peer axes:
 if ~isempty(cbfreezedata)
  pax = cbfreezedata.pax;
  if ~ishandle(pax) % just in case
   rmappdata(h,cbappname)
   continue
  end
 elseif isempty(pax) % not generated
  try
   pax = double(get(h,'Axes'));  % NEW feature in COLORBARs
  catch
   continue
  end
 end
 
 % Choose functionality:
 switch S
 
  case 'del'
   % Deletes:
   if ~isempty(cbfreezedata)
    % Returns axes to previous size:
    oldunits = get(pax,'Units');
    set(pax,'Units','Normalized');
    set(pax,'Position',cbfreezedata.Position)
    set(pax,'Units',oldunits)
    set(pax,'DeleteFcn','')
    if isappdata(pax,axappname)
     rmappdata(pax,axappname)
    end
   end
   if strcmp(get(h,'BeingDelete'),'off')
    delete(h)
   end
  
  case {'un','off'}
   % Unfrozes:
   if ~isempty(cbfreezedata)
    delete(h);
    set(pax,'DeleteFcn','')
    if isappdata(pax,axappname)
     rmappdata(pax,axappname)
    end
    oldunits = get(pax,'Units');
    set(pax,'Units','Normalized')
    set(pax,'Position',cbfreezedata.Position)
    set(pax,'Units',oldunits)
    CBH(icb) = colorbar(...
     'peer'    ,pax,...
     'Location',cbfreezedata.Location);
   end
 
  otherwise % 'on'
   % Freezes:
 
   % Gets colorbar axes properties:
   cb_prop  = get(h);
  
   % Gets colorbar image handle. Fixed BUG, Sep 2009
   hi = findobj(h,'Type','image');
   
   % Gets image data and transform it in a RGB:
   CData = get(hi,'CData');
   if size(CData,3)~=1
    % It's already frozen:
    continue
   end
 
   % Gets image tag:
   Tag = get(hi,'Tag');
 
   % Deletes previous colorbar preserving peer axes position:
   oldunits = get(pax,'Units');
              set(pax,'Units','Normalized')
   Position = get(pax,'Position');
   delete(h)
   cbfreezedata.Position = get(pax,'Position');
              set(pax,'Position',Position)
              set(pax,'Units',oldunits)
 
   % Generates new colorbar axes:
   % NOTE: this is needed because each time COLORMAP or CAXIS is used,
   %       MATLAB generates a new COLORBAR! This eliminates that behaviour
   %       and is the central point on this function.
   h = axes(...
    'Parent'  ,cb_prop.Parent,...
    'Units'   ,'Normalized',...
    'Position',cb_prop.Position...
   );
 
   % Save location for future call:
   cbfreezedata.Location = cb_prop.Location;
 
   % Move ticks because IMAGE draws centered pixels:
   XLim = cb_prop.XLim;
   YLim = cb_prop.YLim;
   if     isempty(cb_prop.XTick)
    % Vertical:
    X = XLim(1) + diff(XLim)/2;
    Y = YLim    + diff(YLim)/(2*length(CData))*[+1 -1];
   else % isempty(YTick)
    % Horizontal:
    Y = YLim(1) + diff(YLim)/2;
    X = XLim    + diff(XLim)/(2*length(CData))*[+1 -1];
   end
 
   % Draws a new RGB image:
   image(X,Y,ind2rgb(CData,colormap),...
    'Parent'            ,h,...
    'HitTest'           ,'off',...
    'Interruptible'     ,'off',...
    'SelectionHighlight','off',...
    'Tag'               ,Tag...
   ) 
   % Removes all   '...Mode'   properties:
   cb_fields = fieldnames(cb_prop);
   indmode   = strfind(cb_fields,'Mode');
   for k=1:length(indmode)
    if ~isempty(indmode{k})
     cb_prop = rmfield(cb_prop,cb_fields{k});
    end
   end
  
   % Removes special COLORBARs properties:
   cb_prop = rmfield(cb_prop,{...
    'CurrentPoint','TightInset','BeingDeleted','Type',...       % read-only
    'Title','XLabel','YLabel','ZLabel','Parent','Children',...  % handles
    'UIContextMenu','Location',...                              % colorbars
    'ButtonDownFcn','DeleteFcn',...                             % callbacks
    'CameraPosition','CameraTarget','CameraUpVector','CameraViewAngle',...
    'PlotBoxAspectRatio','DataAspectRatio','Position',...
    'XLim','YLim','ZLim'});
  
   % And now, set new axes properties almost equal to the unfrozen
   % colorbar:
   set(h,cb_prop)
   % CallBack features:
   set(h,...
    'ActivePositionProperty','position',...
    'ButtonDownFcn'         ,@cbfreeze,...  % mhh...
    'DeleteFcn'             ,@cbfreeze)     % again
   set(pax,'DeleteFcn'      ,@cbfreeze)     % and again! 
 
   % Do not zoom or pan or rotate:
   setAllowAxesZoom  (zoom    ,h,false)
   setAllowAxesPan   (pan     ,h,false)
   setAllowAxesRotate(rotate3d,h,false)
  
   % Updates data:
   CBH(icb) = h;  
   % Saves data for future undo:
   cbfreezedata.pax       = pax;
   setappdata(  h,cbappname,cbfreezedata);
   setappdata(pax,axappname,h);
  
 end % switch functionality  
end  % MAIN loop

% OUTPUTS CHECK-OUT
% -------------------------------------------------------------------------
% Output?:
if ~nargout
 clear CBH
else
 CBH(~ishandle(CBH)) = [];
end
% Returns current axes:
if ishandle(cax)
 set(fig,'CurrentAxes',cax)
end