% make TAL brains with skulls on them
% VAV 4/17/18

% Note: Needs NeuroElf, remove BVQXtools from your path!

root = '/mnt/neurocube/local/serenceslab/retBV/';
mydir = 'talwskull/';

subj = {'AV2', 'BC2', 'BG2', 'BH2', 'BI2', 'BJ2', 'BO2', 'BR2', 'BV2', 'BW2'};
ns = numel(subj);

for ss = 1:ns
    % Ugh...we can make SAG but not ISO brain in MATLAB.
    %vmr = xff(sprintf('%s.vmr', subj{ss}));
    %vmr_sag = vmr.SetConvention(1);
    sroot = [root, subj{ss}, '/Anat/'];
    
    vmr1 = xff(sprintf('%s%s%s_skull_ISO.vmr', sroot, mydir, subj{ss}));
    vmr_sag = vmr1.SetConvention(1);
    
    acpc = xff(sprintf('%s%s_SAG_ISO_ACPC.trf', sroot, subj{ss}));
    vmr2 = vmr_sag.ApplyTrf(acpc);
    
    tal = xff(sprintf('%s%s_SAG_ISO_ACPC.tal', sroot, subj{ss}));
    vmr3 = vmr2.Talairach('linear', tal);
    
    vmr3.SaveAs(sprintf('%s%s%s_skull_TAL.vmr', sroot, mydir, subj{ss}));
    
    clear vmr1 vmr_sag acpc vmr2 tal vmr3
    
end