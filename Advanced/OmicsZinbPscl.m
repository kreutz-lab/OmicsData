% res = OmicsZinbPscl(O,X,xnames,formula)
% 
%   
function res = OmicsZinbPscl(O,X,xnames,formula)
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

counts = get(O,'data');
if get(O,'didLog')==1 
    disp('2^data => use this');
    counts = 2.^counts;
    
    counts = round(counts);
    counts(isnan(counts)) = 0;
    disp('OmicsZinbPscl: Counts are rounded and NaN is converted to zero.')
end

ifactorial = find(sum(abs(X-round(X)),1)==0);
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

counts = counts(iuse,:);

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
evstr = ['for(i in 1:dim(counts)[1]){ df[["counts"]] <- counts[i,]; res <- summary(zeroinfl(',formula,',data=df)); pC[i,]<-array(res$coefficients$count[,4]); p0[i,]<-array(res$coefficients$zero[,4]); coefC[i,]<-array(res$coefficients$count[,1]); coef0[i,]<-array(res$coefficients$zero[,1]);} '];
disp(evstr)
evalR(evstr);

% evalR('a <- 1');
% res = getRdata('a')
% 
% saveimage('tmp_OmicsZinbPscl.Rdata')
p0 = getRdata('p0');
pC = getRdata('pC');

res.pZeros = NaN(size(O,1),size(p0,2));
res.coefZeros = NaN(size(O,1),size(p0,2));
res.pCounts = NaN(size(O,1),size(pC,2));
res.coefCounts = NaN(size(O,1),size(pC,2));

res.pZeros(iuse,:) = p0;
res.pCounts(iuse,:) = pC;
res.coefCounts(iuse,:) = getRdata('coefC');
res.coefZeros(iuse,:) = getRdata('coef0');

% closeR

res.formula = formula;
res.iuse = iuse;

% Rinit;
% Rpush('counts',counts);
% Rpush('X',X);
% Rpush('xnames',xnames);
% Rpush('desig',design);
% Rrun('a <- 10')
% Rrun(['setwd("',strrep(pwd,'\','/'),'")'])
% Rrun('save.image("tmp.Rdata")');
