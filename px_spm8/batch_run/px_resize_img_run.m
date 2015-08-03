clear
PI = '/Volumes/Data/PX/Baboons/DataSortReady/T1';
imnames = char(px_ls('rec',PI,'-F','.img'));
% imnames = '/Volumes/Data/PX/Baboons/DataSortReady/T1/BUDDY/5823_009_COR3D_FSPGR_14_Flip_2_NEX_20110510/BUDDY_20110510_5823_009_Gill_Baboon_new_3_COR3D_FSPGR_14_Flip_2_NEX.img';
Voxdim = [1 1 1];
BB = [nan nan nan; nan nan nan];
ismask = false;
resize_img(imnames, Voxdim, BB, ismask)