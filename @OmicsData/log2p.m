% O = log2p(O)
% 
%   Applies a log2-transformation to the data (which should always be done
%   after loading raw data) after adding 1
%   log2(data+1)

function O = log2p(O,doInverse)
if ~exist('doInverse','var') || isempty(doInverse)
    doInverse = 0;    
end


dat = get(O,'data');

if ~doInverse % do log2
    if sum(dat(:)<0)>0
        warning('OmicsData/log2.m: Data has negative numbers, log2-transformation is refused.');
    else
        dat = double(dat);
        dat = log2(dat+1);
        dat(isinf(dat)) = NaN;
        
        O = set(O,'data',dat,'log2p-transformation');
        O = set(O,'didLog',1);
    end
else % do 2^
    dat = 2.^dat-1;
    O = set(O,'data',dat,'2^ -1 i.e. inverse log2p-transformation');
    O = set(O,'didLog',0);
end
