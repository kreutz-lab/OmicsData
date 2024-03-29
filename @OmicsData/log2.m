% O = log2(O)
% 
%   Applies a log2-transformation to the data (which should always be done
%   after loading raw data)

function O = log2(O,doInverse)
if ~exist('doInverse','var') || isempty(doInverse)
    doInverse = 0;    
end


dat = get(O,'data');

if ~doInverse % do log2
    if sum(dat(:)<0)>0
        warning('OmicsData/log2.m: Data has negative numbers, log2-transformation is refused.');
    else
        dat = double(dat);
        dat = log2(dat);
        dat(isinf(dat)) = NaN;
        
        O = set(O,'data',dat,'log2-transformation');
        O = set(O,'didLog',1);
    end
else % do 2^
    dat = 2.^dat;
    O = set(O,'data',dat,'2^ i.e. inverse log2-transformation');
    O = set(O,'didLog',0);
end
