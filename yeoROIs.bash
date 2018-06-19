#!/bin/bash
#
# This is just a wrapper to iterate through subjects and project the Yeo 2011 ROIs
# (saved under the subject 'yeoatlas') into each subject's own space.
# 
# Synopsis
#     yeoROIs <subj_id1> <subj_id2> ... <subj_idn>
#
# Required Arguments
#     <subj_id1>
#
# VAV created 6/19/18. vyaivo@ucsd.edu

## DEBUG
#set -x;

#### default arguments
root="/mnt/neurocube/local/serenceslab/retBV"

#### parse arguments

if [ "$#" -eq 0 ]; then
    echo "No arguments were passed."
    return
else
    subjs=( "$@" )
fi

hemis=( "lh" "rh" )

# now iterate over hemispheres and subjects
for hh in "${hemis[@]}"
do
    for ss in "${subjs[@]}"
    do        
        mri_surf2surf --srcsubject yeoatlas --trgsubject $ss --hemi $hh --sval-annot \
            $SUBJECTS_DIR/yeoatlas/label/$hh.Yeo2011_17Networks_N1000.annot \
            --tval $SUBJECTS_DIR/$ss/label/$hh.yeo.annot
        echo "FINISHED $ss $hh conversion from Yeo 2011 parcellation"
    done
done

# end the script
exit
