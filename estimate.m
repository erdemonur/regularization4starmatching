%% estimation by 1-nn and LASSO regression
function [reconst_test,estimate_FOV,estimate_CamRot,estimate_Theta,runtime] = estimate(fovra,fovdec,overlap,dataset_feat,FOVs,test_feat)

dataset_theta = dataset_feat(:,4); % allocate database theta
dataset_feat(:,4) = []; % remove theta from database feature vectors
featnum = size(dataset_feat,2);
for i=1:featnum
	mins(1,i) = min(dataset_feat(:,i));
	maxs(1,i) = max(dataset_feat(:,i));
end

for i=1:featnum
	dataset_feat(:,i) = (dataset_feat(:,i)-mins(1,i))/(maxs(1,i)-mins(1,i));
end

test_theta = test_feat(:,4); % pick test theta 
test_feat(:,4) = []; % remove theta from test feature vector

for i=1:featnum
    test_feat(1,i) = (test_feat(1,i)-mins(1,i))/(maxs(1,i)-mins(1,i));
end
tic 
[sorted,index] = closestEuclidDist(dataset_feat,test_feat);
time1nn = toc;

tic
[template,idx] = setDictionary(dataset_feat,[fovra,fovdec],overlap,index);
timeSetdict = toc;
            
template = template';
y = test_feat'; % observed vector
% dictionary = [top from left to right; middle; bottom]

template = template(1:featnum,:);
y = y(1:featnum,:);

[B,FitInfo] = lasso(template,y,...
'Lambda',linspace(0,5),'Alpha',1,'CV',size(y,1),'DFmax',4,'LambdaRatio',1e-2,'RelTol',1e-3,...
'PredictorNames',{'UpLeft','UpMid','UpRight','MidLeft','MidMid','MidRight','DownLeft','DownMid','DownRight'},'UseCovariance',true);
tic
[B,FitInfo] = lasso(template,y,...
'Lambda',linspace(0,5),'Alpha',1,'CV',size(y,1),'DFmax',4,'LambdaRatio',1e-2,'RelTol',1e-3,...
'PredictorNames',{'UpLeft','UpMid','UpRight','MidLeft','MidMid','MidRight','DownLeft','DownMid','DownRight'},'UseCovariance',true);
timeLasso = toc;

idxLambdaMinMSE = FitInfo.IndexMinMSE;
minMSEModelPredictors = FitInfo.PredictorNames(B(:,idxLambdaMinMSE)~=0);
idxLambda1SE = FitInfo.Index1SE;
sparseModelPredictors = FitInfo.PredictorNames(B(:,idxLambda1SE)~=0);

B_MSE = B(:,idxLambdaMinMSE);
B_1SE = B(:,idxLambda1SE);
normB_MSE = B_MSE/sum(B_MSE);
normB_1SE = B_1SE/sum(B_1SE);

reconst = NaN;
if isempty(B) == false
    reconst_MSE = template*B_MSE;
    reconst_normMSE = template*normB_MSE;
    reconst_1SE = template*B_1SE;
    reconst_norm1SE = template*normB_1SE;
elseif isempty(B) == true
    reconst = template(:,5);
end

predictFOV=NaN;
tic
templateFOV = [FOVs(idx(1),1),FOVs(idx(2),1),...
    FOVs(idx(3),1),FOVs(idx(4),1),FOVs(idx(5),1),...
    FOVs(idx(6),1),FOVs(idx(7),1),FOVs(idx(8),1),...
    FOVs(idx(9),1);...
    FOVs(idx(1),2),FOVs(idx(2),2),...
    FOVs(idx(3),2),FOVs(idx(4),2),FOVs(idx(5),2),...
    FOVs(idx(6),2),FOVs(idx(7),2),FOVs(idx(8),2),...
    FOVs(idx(9),2)]; 
if isempty(B) == false
    predictFOV_MSE = templateFOV*B_MSE;
    predictFOV_MSE(1,1) = predictFOV_MSE(1,1)+fovra/2;
    predictFOV_MSE(2,1) = predictFOV_MSE(2,1)+fovdec/2;
    predictFOV_normMSE = templateFOV*normB_MSE;
    predictFOV_normMSE(1,1) = predictFOV_normMSE(1,1)+fovra/2;
    predictFOV_normMSE(2,1) = predictFOV_normMSE(2,1)+fovdec/2;
    predictFOV_1SE = templateFOV*B_1SE;
    predictFOV_1SE(1,1) = predictFOV_1SE(1,1)+fovra/2;
    predictFOV_1SE(2,1) = predictFOV_1SE(2,1)+fovdec/2;
    predictFOV_norm1SE = templateFOV*normB_1SE;
    predictFOV_norm1SE(1,1) = predictFOV_norm1SE(1,1)+fovra/2;
    predictFOV_norm1SE(2,1) = predictFOV_norm1SE(2,1)+fovdec/2;
elseif isempty(B) == true % isempty bakmadan olabilir. LASSO etkisi görülür.
    predictFOV = [FOVs.FOVs(idx(5),1);FOVs.FOVs(idx(5),2)];
    predictFOV(1,1) = predictFOV(1,1)+fovra/2;
    predictFOV(2,1) = predictFOV(2,1)+fovdec/2;    
end

predictTheta = NaN;
predictCamRot = NaN;
templateTheta = [dataset_theta(idx(1),1),dataset_theta(idx(2),1),...
    dataset_theta(idx(3),1),dataset_theta(idx(4),1),dataset_theta(idx(5),1),...
    dataset_theta(idx(6),1),dataset_theta(idx(7),1),dataset_theta(idx(8),1),...
    dataset_theta(idx(9),1)];
if isempty(B) == false
    predictTheta_MSE = templateTheta*B_MSE;
    predictTheta_normMSE = templateTheta*normB_MSE;
    predictTheta_1SE = templateTheta*B_1SE;
    predictTheta_norm1SE = templateTheta*normB_1SE;
    predictCamRot_MSE = mod((predictTheta_MSE - test_theta),360);
    predictCamRot_normMSE = mod((predictTheta_normMSE - test_theta),360);
    predictCamRot_1SE = mod((predictTheta_1SE - test_theta),360);
    predictCamRot_norm1SE = mod((predictTheta_norm1SE - test_theta),360);
elseif isempty(B) == true 
    predictTheta = dataset_theta(idx(5),1);
    predictCamRot = mod((predictTheta - test_theta),360);
end
timePredict = toc;

reconst_test = struct('MSE',{reconst_normMSE},'oneSE',{reconst_norm1SE},'NN',{reconst});
estimate_FOV = struct('MSE',{predictFOV_normMSE},'oneSE',{predictFOV_norm1SE},'NN',{predictFOV});
estimate_CamRot = struct('MSE',{predictCamRot_normMSE},'oneSE',{predictCamRot_norm1SE},'NN',{predictCamRot});
estimate_Theta = struct('MSE',{predictTheta_normMSE},'oneSE',{predictTheta_norm1SE},'NN',{predictTheta});
runtime = struct('nn',{time1nn},'dict_setup',{timeSetdict},'lasso',{timeLasso},'estimate',{timePredict});

end