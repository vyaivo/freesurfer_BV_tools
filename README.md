# freesurfer_BV_tools
Tools to convert between BrainVoyager anatomical files and Freesurfer anatomicals (with segmentations)

This is a set of tools I wrote to use Freesurfer to segment subject anatomies that were already pre-processed, normalized, and co-registered to functional data in Brainvoyager. I cannot guarantee the absolute accuracy of this code for your processing pipeline: please double-check ALL steps as indicated in the code comments.
The bulk of the work is done with vmr2mgz.m and mgz2vmr.m.

I assumed that you have used Freesurfer to segment a separate set of data successfully, and used the header information from a successfully segmented anatomy to convert into the Brainvoyager format in vmr2mgz.m. (This is much easier than attempting to convert between all BrainVoyager header information to Freesurfer header information.) If you have issues with this, please let me know so I can improve the code and/or give pointers.
