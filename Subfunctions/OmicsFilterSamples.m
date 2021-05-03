% O = OmicsFilterSamples(O,pattern,nacut)
% 
% O - OmicsData object
% pattern - pattern in sample names for which OmicsFilterSample should be
% performed
% nacut - minimum of missing values in sample group [3]
%
% O = OmicsFilterSamples(O,{'20','21','22','23'},3);

function O = OmicsFilterSamples(O,pattern,nacut)

if ~exist('pattern','var') || isempty(pattern)
    warning('No Sample Filtering performed. Give information on which samples the minimum of MVs should appear (as cell array of string patterns).')
end
if ~exist('nacut','var') || isempty(nacut)
    nacut = 3;
end

S = get(O,'SampleNames');
idO = 1:size(O,1);

for i=1:length(pattern)
    id = find(sum(~isnan(O(:,contains(S,pattern{i}))),2)>=nacut);
    idO = idO(ismember(idO,id));
end

O = O(idO,:);
