% DIMA: Data-driven selection of an imputation algorithm (Egert et al.)
%
% - Learn pattern of missing values
% - Define reference data R with fewer MVs
% - Generate patterns of missing values to R
% - Apply multiple imputation algorithms
% - Impute original data with best-performing imp. algorithm
%
% Example:
% O = OmicsData(file);
% O = OmicsFilter(O);
% O = DIMA(O);

function [O,out] = DIMA(O,methods,npat,bio,Rpath,Rlibpath)

if ~exist('methods','var')
    methods = [];
end
if ~exist('bio','var')
    bio = [];
end
if ~exist('npat','var')
    npat = [];
end

O = OmicsFilter(O);

%% Pattern generation
out = LearnPattern(O,bio);
O2 = ConstructReferenceData(O);
O2 = AssignPattern(O2,out,npat);

%% Imputations
O2 = DoImputations(O2,methods,[],[],Rpath,Rlibpath);
[O2,algo] = EvaluatePerformance(O2);
saveO(O2,[],'O_imputations');

%% Original imputation
O = DoOptimalImputation(O,algo,[],[],Rpath,Rlibpath); 
