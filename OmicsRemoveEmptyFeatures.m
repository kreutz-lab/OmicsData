% O = OmicsRemoveEmptyFeatures(O,minN)
% 
%   This function eliminates rows/features which do not have a minimal
%   number of ~isnan && ~isinf data points.
% 
%   minN    the minmum number
%           [1] is the default value
% 
%           if minN<1, then it is intepreted as fraction, i.e. 0.2 means
%           available in at least 20% of samples

function [O,drin] = OmicsRemoveEmptyFeatures(O,minN)
if ~exist('minN','var') || isempty(minN)
    minN = 1;
elseif minN<1 % interpreted as a fraction
    minN = ceil(minN*size(O,2));
end

dat = get(O,'data');
if sum(isnan(dat(:))==0)
    warning('OmicsRemoveEmptyFeatures.m: No NaN, treat 0 as NaN.')
    dat(dat==0) = NaN;
end
drin = find(sum(~isnan(dat) & ~isinf(dat),2)>=minN);

O = O(drin,:);
