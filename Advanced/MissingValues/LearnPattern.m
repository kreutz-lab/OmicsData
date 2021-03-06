%   A logistic regression model for the occurence of missing values
%
%   O   - @OmicsData object
%   bio - flag if biological information should be taken into account [false]
%
%   out - result of logistic regression function glmfit (incl. types+coefs)
%
% Example:
% out = LearnPattern(O);
% O = ConstructReferenceData(O);
% O = AssignPattern(O,out);

function out = LearnPattern(O,bio)

if ~exist('O','var')
    error('MissingValues/LearnPattern.m requires class O as input argument.')
end
if ~exist('bio','var')
    bio = [];
end

if ~any(any(isnan(O)))
    error('LearnPattern.m: No MV found. Check your data. Does imputation make sense? Maybe replace 0s by nan.')
end
drin = sum(isnan(O),2)<size(O,2);
O = O(drin,:);

% Subsample indices
nfeat = size(O,1);
if nfeat>1000
    nboot = ceil(nfeat/1000);  
    indrand = randperm(nfeat,nfeat);    
    nperboot = ceil(nfeat/nboot);
else
    nboot = 1;
end
    
% Initialize
b = nan(ceil(nfeat/nboot),nboot);
p = nan(ceil(nfeat/nboot),nboot);
out = struct;

for i=1:nboot  % subsample proteins
    if nboot>1
        fprintf('%i out of %i ...\n',i,nboot);
    end
    if nboot == 1
        ind = 1:nfeat;                              % if nfeat <1000, no subsample
    elseif  i==nboot
        ind = indrand( nperboot*(i-1)+1 : end );    % if last subsample, take indices till end
    else
        ind = indrand( nperboot*(i-1)+1 : nperboot*i );
    end
    
    [X,y,typ,typnames] = ConstructDesignMatrix(O(ind,:),out,bio);
    if i==1 || length(typ)+1>length(out.type)
        out.type = [0; typ]; % offset gets type=0
        out.typenames = ['offset'; typnames];
    end

    out.stats(i) = LogReg(X,y);
    
    b(1:length(out.stats(i).beta),i) = out.stats(i).beta;
    p(1:length(out.stats(i).p),i) = out.stats(i).p;
end

% output
brow = b(out.type==3,:);
brow = brow(brow~=0);                       % keep all row coefficients
out.b = [mean(b(out.type~=3),2,'omitnan'); brow];  % mean of coefficients over bootstrap
prow = p(out.type==3,:);
out.p = [mean(p(out.type~=3),2,'omitnan'); prow(:)];
out.type(end+1:length(out.b)) = out.type(end);
out.typenames(end+1:length(out.b)) = out.typenames(end);
out.X = X;
%PlotDesign(out,isnan(O(ind,:)),get(O,'path'))
end


function stats = LogReg(X,y)

w = ones(size(y));
[X,y] = GetRegularization(X,y);
w(end+1:length(y)) = 0.1;
%     lastwarn('');

if size(X,1)<50000   
     [~,~,stats] = glmfit(X,y,'binomial','link','logit','weight',w);    % faster
else
     mdl = fitglm(X,y,'Distribution','binomial','link','logit');        % works for tall matrices
     stats = struct;
     stats.beta = mdl.Coefficients.Estimate;
     stats.p = mdl.Coefficients.pValue;
end

%     if strcmp(lastwarn,'Iteration limit reached.')
%         opts = statset('glmfit');
%         opts.MaxIter = 1000; 
%         [~,~,stats] = glmfit(X,y,'binomial','link','logit','options',opts);
%     end
    
end
            