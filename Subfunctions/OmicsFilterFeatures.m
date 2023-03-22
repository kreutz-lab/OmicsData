% O = OmicsFilterFeatures(O,pattern,nacut)
% 
% O - OmicsData object
% pattern - pattern in sample names for which OmicsFilterSample should be
% performed
% nacut - minimum of missing values in sample group [3]
%
% O = OmicsFilterFeatures(O,{'20','21','22','23'},3);

function O = OmicsFilterFeatures(O,pattern,nacut)

if ~exist('pattern','var') || isempty(pattern)
    pattern = ''; % all features
    warning('No pattern provided. All features are evaluated.')    
end
if ~exist('nacut','var') || isempty(nacut)
    nacut = 0; % no restriction based on NA
end

if ~iscell(pattern)
    pattern = {pattern};
end

S = get(O,'IDs');
idO = 1:size(O,1);

for i=1:length(pattern)
    id = intersect(find(contains(S,pattern{i})), find(sum(~isnan(O),2)>=nacut));
    idO = idO(ismember(idO,id));
end

O = O(idO,:);
