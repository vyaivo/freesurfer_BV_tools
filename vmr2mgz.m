function vmr2mgz(subID, copyToAnat)
% Given a BrainVoyager .vmr file in Talairach space, creates a
% corresponding FreeSurfer .mgz file known to work with the segmentation
% pipeline. Basically I simply rotated the data until the orientations
% matched the given Freesurfer file. Then I used the same header
% information in the Freesurfer file.
% This has only been tested with sample data from OUR LAB (orig_RR.mgz).
% Please check against your own .mgz file known to produce proper
% segmentations on your pipeline. Use the plotAnatomical_BVOrient.m function
% to help figure it out.
% See repository README for more details.
%
% VAV 6/5/2018

if nargin < 2
    % By default, copies to your $FREESURFER_DATA_PATH/ANAT/ folder
    copyToAnat = 1;
end

%% path stuff
% need this for MRIread
addpath('/mnt/neurocube/local/freesurfer6/matlab/');

fsPath = '/mnt/neurocube/local/serenceslab/vy/FSDAT/';
fsRAW = sprintf('%sRAW/', fsPath);
fsAnat = sprintf('%sANAT/', fsPath);
anatRoot = '/mnt/neurocube/local/serenceslab/retBV/';

% path to working Freesurfer mgz
if ~exist('orig_RR.mgz', 'file')
    % copy the file from BG
    unix(['cp ',fsRAW,'BG/NII/orig_RR.mgz .']);
end

% path to subject data
mypath = sprintf('%s%s/NII/', fsRAW, subID);
if ~exist(mypath,'dir')
    unix(['mkdir -p ',mypath]);
    fprintf('Created dir %s', mypath);
end

outfn = sprintf('%s%s/NII/orig.mgz', fsRAW, subID);


%%

% I'm loading in a correctly oriented orig.mgz
m1 = MRIread('orig_RR.mgz');

% We want to overwrite the data with our NII data. But keep the header
% since we know it's correct.

vmr = BVQXfile(sprintf('%s/%s2/Anat/talwskull/%s2_skull_TAL.vmr', anatRoot,...
    subID, subID));
newd = vmr.VMRData;
% plotAnatomical_BVOrient(newd,'vmr');
plotAnatomical_BVOrient(m1.vol,'mgz');

%% flip L/R

rot_lr = [1 0 0 0;
        0 1 0 0;
        0 0 -1 0;
        0 0 0 1];
tform0 = affine3d(rot_lr);
newd_0 = imwarp(newd, tform0);

% plotAnatomical_BVOrient(newd_0,'flipped0');

%%
permd = permute(newd_0, [2 3 1]);
% plotAnatomical_BVOrient(permd,'permuted');

%%
% now flip 3rd dimension by 180 degrees again
rot_2 = [cos(pi) 0 -sin(pi) 0;
    0 1 0 0;
    sin(pi) 0 cos(pi) 0;
    0 0 0 1];

tform2 = affine3d(rot_2);
newd_2 = imwarp(permd, tform2);

plotAnatomical_BVOrient(newd_2,'flipped2');

%%
newm = m1;
newm.vol = newd_2;

%%
err = MRIwrite(newm,outfn)

%%
if copyToAnat
    % create /mri/orig/
    [~,m] = unix(['mkdir -p ',sprintf('%s%s/mri/orig/', fsAnat, subID)])
    % copy orig.mgz to a few locations
    [~,m] = unix(['cp ',outfn,' ',sprintf('%s%s/mri/', fsAnat, subID)])
    [~,m] = unix(['cp ',outfn,' ',sprintf('%s%s/mri/orig/001.mgz', fsAnat, subID)])   
    [~,m] = unix(['cp ',outfn,' ',sprintf('%s%s/mri/rawavg.mgz', fsAnat, subID)])
end