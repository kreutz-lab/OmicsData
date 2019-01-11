function imputation(path,clean)

global O

if ~exist('path','var')
    path = [];
end
if ~exist('clean','var') || clean
    imputation_clear  % clear previous imputations in O, optional
end

lib= 'mice';
methods = {'mean','norm','ri','pmm','sample','cart'};
impute_R(lib,methods,path)

lib= 'mice';
methods = {'midastouch','rf'};
impute_R(lib,methods,path)

lib= 'Amelia';
impute_R(lib,[],[]);

lib= 'Hmisc';
methods = {'pmm','regression'};
impute_R(lib,methods,path);

lib= 'pcaMethods';
methods = {'ppca','bpca','nipals','svd','svdImpute'};
impute_R(lib,methods,path);

lib= 'imputeLCMD';
methods = {'MinDet','KNN','MinProb','QRILC'};
impute_R(lib,methods,path);

lib= 'jeffwong';
path = 'C://Users/Janine/Documents/Repositories/imputation';
methods = {'SVTApproxImpute','SVDImpute','kNNImpute','lmImpute'};  %,'SVTImpute'
impute_R(lib,methods,path);

lib= 'missForest';
impute_R(lib,[],[]);

imputation_analysis;
saveO
%Paper_plots;