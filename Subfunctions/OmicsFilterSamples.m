% O = OmicsFilterSamples(O,pattern,nacut)
% 
% O - OmicsData object
% pattern - pattern in sample names for which OmicsFilterSample should be
% performed
% nacut - [3] minimum of missing values in sample 
%
% O = OmicsFilterSamples(O,{'20','21','22','23'},3);

function O = OmicsFilterSamples(O,pattern,nacut)
if ~exist('pattern','var') || isempty(pattern)
    pattern = '';
    warning('No pattern provided. All samples are evaluated.')
end
if ~exist('nacut','var') || isempty(nacut)
    nacut = 3;
end

S = get(O,'SampleNames');
idO = 1:size(O,2);

for i=1:length(pattern)
    id = find(sum(~isnan(O(:,find(contains(S,pattern{i})))),2)>=nacut);
    idO = idO(ismember(idO,id));
end

O = O(:,idO);

