% Centered log-ratio transformation, i.e. log2(x/geomean(x,1)
function O = OmicsCLR(O)

dat = get(O,'data');
dat = log2(dat./(geomean(dat,1)*ones(1,size(dat,2))));

O = set(O,'data',dat,'clr transformation applied');


