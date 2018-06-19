function FShippoToVMR(sub)
% This assumes that the Freesurfer hippocampal subfield segmentation has
% completed without error. For a given subject, it converts the desired
% subfields (here hardcoded as CA1/CA3 & DG) to separate BrainVoyager
% anatomical files (.vmr), which can then be turned into regions of
% interest in a separate step.
%
% VAV 6/4/18

% %% this should go in the function arguments eventually
% sub = 'BG';

%% setup

% PATH STUFF
% need this for MRIread
addpath('/mnt/neurocube/local/freesurfer6/matlab/');
fsPath = sprintf('/mnt/neurocube/local/serenceslab/vy/FSDAT/ANAT/%s/mri/', sub);

% WHICH HIPPOCAMPAL ROIs DO YOU WANT?
ROIlabs = {'DG-CA3','CA1','subiculum'};
ROInums = {[210,208],206,205};

hemilist = {'lh','rh'};

% GET VMR TO OVERWRITE
vmr = BVQXfile(sprintf(...
    '/mnt/neurocube/local/serenceslab/retBV/%s2/Anat/%s2_SAG_ISO_TAL.vmr',...
    sub, sub));

%% combine ROIs across hemispheres
allD = [];
for hh = 1:numel(hemilist)
    % FSvoxelSpace is 1x1x1mm -- otherwise it was actually segmented at 0.333mm
    fn = sprintf('%s/%s.hippoSfLabels-T1.v10.FSvoxelSpace.mgz', fsPath, hemilist{hh});

    tmpf = MRIread(fn);
    mydat = tmpf.vol;
    outD = mgz2vmr(mydat);

    if hh == 1
        allD = outD;
    else
        allD = allD + outD;
    end

    clear tmpf outD;
end

%% mask out desired ROI

for rr = 1:numel(ROIlabs)
    myD = allD;
    ri = ismember(allD, ROInums{rr});
    % You can look at the number of voxels in your ROI by sum(ri(:))
    myD(~ri) = 0;
    myD(ri) = 240;
    
    %%
    % overwrite a VMR
    vmr2 = vmr;
    vmr2.VMRData = myD;

    savefn = sprintf('/mnt/neurocube/local/serenceslab/retBV/%s2/Anat/VOIs/%s2_hippo%s.vmr',...
        sub, sub, ROIlabs{rr});

    vmr2.SaveAs(savefn);
    fprintf('Saved %s!\n', savefn);

    clear vmr2 myD ri
end