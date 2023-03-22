% Performs geNorm identification of stable (housekeeping) genes

function res = geNorm(O)

if sum(get(O,'antna')>0)>0
    error('geNorm cannot work with NaN')
end

openR
dat = get(O,'data');
putRdata('dat',dat');
putRdata('IDs',get(O,'IDs'));
putRdata('snames',get(O,'snames'));
evalR('dimnames(dat)[[2]] <- IDs');
evalR('dimnames(dat)[[1]] <- snames');
evalR('save(dat,file="geNorm.Rdata")')

evalR('require(ctrlGene)')
evalR('res <- geNorm2(dat,ctVal=TRUE)') % ctVal should be true for data on log-space
evalR('save(dat,res,file="geNorm2.Rdata")')
res = getRdata('res');
closeR

