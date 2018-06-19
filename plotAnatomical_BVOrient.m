function plotAnatomical_BVOrient(vd, titleTxt)
% Plots a 3D matrix of anatomical MRI data in the canonical BrainVoyager
% viewing format. When given data from a BV Talairach-ed .vmr file, this
% should reproduce the same image as you see when you view the file in
% BrainVoyager (albeit in a different colormap).
% If you input a data matrix from a .nii or .mgz file, they will *not*
% match canonical BV viewing format because these data are in different
% orientations!
% See repository README for more details.
%
% VAV 6/4/2018

% % I checked this with a VMR
% vmr = BVQXfile('BG2_SAG_ISO_TAL.vmr');
% vd = vmr.VMRData;

if nargin < 2
    titleTxt = 'Anatomical BV Orient';
end

figure;

subplot(2,2,1); imagesc(squeeze(vd(:,:,128))'); axis equal;
subplot(2,2,2); imagesc(squeeze(vd(128,:,:))); axis equal;
subplot(2,2,3); imagesc(squeeze(vd(:,128,:))); axis equal;
suptitle(titleTxt);

return