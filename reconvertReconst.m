%% re-convert reconstructed estimation beta vector
function [reconvert_reconst_feat] = reconvertReconst(vector_reconst,dataset_feat)

reconvert_reconst_feat = zeros(5,1);
reconvert_reconst_feat(1,1) = vector_reconst(1,1)*(max(dataset_feat(:,1))-min(dataset_feat(:,1))) + min(dataset_feat(:,1));
reconvert_reconst_feat(2,1) = vector_reconst(2,1)*(max(dataset_feat(:,2))-min(dataset_feat(:,2))) + min(dataset_feat(:,2));
reconvert_reconst_feat(3,1) = vector_reconst(3,1)*(max(dataset_feat(:,3))-min(dataset_feat(:,3))) + min(dataset_feat(:,3));
reconvert_reconst_feat(4,1) = vector_reconst(4,1)*(max(dataset_feat(:,5))-min(dataset_feat(:,5))) + min(dataset_feat(:,5));
reconvert_reconst_feat(5,1) = vector_reconst(5,1)*(max(dataset_feat(:,6))-min(dataset_feat(:,6))) + min(dataset_feat(:,6));
% 5th element of database corresponds to 4th element of reconstructed test
% vector, and 6th to 5th
% because theta is excluded from feature vector
reconvert_reconst_feat = reconvert_reconst_feat';

end