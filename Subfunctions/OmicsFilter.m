% OmicsFilter(O,nacut,logflag,scaleflag)
%
% Filtering of O is applied 
% conversion of 0 to NaN and deletion of all(isnan()) is applied
%
% O - @OmicsData object
% nacut - minimum number of measured data points [3]
% logflag - should logarithmic be applied [auto] (true,log2,log10)
% scaleflag - should normalization be applied [] (true,median,mean)
%
% Examples:
% O = OmicsFilter(O,0.8,log2);
% O = OmicsFilter(O);
% O = OmicsFilter(O,[],[],'median');

function O = OmicsFilter(O,nacut,logflag,scaleflag)

%% Remember data from file
dat_load = get(O,'data');
O = set(O,'data_load',[]);              % Put in container, so always keeps size
O = set(O,'data_load',dat_load,'data from file');

%% delete experiments with all nan
O = O(:,~all(isnan(O)));    

%% if no NA: 0 -> NA
if ~checknan(O)                                  % no nans in data, so write zeros as nans
    dat = get(O,'data');                          
    dat(dat==0) = nan;  
    O = set(O,'data',dat,'Replaced 0 by nan.');
end


%% Nacut
if ~exist('nacut','var') || isempty(nacut)
	nacut = 2;
end
if isnumeric(nacut)
	if nacut>=1
		O = O(sum(~isnan(O),2)>=nacut,:);
	elseif (nacut<1) && (nacut>0)
		O = O(sum(~isnan(O),2)>=nacut*size(O,2),:);
	else
		warning(['OmicsFilter: nacut ' num2str(nacut) ' not known. Expand code here. No transformation performed.'])
	end
else
	warning(['OmicsFilter: nacut ' nacut ' not known. Expand code here. No transformation performed.'])
end

%% Logflag
if ~exist('logflag','var') || isempty(logflag)
    logflag = 'auto';
end
if exist('logflag','var') && ~isempty(logflag)
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

%% Scaleflag
if exist('scaleflag','var') && ~isempty(scaleflag)
    switch scaleflag
        case {'true','median'}
            O = (O - nanmedian(O)) ./ nanstd(O);
        case 'mean'
            O = (O - nanmean(O)) ./ nanstd(O);
        otherwise
            warning(['OmicsFilter: scaleflag ' scaleflag ' not known. Expand code here. No transformation is performed.'])
    end
end
