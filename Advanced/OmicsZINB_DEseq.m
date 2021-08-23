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

