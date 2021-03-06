#!/bin/bash
#
# This script will convert your directory structure
# with already dicom mcverted images (gzipped niftis)
# to BIDS specification - TC

# Set folder names
inputdir="/Volumes/psych-cog/dsnlab/BIDS"
outputdir="/Volumes/psych-cog/dsnlab/BIDS"

studyid="bidstry"
subid="TAG666"
sessid="wave1"

declare -a rest_numruns=("01" "02") # run should have two digits 
declare -a tasks=("SVC" "DSD")
declare -a numruns=("01" "02") # run should have two digits; TO DO figure out how to run this when tasks have diff # of runs

# create directory structure for one subject
mkdir -p "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"
cd "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"
mkdir anat
mkdir func
mkdir dwi
mkdir fmap

# move files and generate corresponding jsons

# structural (mprage)
cp "${inputdir}"/"${subid}"/mprage/*.nii.gz "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/anat/sub-"${subid}"_ses-"${sessid}"_T1w.nii.gz
python /Volumes/psych-cog/dsnlab/BIDS/convert2bids/hdr2json.py -i "${inputdir}"/"${subid}"/mprage/*.txt -o "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/anat/sub-"${subid}"_ses-"${sessid}"_T1w.json -t mprage

# resting state 
for i in ${rest_numruns[@]}
	do 
	echo $i
		cp "${inputdir}"/"${subid}"/resting/run"$i"/*.nii.gz  "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-rest_run-"$i"_bold.nii.gz
		python /Volumes/psych-cog/dsnlab/BIDS/convert2bids/hdr2json.py -i "${inputdir}"/"${subid}"/resting/run"$i"/*.txt -o "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-rest_run-"$i"_bold.json -t rest
done
# tasks
for i in "${tasks[@]}"
	do 
	echo $tasks
	for j in "${numruns[@]}"
		do echo $numruns
		cp "${inputdir}"/"${subid}"/"$i"/run"$j"/*.nii.gz "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-"$i"_run-"$j"_bold.nii.gz
		python /Volumes/psych-cog/dsnlab/BIDS/convert2bids/hdr2json.py -i "${inputdir}"/"${subid}"/"$i"/run"$j"/*.txt -o "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-"$i"_run-"$j"_bold.json -t task
		done
	done

## dwi
for i in "${numruns[@]}"
	do 
	echo $i
		cp "${inputdir}"/"${subid}"/DTI/run"$i"/*.nii.gz  "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/dwi/sub-"${subid}"_ses-"${sessid}"_run-"$i"_dwi.nii.gz
		cp "${inputdir}"/"${subid}"/DTI/run"$i"/*bvals "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/dwi/sub-"${subid}"_ses-"${sessid}"_run-"$i"_dwi.bval
		cp "${inputdir}"/"${subid}"/DTI/run"$i"/*bvecs "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/dwi/sub-"${subid}"_ses-"${sessid}"_run-"$i"_dwi.bvec
		python /Volumes/psych-cog/dsnlab/BIDS/convert2bids/hdr2json.py -i "${inputdir}"/"${subid}"/DTI/run"$i"/*.txt -o "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_run-"$i"_dwi.json -t dwi
done