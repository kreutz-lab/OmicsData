%  O = ConstructReferenceData(O,[cut])
%
%  take data with least #MVs
%  enlargen data by proteins with least #MVs normalized to all proteins
%
%  O - @OmicsData object
%  cut - minimum number of proteins kept for the reference data

function O = ConstructReferenceData(O,cut)

if ~exist('O','var')
    error('MissingValues/GetComplete.m requires class O as input argument.')
end
if ~exist('cut','var') || isempty(cut)
    cut = 0.2;
end
if ~isnumeric(cut) || cut<0 || cut>100
    warning(['ConstructReferenceData.m: ' cut ' is not supported. Check here. Used cut=0.2 instead.'])
end
if cut>1
    cut = cut/100;
end

% Save original
O = set(O,'data_original',[]);          % Put in container so it stays original (always same size)  
dat = get(O,'data');
O = set(O,'data_original',dat,'Original dataset');

% Count NA
[nasum,idxnan] = sort(sum(isnan(dat),2));
O = O(idxnan,:);

% Take data with <MV than at cut
nacut = nasum(ceil(size(dat,1)*cut)); % #MVs at cut
O2 = O(nasum<=nacut,:);               % all data with <MVs as at cut
idx1 = 1:size(O2,1);
idx2 = size(O2,1)+1:size(O,1);        % rest of the data

% Take data with <MV than at cut and assign mean/std of the other proteins
idxnew = [];
while length(idxnew)<length(idx2)
    if length(idxnew)+length(idx1)<length(idx2)
        idxnew = [idxnew, idx1];
    else
        idxnew = [idxnew, randsample(length(idx1),length(idx2)-length(idxnew))'];
    end
end
O2 = [O2; (O(idxnew,:)-nanmean(O(idxnew,:),2))./nanstd(O(idxnew,:),[],2)*nanstd(O(idx2,:),[],2)+nanmean(O(idx2,:),2)];

% sort reference by sum(nan)
[~,idxnan] = sort(sum(isnan(O2),2));
O = O2(idxnan,:);

% remember complete dataset
dat = get(O,'data');
O = set(O,'data_complete',[]);          % Put in container so it stays same 
O = set(O,'data_complete',dat,'Complete dataset');
O = set(O,'data',dat,'Complete');
