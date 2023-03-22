% [p,ci,stats] = MinimalEffectTest(O,indg1,indg2,paired,varequal)
% 
%   T-test for testing equal means.
%   The function calls MinimalEffectTest.m or (if paired==true) ttest.m
% 
%   O       @OmicsData
% 
%   delta 
% 
%   indg1   indices indication samples of group1
% 
%   indg2   indices indication samples of group2
% 
%   paired  Should a paired t-test be applied
%           Default: false
% 
%   varequal    Should equal variance be assumed?
%           Default: true
% 
%   p       p-values (indicating significance of having different means)
% 
%   ci      confidence intervals for the difference of the means (see doc MinimalEffectTest)
% 
%   stats   more details statistics (see doc MinimalEffectTest)
%               stats.tstat
%               stats.df
%               stats.sd
% 
% Examples:
% [p,ci,stats] = MinimalEffectTest(O,1,1:3,4:6);  % standard t-test
% 
% [p2,ci,stats] = MinimalEffectTest(O,1,1:3,4:6,true);  % paired t-test
% 
% [p3,ci,stats] = MinimalEffectTest(O,1,1:3,4:6,[],false);  % t-test with unequal variances
% 
% plotmatrix([p,p2,p3])

function [p,ci,stats] = MinimalEffectTest(O,delta,indg1,indg2,paired,varequal)
if nargin<3
    error('OmicsData/MinimalEffectTest.m requires at least three arguments.')
end

if ~exist('paired','var') || isempty(paired)
    paired = false;
elseif paired
    if length(indg1)~=length(indg2)
        error('OmicsData/MinimalEffectTest.m: Paired tests require the same number of replicates in both groups.')
    end
end

if ~exist('varequal','var') || isempty(varequal)
    varequal = true;
end

if ~isempty(intersect(indg1,indg2))
    error('OmicsData/MinimalEffectTest.m: Both groups should not contain the same samples.')
end

dat = get(O,'data');
nf  = size(dat,1);  % number of features, e.g. number of proteins

p  = NaN(nf,1);
ci = NaN(nf,2);
stats = cell(nf,1);
for i=1:size(dat,1)
    if paired
%         [~,p(i),ci(i,:),stat] = ttest(dat(i,indg1)-dat(i,indg2));
    else  % unpaired        
        if varequal
            stat = MinimalEffectTest(dat(i,indg1),dat(i,indg2),delta,'vartype','equal');
            p(i) = stat.p2;
        else
            stat = MinimalEffectTest(dat(i,indg1),dat(i,indg2),delta,varargin,'vartype','unequal');
            p(i) = stat.p2;
        end
    end
    
%     if i==1
%         stats = stat;
%     else
        stats{i} = stat;
%     end
end

