%  Applies the ZINB model and fills results with DESEQ (for features with
%  only one count>0 or features with no 0). 
% 
%   X       design matrix
% 
%   xnames  names of the predictors, i.e. the columns of X
% 
%   formulaDeseq    requires no lhs, i.e. ~predictors is appropriate
% 
%   formulaZINB    requires a lhs, i.e. counts~predictors is appropriate
% 
% Example:
% res = OmicsZINB_DEseq(O,X,{'group'},'',''); 
% % corresponds to:
% res = OmicsZINB_DEseq(O,X,{'group'},'~group','counts~group | 1');

function res = OmicsZINB_DEseq(O,X,xnames,formulaDeseq,formulaZINB)

disp('ZINB started ...')
res.ZINB = OmicsZinbPscl(O,X,xnames,formulaZINB);
disp('DEseq started ...')
res.DEseq = DESeq(O,X,xnames,formulaDeseq);
disp('OmicsZINB_DEseq finished.')

res.p = res.DEseq.p;
% use DEseq, where ZINB does not work (because of absent zeros):
res.p(res.ZINB.iuse) = res.ZINB.pCounts(res.ZINB.iuse,end);
res.log2Fold = res.DEseq.log2Fold;
res.usedZINB = zeros(size(res.p));
res.usedZINB(res.ZINB.iuse) = 1;

