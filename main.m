%%%% main file for dictionary-based matching using 1-NN and LASSO regression %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% generate database
Hipp = importdata('HIPPARCOS.csv');
magshift=abs(min(Hipp.data(:,4))); % to shift mags upward
fov = [40,40]; % ra and dec
overlap=0.98; % p = overlap ratio
partial=true; % true for partial feature extraction
overflow = false; % true to laterally extrude (keep it false)
FOVs = extractRegionsfromSky(fov(1,1),fov(1,2),overlap,overflow); % extract FoVs for database generation
maglow=11.5;magup=max(Hipp.data(:,4)); %bound for mag between lower and upper
% max and min mag in catalog max(Hipp.data(:,4)) and min(Hipp.data(:,4))
magHipp = applyMagThreshold(Hipp.data,maglow,magup); % apply kappa to the database
for i=1:size(FOVs,1)
    stars = pickStarsfromDatabase(FOVs(i,:),magHipp,partial); % select stars for each FoV
    skypatch(i) = struct('starset',{stars});    
    database(i,:) = extractFeat(skypatch(i).starset,FOVs(i,:),magshift); % extract feat for each FoV 
end
% It is suggested to generate database and save it, and then
% in this step, just load the saved database instead of generating again at each attempt

%% simulate observation feature vector
rotationangle=60; % rotation angle of test image w.r.t. delta=0
% Note that camera rotation is in reverse direciton of rotation angle (CamRot = 360-rotationangle)
res = 937; % res x res of test image [pixels]
px=fov/res; % 1pixel=0.0448 degree for res = 937
pxmag=(magup-maglow)/255;%maxmag=14.5622 minmag=-1.0876 in Hipparcos catalog
% noise injection flags (true or false)
flag_noise_pos=false;flag_noise_mag=false;flag_falsestar=false;flag_missingstar=false;
noise_pos=[0,0,px,px];noise_mag=[0,pxmag];falsestar=0;missingstar=0;
% noise_pos = [mura,mudec,stdra,stddec], noise_mag = [mumag,stdevmag], falsestar = number, missingstar = number
% extract test feature vector with noise injected or not
test_fov = [0,0,fov]; % [ra0,dec0,fovra,fovdec]
[test_feat,runtime_featextract] = extractTestFeat(test_fov,maglow,magup,partial,rotationangle,...
            flag_noise_pos,flag_noise_mag,flag_falsestar,flag_missingstar,...
            noise_pos,noise_mag,falsestar,missingstar,Hipp);
test = struct('feat',{test_feat},'runtime',{runtime_featextract});

%% estimate FoV vector and theta
[reconst_test,estimate_FOV,estimate_CamRot,estimate_Theta,runtime] = estimate(fov(1,1),fov(1,2),overlap,database,FOVs,test_feat);

% denormalize the reconstructed observation feature vector
reconvert_reconst_test_MSE = reconvertReconst(reconst_test.MSE,database);
reconvert_reconst_test_1SE = reconvertReconst(reconst_test.oneSE,database);
if isnan(reconst_test.NN) == false
    reconvert_reconst_test = reconvertReconst(reconst_test.NN,database);
else
    reconvert_reconst_test = NaN;
end
reconvert_reconst = struct('MSE',{reconvert_reconst_test_MSE},'oneSE',{reconvert_reconst_test_1SE},'NN',{reconvert_reconst_test});

estimate = struct('FOV',{estimate_FOV},'Theta',{estimate_Theta},'CamRot',{estimate_CamRot},'runtime',{runtime},'reconstructed_test',{reconvert_reconst});

%% calculate errors
test_midpoint = [test_fov(1,1)+test_fov(1,3)/2;test_fov(1,2)+test_fov(1,4)/2];
test_realtheta = mod(test_feat(1,4)-rotationangle,360);
errFOV_MSE = norm(estimate_FOV.MSE - test_midpoint);
errFOV_1SE = norm(estimate_FOV.oneSE - test_midpoint);
errFOV = norm(estimate_FOV.NN - test_midpoint);
errTheta_MSE = estimate_Theta.MSE - test_realtheta;
errTheta_1SE = estimate_Theta.oneSE - test_realtheta;
errTheta = estimate_Theta.NN - test_realtheta;
errCamRot_MSE = estimate_CamRot.MSE + rotationangle;
errCamRot_1SE = estimate_CamRot.oneSE + rotationangle;
errCamRot = estimate_CamRot.NN + rotationangle;
if errCamRot_MSE<-180
	errCamRot_MSE = errCamRot_MSE+360;
elseif errCamRot_MSE>180
	errCamRot_MSE = errCamRot_MSE-360;
end
if errCamRot_1SE<-180
    errCamRot_1SE = errCamRot_1SE+360;
elseif errCamRot_1SE>180
    errCamRot_1SE = errCamRot_1SE-360;
end
if errCamRot<-180
    errCamRot = errCamRot+360;
elseif errCamRot>180
    errCamRot = errCamRot-360;
end

errorFOV = struct('MSE',{errFOV_MSE},'oneSE',{errFOV_1SE},'NN',{errFOV});
errorTheta = struct('MSE',{errTheta_MSE},'oneSE',{errTheta_1SE},'NN',{errTheta});
errorCamRot = struct('MSE',{errCamRot_MSE},'oneSE',{errCamRot_1SE},'NN',{errCamRot});
errors = struct('FOV',{errorFOV},'Theta',{errorTheta},'CamRot',{errorCamRot});

%% save results
results = struct('database_stars',{skypatch},'database',{database},'test',{test},'estimate',{estimate},'errors',{errors});

clearvars -except results
