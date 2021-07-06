% OmicsHistMissings(O)
% OmicsHistMissings(O,dim)
% 
%   This function plots a histogram of the fraction of missing values 
% 
%       dim     [1]: sum over 1st dimension, i.e. proportions for samples 
%               2: sum over 2nd dimension, i.e. proportions for features 
% 
%  Example:
% OmicsHistMissings(O)
% OmicsHistMissings(O,2)

function OmicsHistMissings(O,dim)
if ~exist('dim','var') || isempty(dim)
    dim = 1;
end

if sum(sum(isnan(O)))==0
    warning('No NaN in data, zeros are plotted instead')
    xlab = 'Fraction of zeros';
    if dim==1
        hist(sum(get(O,'data')==0)/get(O,'nf'),100);
        ylab = '# Samples';
    elseif dim==2
        hist(sum(get(O,'data')==0,dim)/get(O,'ns'),100);
        ylab = '# Features';
    else
        error('Only dim=1 and dim=2 implemented.')
    end
else
    xlab = 'Missing Fraction';
    if dim==1
        hist(sum(isnan(O))/get(O,'nf'),100);
        ylab = '# Samples';
    elseif dim==2
        hist(sum(isnan(O),dim)/get(O,'ns'),100);
        ylab = '# Features';
    else
        error('Only dim=1 and dim=2 implemented.')
    end
end
xlabel(xlab)
ylabel(ylab);
title('Frequency of Missing Values');

