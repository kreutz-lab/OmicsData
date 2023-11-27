function res = DESeq(O,X,xnames,design)
if ~exist('design','var') || isempty(design)    
    design = [' ~ ',xnames{1}];
    for i=2:length(xnames)
        design = [design,' + ',xnames{i}];
    end
end

counts = get(O,'data');

if get(O,'didLog')==1 
    disp('didLog==1: 2^data is used');
    counts = 2.^counts;
    counts(get(O,'wasZero')) = 0; % reverse log2(0) = NaN
end

if size(counts,1)<=100
    warning('DEseq might fail because of too few features');
end

openR;
putRdata('countData',counts);
putRdata('X',X);
putRdata('xnames',xnames);
putRdata('design',design);
% evalR('a<-1')
% getRdata('a')
% setwd
% saveRimage
% 
evalR(['require(DESeq2)'])
disp('DESeq.m: NaN is converted to zero');
evalR(['countData[is.na(countData)]<-0'])
evalR(['countData <- round(countData)'])

dfstr = ['"',xnames{1},'"=X[,',num2str(1),']'];
for i=2:length(xnames)
    dfstr = [dfstr,',"',xnames{i},'"=X[,',num2str(i),']'];
end
evalR(['df = data.frame(',dfstr,')'])

ifactorial = find(sum(abs(X-round(X)),1)==0);
for i=ifactorial
    disp(['DESeq.m: ',xnames{i},' is treated as factorial.'])
    evalR(['df$',xnames{i},' <- as.factor(df$',xnames{i},')'])
end
evalR(['dds <- DESeqDataSetFromMatrix(countData, df, ',design,')'])
evalR(['dds <- DESeq(dds)'])
evalR('coefname <- resultsNames(dds)[2]')
evalR(['res <- results(dds,name=coefname)'])
evalR(['p <- res$pvalue'])
evalR('log2Fold <- res[["log2FoldChange"]]')

evalR('require("apeglm")');
evalR('resLFC <- lfcShrink(dds, coef=coefname, type="apeglm")')
evalR('log2FoldChange <- resLFC[["log2FoldChange"]]')
evalR('log2Fold_pvalue <- resLFC[["pvalue"]]');
evalR('log2Fold_padj <- resLFC[["padj"]]');
% evalR('preg <- resLFC$pvalue');

%     evalR('save.image("DESeq.Rdata")')

    res.p = getRdata('p');
res.log2Fold = getRdata('log2Fold');
% res.preg = getRdata('preg');
res.coefname = getRdata('coefname');
disp(['DESeq here only returns the 2nd coefficient: ',res.coefname, ' PLEASE CHECK! And change the order of the X columns if required.'])
res.log2FoldChange = getRdata('log2FoldChange');
res.log2Fold_pvalue = getRdata('log2Fold_pvalue');
res.log2Fold_padj = getRdata('log2Fold_padj');
res.design = design;

closeR

