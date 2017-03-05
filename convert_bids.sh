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

# Convert mprage
mkdir -p "${outputdir}"/"${studyid}"/sub-"${subid}"/"${sessid}"
cd "${outputdir}"/"${studyid}"/sub-"${subid}"/"${sessid}"
mkdir anat
mkdir func
mkdir dwi
mkdir fmap

cp "${inputdir}"/"${subid}"/mprage/*.nii.gz "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/anat/sub-"${subid}"_ses-"${sessid}"_T1w.nii.gz

cp "${inputdir}"/"${subid}"/resting/*.nii.gz "${outputdir}"/"${studyid}"/sub-"${subid}"/ses-"${sessid}"/func/sub-"${subid}"_ses-"${sessid}"_task-rest_run-1_bold.nii.gz