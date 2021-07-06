% OmicsBoxplotMeanMissings(O)
% OmicsBoxplotMeanMissings(O,nbin,quant)
% 
%   This function produces a boxplot of the median intensities 
%   for the features depending on proportion of missing values.
% 
%   It is the inverse depection which is produced by OmicsBoxplotMissings
% 
%   nbin    the number of boxes, i.e. the number of bins for the medians
% 
%   quant    Which quant of the data-rows is plotted? 
%               Default: 0.5, i.e. the median
% 
% 
% See also OmicsBoxplotMissings
% 
% Example:
% OmicsBoxplotMeanMissings(O,[],0.9) % if many zeros/missing values

function OmicsBoxplotMeanMissings(O,nbin,quant)
if ~exist('nbin','var') || isempty(nbin)
    nbin = 20;
end
if ~exist('quant','var') || isempty(quant)
    quant = 0.5;
    ylab = 'median';
elseif quant==0.5
    ylab = 'median';    
else
    ylab = sprintf('%d %s percentile',quant*100,'%');
end

if quant==0.5
    m = nanmedian(O,2);
else
    m = quantile(get(O,'data'),quant,2);
end

antna = sum(isnan(O),2)./get(O,'ns');
dat   = get(O,'data');
if median(antna)<0.01 & sum(dat(:)==0)>0.1*prod(size(dat))
    warning('Few NaNs & a lot of zeros: Zeros are analyzed instead of NaN');
    antna = sum(dat==0,2)./get(O,'ns');
    xlab = 'zeros';
else
    xlab = 'isnan';
end

[antna2,rf] = sort(antna);
m2 = m(rf); % sorted according to antna

anzProBin = ceil(length(m)/nbin);
m2matrix = NaN(anzProBin,nbin);

binnames = cell(1,nbin);
for i=1:nbin
    ind = (i-1)*anzProBin + (1:anzProBin);
    ind(ind>length(m)) = []; 

    binnames{i} = sprintf('%.2f',nanmean(antna2(ind)));
    m2matrix(1:length(ind),i) = m2(ind);
end

boxplot(m2matrix,'labels',binnames,'labelorientation','inline');
set(gca,'YGrid','on','LineWidth',1.5,'FontSize',9);
xlabel(xlab);
ylabel(ylab)
title(strrep(get(O,'name'),'_','\_'));

