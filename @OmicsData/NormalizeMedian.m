% O = NormalizeMedian(O,antAnzNa)
% 
%   applies a median normalization using only features, with proportion or
%   number of zeros/NaN smaller than antAnzNa
% 
%   antAnzNa    [] 
%               If isempty, then no filtering is applied
%               If smaller than 1, then proportions are considered
%               If larger than 1, then absolute numbers are considered
% 
%   useMean     [0]
%               if 1, then the mean is used instead of the median

function O = NormalizeMedian(O,antAnzNa,useMean)
if ~exist('useMean','var') || isempty(useMean)
    useMean = 0;
end

if isempty(antAnzNa)
    ind = 1:get(O,'nf');
elseif antAnzNa<1
    if sum(sum(isnan(O)))>0
        ind = find(get(O,'antna')<=antAnzNa);
    else
        ind = find(get(O,'ant0')<=antAnzNa);
    end
else
    if sum(sum(isnan(O)))>0
        ind = find(sum(isnan(O),2)<=antAnzNa);
    else
        ind = find(sum(get(O,'data')==0,2)<=antAnzNa);
    end
end

if ~useMean
    m = nanmedian(O(ind,:),1);
else
    m = nanmean(O(ind,:),1);
end    

dat = get(O,'data');
min1 = nanmin(dat(:));

dat2 = dat-ones(size(O,1),1)*m;
dat2 = dat2 - nanmin(dat2(:)) + min1; % same minimal value
O = set(O,'data',dat2,['NormalizeMedian with antAnzNa=',num2str(antAnzNa)]);

