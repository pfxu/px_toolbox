#datadir=/data/projects/Emory_monkey/AVP
datadir = /mnt/PX/Data/DataAnalysis

model=51subs_singlegroup #This is a GLM model set up using FSL's FEAT

sublist=51subs

#This first part is just making a mask in standard space for each subject
for sub in `cat ${sublist}.txt`
do
	for rest in 1 2
	do
	if [ ! -f /data/projects/Emory_monkey/AVP/${sub}/rest_${rest}/1_preprocess/4a_rest_mask2standard.nii.gz ]; then
	
		anatdir=anat_1

		echo "flirting ${sub}/rest_${rest} MASK"
		flirt -ref /frodo/shared/RH5_fsl/data/standard/macaque_MNI25_0.5mm_brain.nii.gz \
		-in /data/projects/Emory_monkey/AVP/${sub}/rest_${rest}/1_preprocess/4a_rest_mask.nii.gz \
		-out /data/projects/Emory_monkey/AVP/${sub}/rest_${rest}/1_preprocess/4a_rest_mask2standard \
		-applyxfm -init /data/projects/Emory_monkey/AVP/${sub}/rest_${rest}/2_reg/example_func2standard.mat -interp trilinear

	fi
	done
done

#This is transforming the preprocessed image into standard space for each subject
for sub in `cat ${sublist}.txt`
do
	for rest in 1 2
	do	
	if [ ! -f /data/projects/Emory_monkey/AVP/${sub}/rest_${rest}/1_preprocess/6_rest_ss2standard.nii.gz ]; then
	
		anatdir=anat_1

		echo "flirting ${sub}/rest_${rest} REST"
	
		flirt -ref /frodo/shared/RH5_fsl/data/standard/macaque_MNI25_0.5mm_brain.nii.gz \
		-in /data/projects/Emory_monkey/AVP/${sub}/rest_${rest}/1_preprocess/6_rest_ss.nii.gz -out /data/projects/Emory_monkey/AVP/${sub}/rest_${rest}/1_preprocess/6_rest_ss2standard \
		-applyxfm -init /data/projects/Emory_monkey/AVP/${sub}/rest_${rest}/2_reg/example_func2standard.mat -interp trilinear

	fi
	done
done


#This creates a list of images to include in the ICA  - this text file is fed into the ICA command. It needs to provide the full path to each subject file
if [ -f ${sublist}_filelist.txt ]; then rm ${sublist}_filelist.txt; fi

for sub in `cat ${sublist}.txt`
do

	printf "${datadir}/${sub}/rest_1/1_preprocess/6_lfo_ss2standard_2mm.nii.gz\n" >> ${sublist}_filelist.txt
done


#This creates a group mask that contains only voxels present in all subjects, this is fed into the ICA
if [ ! -f ${model}_mask.nii.gz ]; then

	tmpfile=`mktemp`
	for sub in `cat ${sublist}.txt`
	do

		echo ${datadir}/${sub}/rest_1/1_preprocess/4a_rest_mask2standard2standard.nii.gz >> ${tmpfile}
	done	

	files=$( cat ${tmpfile} )
	echo $files
	fslmerge -t ${sublist}_mask_concat.nii.gz $files
	rm ${tmpfile}
	echo "MAKING GROUP MASK"
	fslmaths ${sublist}_mask_concat.nii.gz -abs -Tmin -bin ${model}_mask.nii.gz
	rm ${sublist}_mask_concat.nii.gz
fi

#This is the melodic command, using temporal concatenation ICA
echo "RUNNING MELODIC!"
melodic -i  ${sublist}_filelist.txt -o ${sublist}_rest1_rest2_ICA -m ${model}_mask.nii.gz \
--nobet --report --tr=2 --Sdes=${datadir}/group_models/${model}.mat --Scon=${datadir}/group_models/${model}.con \
--Oall -v -a concat
