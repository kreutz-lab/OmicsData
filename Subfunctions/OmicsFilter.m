% OmicsFilter(O,nacut,logflag,scaleflag)
%
% Filtering of O is applied 
% conversion of 0 to NaN and deletion of all(isnan()) is applied
%
% O - @OmicsData object
% nacut - threshold of maximum number of NA [0]
% logflag - should logarithmic be applied [auto] (true,log2,log10)
% scaleflag - should normalization be applied [] (true,median,mean)
%
% Examples:
% O = OmicsFilter(O,0.8,log2);
% O = OmicsFilter(O);
% O = OmicsFilter(O,[],[],'median');

function O = OmicsFilter(O)

dat_load = get(O,'data');
O = set(O,'data_load',[]);              % Put in container, so always keeps size
O = set(O,'data_load',dat_load,'data from file');

if exists('nacut','var') && ~isempty(nacut)
    if isnumeric(nacut)
        if nacut>1
            O = O(sum(isnan(O),2)>=nacut,:);
        elseif (0<=nacut) && (nacut<=1)
            O = O(sum(isnan(O),2)>=nacut*size(O,2),:);
        else
            warning(['OmicsFilter: nacut ' nacut ' not known. Expand code here. No transformation performed.'])
        end
    else
        warning(['OmicsFilter: nacut ' nacut ' not known. Expand code here. No transformation performed.'])
    end
end
if exists('logflag','var') && ~isempty(logflag)
    switch logflag
        case {'true','log2'}
            O = log2(O);
        case 'log10'
            O = log10(O);
        case 'auto'
            if max(O)>100
                O=log2(O);   
            end
        otherwise
            warning(['OmicsFilter: logflag ' logflag ' not known. Expand code here. No transformation is performed.'])
    end
end
if exists('scaleflag','var') && ~isempty(scaleflag)
    switch scaleflag
        case {'true','median'}
            O = (O - nanmedian(O)) ./ nanstd(O);
        case 'mean'
            O = (O - nanmean(O)) ./ nanstd(O);
        otherwise
            warning(['OmicsFilter: scaleflag ' scaleflag ' not known. Expand code here. No transformation is performed.'])
    end
end

%% if no NA: 0 -> NA
if ~checknan(O)                                  % no nans in data, so write zeros as nans
    dat = get(O,'data');                          
    dat(dat==0) = nan;  
    O = set(O,'data',dat,'Replaced 0 by nan.');
end
O = O(:,~all(isnan(O)));                      % delete columns/experiments with all nan
