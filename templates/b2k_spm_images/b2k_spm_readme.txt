b2k = baboon mprage atlas
b2kmask = brain mask for atlas image (242 mL)
b2ktightmask = "tight" brain mask (185 mL)
b2kf = PET blood flow atlas

http://www.nil.wustl.edu/labs/kevin/ni/b2k/

MASK NOTE: The "b2ktightmask" is defined by the "median edge
of the brain" across all baboon images used to
create the template image.

We use the "b2kmask", defined as all voxels > 0,
for a loose mask (which we use for automated image
registration with our programs). (To see this in
SPM's "display", hit the "brighten" button several
times.)

ORIGIN NOTE: As explained elsewhere, the (0,0,0) origin of the Davis & Huffman
atlas falls at a nameless point near cerebellum. We shifted this orogin
in SPM to a more meaningful voxel in the center of the AC, (0,21,7) relative
to the center of the Davis & Huffman atlas.

ORIENTATION NOTE: Neurologic orientation, R on R

FILTER NOTE: For use as target images for registration, you will likely want to 
spatially filter the images and use the filtered copies as the registration
target. For our registration software, we use a 13mm FWHM Gaussian filter for 
MR-to-MR registration and a 19mm filter for PET-to-PET. The original 
template images are prettier for displaying results.
