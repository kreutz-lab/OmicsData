% res = zinb(counts,X,xnames,formula)
% 
%   Zero inflated negative binomial model from the pcsl package
% 
% Example:
% res = zinb(counts,[X1,X2],{'xname1','xname2'},'counts~xname1+xname2');


function res = zinb(counts,X,xnames,formula)
if size(counts,2)==1
    counts = counts'; % has to be a row
end
if size(counts,2)~=size(X,1) && (~isempty(counts) && ~isempty(X))
    size(counts)
    size(xnames)
    error('size of count matrix does not fit to design matrix X');
end

if ~exist('formula','var') || isempty(formula)
    design = ['counts ~ ',xnames{1}];
    design2 = [' | ',xnames{1}];
    for i=2:length(xnames)
        design = [design,' + ',xnames{i}];
        design2 = [design2,' + ',xnames{i}];
    end
%     formula = [design,design2]
    formula = [design,' | 1'];
else
    fprintf('Formula: %s\n',formula);
end

ifactorial = find(sum(abs(X-round(X)),1)==0);
inum = setdiff(1:size(X,2),ifactorial);
if ~isempty(ifactorial)
    xvals = num2str([X(:,ifactorial),X(:,ifactorial)]);
    [xvalsUni,ia,ib] = unique(xvals,'rows');
    anzData = NaN(size(counts,1),size(xvalsUni,1));
    for i=1:size(xvalsUni,1)
        anzData(:,i) = sum(counts(:,find(ib==i))>0,2);
    end
    minAnzData = min(anzData,[],2);
    anz0 = sum(counts==0 | isnan(counts),2);
    
    iuse = find(minAnzData>=1 & anz0>0);
    % iuse = iuse(1:1000)
    fprintf('%i out of %i features (%.2f %s) have at least one zero-count and at least one count>0 in each condition\n',length(iuse),size(counts,1),100*length(iuse)/size(counts,1),'%');    
else
    iuse = 1:size(counts,1);
end
for i=1:size(counts,1)
    if length(unique(counts(i,~isnan(counts(i,:)))))<2 || nanmin(counts(i,:))>0
        iuse = setdiff(iuse,i);
    end
end
counts0 = counts;

counts = counts(iuse,:);
rounderror = max(abs(counts-round(counts)));
if rounderror>1000*eps
    warning('Non-integer counts, rounding makes a max error of %f',rounderror);
end
counts = round(counts);

openR;
putRdata('counts',counts);
putRdata('X',X);
putRdata('xnames',xnames);
putRdata('formula',formula);

evalR(['require(pscl)'])

dfstr = ['counts=counts[1,]'];
for i=1:length(xnames)
    dfstr = [dfstr,',',xnames{i},'=X[,',num2str(i),']'];
end
evalR(['df = data.frame(',dfstr,')'])

for i=1:length(ifactorial)
    evalR(['df$',xnames{ifactorial(i)},' <- as.factor(df$',xnames{ifactorial(i)},')'])
end

evalR('df[["counts"]] <- counts[1,]')
evalR(['res <- summary(zeroinfl(',formula,',data=df))'])
evalR('ncoef <- dim(res$coefficients$count)[1]')
evalR('ncoef0 <- dim(res$coefficients$zero)[1]')

evalR('pC <- matrix(nrow=dim(counts)[1],ncol=ncoef)')
evalR('p0 <- matrix(nrow=dim(counts)[1],ncol=ncoef0)')
evalR('coefC <- matrix(nrow=dim(counts)[1],ncol=ncoef)')
evalR('coef0 <- matrix(nrow=dim(counts)[1],ncol=ncoef0)')
evalR('predZero <- NaN*counts')
evalR('predCounts <- NaN*counts')
evstr = ['for(i in 1:dim(counts)[1]){ df[["counts"]] <- counts[i,]; fit <- zeroinfl(',formula,',data=df); predZero[i,] = predict(fit,newdata=df,"zero"); predCounts[i,]<-predict(fit,newdata=df,"count"); res <- summary(fit); pC[i,]<-array(res$coefficients$count[,4]); p0[i,]<-array(res$coefficients$zero[,4]); coefC[i,]<-array(res$coefficients$count[,1]); coef0[i,]<-array(res$coefficients$zero[,1]);} '];
disp(evstr)
evalR(evstr);
evalR('pC[is.na(pC)] <- NaN')
evalR('p0[is.na(p0)] <- NaN')

% evalR('a <- 1');
% res = getRdata('a')
% 
% saveimage('tmp_OmicsZinbPscl.Rdata')
p0 = getRdata('p0');
pC = getRdata('pC');

res.pZeros = NaN(size(counts0,1),size(p0,2));
res.coefZeros = NaN(size(counts0,1),size(p0,2));
res.pCounts = NaN(size(counts0,1),size(pC,2));
res.coefCounts = NaN(size(counts0,1),size(pC,2));
res.predZero = NaN(size(counts0,1),size(counts0,2));
res.predCounts = NaN(size(counts0,1),size(counts0,2));

if ~isempty(iuse)
    res.pZeros(iuse,:) = p0;
    res.pCounts(iuse,:) = pC;
    res.coefCounts(iuse,:) = getRdata('coefC');
    res.coefZeros(iuse,:) = getRdata('coef0');
    res.predZero(iuse,:) = getRdata('predZero');
    res.predCounts(iuse,:) = getRdata('predCounts');
end

% closeR

res.formula = formula;
res.iuse = iuse;


