%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VISUALIZATION EXAMPLES
%


% Read in cluster of voxels

hipp = mask2clusters(which('spm2_hipp.img'));

%%

% 2D visualization of clusters 
cluster_orthviews(hipp, {[1 1 0]});

%%

% 3D visualization of clusters
figure
cluster_surf(hipp);

%%

% View of clusters on half brain with Limbic system added

create_figure('brain surface');
p = addbrain('limbic');

%%
cluster_surf(hipp, p);

%%
% Visualization of clusters on 3/4 brain

ycut_mm = -30;

% handles
p = [];

create_figure('brain surface');
p = addbrain('limbic');
delete(p(end)); p(end) = [];

set(p, 'FaceAlpha', .7)

p = [p addbrain('brainstem')];

set(gca, 'ZLim', [-85 82]);

set(p, 'FaceColor', [.5 .5 .5]);


overlay = which('SPM8_colin27T1_seg.img');
ovlname = 'SPM8_colin27T1_seg';

if ~isempty(ycut_mm);
    [D,Ds,hdr,p2,bestCoords] = tor_3d('whichcuts','y','coords',[0 -30 0], 'topmm', 90, 'filename', ovlname, 'intensity_threshold', 70);
    set(p2(1),'FaceColor',[.5 .5 .5]);
end

[D,Ds,hdr,p3,bestCoords] = tor_3d('whichcuts','x','coords',[-4 0 0], 'topmm', 90, 'filename', ovlname, 'intensity_threshold', 60, 'bottommm', -75);
set(p3(1),'FaceColor',[.5 .5 .5]);

colormap gray;
material dull;
axis off

view(133, 10);

lightRestoreSingle

lighting gouraud

%%

cluster_surf(hipp, p);


%%

% Visualization of connectivity

% Read in clusters 

load('/Users/martin/Documents/fMRIclass/fig_ivor_3d_connectivity/hewma_seed_regions.mat')

cl(1).shorttitle = 'VMPFCp';
cl(2).shorttitle = 'VMPFCr';
cl(3).shorttitle = 'Striatum';
cl(4).shorttitle = 'DLPFC';

names = {cl.shorttitle};
names{end + 1} = 'HR';

colors = {[1 0 0] [.3 .3 1] [.2 1 .2], [1 0 1] [1 .5 .5]};

classes = [1:5]';

% Add heart rate to clusters

clhr = sphere_roi_tool_2008([], 10, [0 11.1970 -57.0189]);
cl = merge_clusters(cl, clhr);


% Set up connectivity

C = [    0 0.5980965 0.2586625 0.5337405 0.1648760
    0 0.0000000 0.3264748 0.1970166 0.1513127
    0 0.0000000 0.0000000 0.7824718 0.0000000
    0 0.0000000 0.0000000 0.0000000 0.0000000
   0 0.0000000 0.0000000 0.0000000 0.0000000];

% Create figure

create_figure('nmdsfig_3d_glass');
h = addbrain('hires');
set(h, 'FaceAlpha', .1);
h2 = addbrain('hires left');
set(h2, 'FaceColor', [.5 .5 .5], 'FaceAlpha', .5);
h3 = addbrain('brainstem');
h4 = addbrain('caudate');
h5 = addbrain('putamen');
set([h3 h4 h5], 'FaceColor', [.5 .5 .6], 'FaceAlpha', .5);

axis image; view(129, 18); lighting gouraud; axis off; material dull

%%

[mov, linehandles, linehandles2] = cluster_nmdsfig_glassbrain(cl, classes, colors, C,[], 'blobs', 'samefig', 'nobrain');

material dull
lightRestoreSingle
camlight right


