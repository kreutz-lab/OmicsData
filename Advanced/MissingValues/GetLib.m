function lib = GetLib(algo)

if iscell(algo) && length(algo)>1
	n = size(algo,2);
	libr = cell(1,n);
else
    algo = {algo};
	n=1;
end
for i=1:n
    lib = '';
	if strcmp(algo{i},'midastouch') || strcmp(algo{i},'rf') || strcmp(algo{i},'mean') || strcmp(algo{i},'norm') || strcmp(algo{i},'ri') || strcmp(algo{i},'pmm') || strcmp(algo{i},'sample') || strcmp(algo{i},'cart')
		lib= 'mice';
	end
	if strcmp(algo{i},'knn') || strcmp(algo{i},'impute.knn')
		lib= 'impute';
	end
	if strcmp(algo{i},'impnorm') || strcmp(algo{i},'imp.norm')
		lib= 'norm';
	end
	if strcmpi(algo{i},'Amelia')
		lib = 'Amelia';
	end
	if strcmp(algo{i},'regression') || strcmp(algo{i},'aregImpute')
		lib= 'Hmisc';
	end
	if strcmp(algo{i},'ppca') || strcmp(algo{i},'bpca') || strcmp(algo{i},'nipals') || strcmp(algo{i},'nlpca') || strcmp(algo{i},'svd') || strcmp(algo{i},'svdImpute')
		lib= 'pcaMethods';
	end
	if strcmp(algo{i},'MinDet') || strcmp(algo{i},'KNN') || strcmp(algo{i},'MinProb') || strcmp(algo{i},'QRILC')
		lib= 'imputeLCMD';
	end
	if strcmp(algo{i},'SVTApproxImpute') || strcmp(algo{i},'SVTImpute') || strcmp(algo{i},'SVDImpute') || strcmp(algo{i},'kNNImpute') || strcmp(algo{i},'lmImpute')
		lib= 'imputation';
		%path = 'C://Users/Janine/Documents/Repositories/imputation';
	end
	if strcmp(algo{i},'missForest')
		lib= 'missForest';
	end
	if strcmp(algo{i},'softImpute')
		lib= 'softImpute';
	end
	if strcmp(algo{i},'irmi')
		lib= 'VIM';
	end
	if strcmp(algo{i},'Seq') || strcmp(algo{i},'SeqRob') || strcmp(algo{i},'impSeq') || strcmp(algo{i},'impSeqRob')
		lib= 'rrcovNA';
	end
	if strcmp(algo{i},'MIPCA') || strcmp(algo{i},'imputePCA')
		lib= 'missMDA';
	end
	if strcmp(algo{i},'mi')
		lib= 'mi';
	end
	if strcmp(algo{i},'knnImputation')
		lib= 'DMwR';
	end
	if strcmp(algo{i},'GMSimpute') || strcmp(algo{i},'GMSLasso')
		lib= 'GMSimpute';
	end
	if ~exist('lib','var') || isempty(lib)
		warning(['GetLib.m: ' algo{i} ' is not implemented in DIMA and ignored for imputation. Check your spelling, or add respective Rcode to DoImputationsR.m and its library to GetLib.m.'])
	end
	if n>1
		libr{i} = lib;
    end
    if i==n && n>1
        lib = libr;
    end
end
if ~iscell(lib)
    lib = {lib};
end