function res = Omics_DEseq(O,X,xnames,formulaDeseq)

disp('DEseq started ...')
res.DEseq = DESeq(O,X,xnames,formulaDeseq);

res.p = res.DEseq.p;
% use DEseq, where ZINB does not work (because of absent zeros):
res.log2Fold = res.DEseq.log2Fold;

