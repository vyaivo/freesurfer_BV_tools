function outD = mgz2vmr(thisd)
% Given a data matrix from a Freesurfer .mgz file, converts to BrainVoyager
% anatomical (.vmr file).
% This has only been tested in ONE specific pipeline which assumes that
% nu.mgz is a skull-on, BV Talairach-ed anatomical in 1x1x1mm resolution
% (so the data matrix is 256x256x256mm). If you are deviating from this
% pipeline, you *must* double-check all your images -- use the
% plotAnatomical_BVOrient.m function for help.
% See repository README for more details.
%
% VAV 6/4/2018

% plotAnatomical_BVOrient(thisd, 'nu.mgz');

%%
% change order of the images
permd = permute(thisd,[3 1 2]);
% plotAnatomical_BVOrient(permd, 'permute thisd');

% rotate 3rd dimension by 180 degrees
rot_1 = [-cos(pi) sin(pi) 0 0;
    sin(pi) cos(pi) 0 0;
    0 0 1 0;
    0 0 0 1];

tform1 = affine3d(rot_1);
newd_1 = imwarp(permd, tform1);
newd_1(1,:,:) = [];
newd_1(:,end,:) = [];

% plotAnatomical_BVOrient(newd_1, 'flipped 3rd 180');

% now incorporate a L/R flip
rot_2 = [1 0 0 0;
        0 1 0 0;
        0 0 -1 0;
        0 0 0 1];
tform2 = affine3d(rot_2);
outD = imwarp(newd_1, tform2);

% plotAnatomical_BVOrient(newd_2, 'flipped L/R');