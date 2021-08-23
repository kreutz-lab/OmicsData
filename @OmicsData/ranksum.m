% res = ranksum(O,X,varargin)
% 
%   The two levels of X(:,1) is used for grouping
%   
%   gap is the gap between the two groups, if positive there is perfect
%   separation

function res = ranksum(O,X,varargin)

if size(X,2)>1
    warning('OmicsData/ranksum: Only the 1st column of X is considered for grouping.');
end
[uni,ia] = unique(X(:,1));


if length(uni)~=2
    error('OmicsData/ranksum: Only 2 levels can be handelled.');
end
dat = get(O,'data');
i1 = find(X(:,1)==uni(1));
i2 = find(X(:,1)==uni(2));

medianFold = nanmedian(dat(:,i2),2)-nanmedian(dat(:,i1),2);
gap = nanmin(dat(:,i2),[],2) - nanmax(dat(:,i1),[],2);
gap(medianFold<0) = nanmin(dat(medianFold<0,i1),[],2) - nanmax(dat(medianFold<0,i2),[],2);
gap(isnan(nanmin(dat(:,i1),[],2))) = NaN;
gap(isnan(nanmax(dat(:,i1),[],2))) = NaN;
gap(isnan(nanmin(dat(:,i2),[],2))) = NaN;
gap(isnan(nanmax(dat(:,i2),[],2))) = NaN;
p = NaN(size(dat,1),1);
for i=1:size(dat,1)
    if sum(~isnan(dat(i,i1)))>0 && sum(~isnan(dat(i,i2)))>0
        p(i) = ranksum(dat(i,i1),dat(i,i2),varargin{:});
    end
end

res = struct;
res.p = p;
res.medianFold = medianFold;
res.gap = gap;
res.levels = uni;


