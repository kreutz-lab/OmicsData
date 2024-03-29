% OmicsBoxplotMissings(O,[nbin],[option],[treatZeroAsMissing])
% 
%   This function produces a boxplot of the proportion of missing values
%   for the features depending on the median measurment
% 
%   It is the inverse depection which is produced by OmicsBoxplotMeanMissings
% 
%   nbin    the number of boxes, i.e. the number of bins for the medians
% 
%   option  x-values, e.g. 'mean', 'median'
%           If a number is provided, then it it interpreted as quantile in [0,1]
% 
%   treatZeroAsMissing  [false]
%           true: Zero is treated as missing value
% 
% See also OmicsBoxplotMeanMissings

function OmicsBoxplotMissings(O,nbin,option,treatZeroAsMissing)
if ~exist('nbin','var') || isempty(nbin)
    nbin = 20;
end
if ~exist('option','var') || isempty(option)
    option = 'median';    
end
if ~exist('treatZeroAsMissing','var') || isempty(treatZeroAsMissing)
    treatZeroAsMissing = false;    
end

if isnumeric(option)
    x = quantile(get(O,'data'),option,2);
    xlab = sprintf('%d %s percentile over features',option*100,'%');
else     
    xlab = [option, 'over features'];
    switch(option)
        case 'median'
            x = nanmedian(O,2);
        case 'mean'
            x = nanmean(O,2);
        otherwise
            %         error('Option %s unknown.',option);
            x = get(O,option);
    end
end

if treatZeroAsMissing
    antna = sum(isnan(O) | get(O,'data')==0,2) ./get(O,'ns');
    ylab = 'isnan or zero [%]';
else
    antna = sum(isnan(O),2)./get(O,'ns');
    ylab = 'isnan [%]';
end

[m2,rf] = sort(x);
antna2 = antna(rf)*100; % sorted according to x
anzProBin = ceil(length(x)/nbin);
antna2matrix = NaN(anzProBin,nbin);

binnames = cell(1,nbin);
for i=1:nbin
    ind = (i-1)*anzProBin + (1:anzProBin);
    ind(ind>length(x)) = []; 

    binnames{i} = sprintf('%.2f',nanmean(m2(ind)));
    antna2matrix(1:length(ind),i) = antna2(ind);
end

boxplot(antna2matrix,'labels',binnames,'labelorientation','inline');
set(gca,'YGrid','on','LineWidth',1.5,'FontSize',9);
xlabel(xlab)
ylabel(ylab);
title(strrep(get(O,'name'),'_','\_'));

