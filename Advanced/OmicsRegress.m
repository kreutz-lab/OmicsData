function data = OmicsRegress(data,opts)

if ~isfield(opts,'Model')
    opts.Model = ''; % default, corresponds to multipe regression/LM
end

if iscell(data)
    for i=1:length(data)
        data{i} = OmicsRegress(data{i},opts);
    end
else
    
    label = data.label;
    O = data.O;
    
    res = struct;
    for i=1:length(opts.Design)
        design = opts.Design{i};
        reg_strength = opts.Regularization(i);
        
        warning('off','stats:regress:RankDefDesignMat');
        
        [res.X{i},res.xnames{i},res.grouplevels{i}] = DefineX(O,design);
        if sum(strcmp(res.xnames{i},str2fieldname(res.xnames{i}))==0)>0
            error('Define xnames that the can serve as fieldnames of a struct!')
        end
        switch opts.Model{i}
            case {'LM',''}
                [res.p{i},~,res.fold{i},res.varest{i},res.foldSE{i}] = regress(O,res.X{i});
                
                res.mean{i} = nanmean(O,2);
                
                use = ~isnan(res.varest{i}) & ~isinf(res.varest{i}) & res.varest{i}>1e-10;
                res.varestS{i} = NaN(size(res.varest{i}));
                res.varestS{i}(use) = smooth(res.mean{i}(use),sqrt(res.varest{i}(use)),1000,'lowess').^2;
                [~,iu] = unique(res.mean{i}(use));
                [~,iu2] = unique(res.mean{i}(~use));
                x = res.mean{i}(use);
                y = res.varestS{i}(use);
                xx = res.mean{i}(~use);
                tmp = NaN(size(xx));
                tmp(iu2) = interp1(x(iu),sqrt(y(iu)),xx(iu2),'linear','extrap').^2;
                res.varestS{i}(~use) = tmp;
                
                %% for features with less NaN, use only varest form those features:
                lessNaN = get(O,'propna')<0.2;
                res.varestS{i}(lessNaN) = smooth(res.mean{i}(lessNaN),sqrt(res.varest{i}(lessNaN)),1000,'lowess').^2;
                
                %% regularized regression
                [res.pr{i},~,res.foldr{i},res.foldrSE{i}] = regress_reg(O,res.X{i},res.varestS{i},reg_strength);
                
                % res.fdr{i} = FdrKorrekturMitR2(res.p{i},[],1);
                % res.fdrr{i} = FdrKorrekturMitR2(res.pr{i},[],1);
                [~,~,~,res.fdr{i}] =fdr_bh(res.p{i});
                [~,~,~,res.fdrr{i}]=fdr_bh(res.pr{i});
                
                res.label{i} = [label,', ',opts.Design{i},', PriorW=',num2str(reg_strength)];
                
                warning('on','stats:regress:RankDefDesignMat');
                
            case {'LM_ranks'} % LM on ranks, NaN are kept, mean and SD same
                dat = get(O,'data');
                ms = nanmean(dat,2);
                sds = nanstd(dat,[],2);
                for ii=1:size(dat,1)
                    indna = find(isnan(dat(ii,:)));
                    dat(ii,:) = rankasgn_fast(dat(ii,:));
                    dat(ii,indna) = NaN;
                end
                dat = dat-(nanmean(dat,2)*ones(1,size(dat,2))); % set mean=0 
                dat = dat./(nanstd(dat,[],2)*ones(1,size(dat,2))); % set SD=1 

                dat = dat.*(sds*ones(1,size(dat,2))); % set old SD
                dat = dat+(ms*ones(1,size(dat,2))); % set old mean

                Orank = set(O,'data',dat,'RanktransformationSameMeanSD');
                [res.p{i},~,res.fold{i},res.varest{i},res.foldSE{i}] = regress(Orank,res.X{i});
                
                res.mean{i} = nanmean(O,2);
                
                use = ~isnan(res.varest{i}) & ~isinf(res.varest{i}) & res.varest{i}>1e-10;
                res.varestS{i} = NaN(size(res.varest{i}));
                res.varestS{i}(use) = smooth(res.mean{i}(use),sqrt(res.varest{i}(use)),1000,'lowess').^2;
                [~,iu] = unique(res.mean{i}(use));
                [~,iu2] = unique(res.mean{i}(~use));
                x = res.mean{i}(use);
                y = res.varestS{i}(use);
                xx = res.mean{i}(~use);
                tmp = NaN(size(xx));
                tmp(iu2) = interp1(x(iu),sqrt(y(iu)),xx(iu2),'linear','extrap').^2;
                res.varestS{i}(~use) = tmp;
                
                %% for features with less NaN, use only varest form those features:
                lessNaN = get(O,'propna')<0.2;
                res.varestS{i}(lessNaN) = smooth(res.mean{i}(lessNaN),sqrt(res.varest{i}(lessNaN)),1000,'lowess').^2;
                
                %% regularized regression
                [res.pr{i},~,res.foldr{i},res.foldrSE{i}] = regress_reg(Orank,res.X{i},res.varestS{i},reg_strength);
                
                % res.fdr{i} = FdrKorrekturMitR2(res.p{i},[],1);
                % res.fdrr{i} = FdrKorrekturMitR2(res.pr{i},[],1);
                [~,~,~,res.fdr{i}] =fdr_bh(res.p{i});
                [~,~,~,res.fdrr{i}]=fdr_bh(res.pr{i});
                
                res.label{i} = [label,', LM_ranks ',opts.Design{i},', PriorW=',num2str(reg_strength)];

                warning('on','stats:regress:RankDefDesignMat');
                
            case 'ZINB_DEseq'
                r = OmicsZINB_DEseq(O,res.X{i},res.xnames{i},'','');
                res.mean{i} = nanmean(O,2);
                res.p{i} = r.p;
                res.fold{i} = r.log2Fold;
                res.pr{i} = r.p;
                res.foldr{i} = r.log2Fold;
                res.label{i} = [label,', ZINB',r.ZINB.formula,' or DEseq ',r.DEseq.design];
                
                [~,~,~,res.fdr{i}] =fdr_bh(res.p{i});
                [~,~,~,res.fdrr{i}]=fdr_bh(res.pr{i});
            case 'DEseq'
                r = Omics_DEseq(O,res.X{i},res.xnames{i},'');
                res.mean{i} = nanmean(O,2);
                res.p{i} = r.p;
                res.fold{i} = r.log2Fold;
                res.pr{i} = r.p;
                res.foldr{i} = r.log2Fold;
                res.label{i} = [label,', DEseq ',r.DEseq.design];
                
                [~,~,~,res.fdr{i}] =fdr_bh(res.p{i});
                [~,~,~,res.fdrr{i}]=fdr_bh(res.pr{i});
            case 'ranksum'
                d = get(O,'data');
%                 d = 2.^d;
                d(isnan(d))=-1; % in oder to discriminate from zero
                O = set(O,'data',d,'NaN -> -1');

                r = ranksum(O,res.X{i});
                res.p{i} = r.p;
                res.fold{i} = r.medianFold;
                res.pr{i} = r.p;
                res.foldr{i} = r.medianFold;
                
                [~,~,~,res.fdr{i}] =fdr_bh(res.p{i});
                [~,~,~,res.fdrr{i}]=fdr_bh(res.pr{i});

                res.label{i} = [label,', ranksum'];
            case 'ranksum_gap_0asNA'
                d = get(O,'data');
                d = 2.^d;
%                 d(isnan(d))=0;
                O = set(O,'data',d,'2^ count0=NaN');

                r = ranksum(O,res.X{i});
                res.p{i} = r.p;
                res.fold{i} = r.gap;
                res.pr{i} = r.p;
                res.foldr{i} = r.gap;
                
                [~,~,~,res.fdr{i}] =fdr_bh(res.p{i});
                [~,~,~,res.fdrr{i}]=fdr_bh(res.pr{i});

                res.label{i} = [label,', ranksum (fold=gap, count=0 => NA)'];
            case 'ranksum_gap'
                d = get(O,'data');
                d = 2.^d;
                d(isnan(d))=0;
                O = set(O,'data',d,'2^ and NaN -> 0');

                r = ranksum(O,res.X{i});
                res.p{i} = r.p;
                res.fold{i} = r.gap;
                res.pr{i} = r.p;
                res.foldr{i} = r.gap;
                
                [~,~,~,res.fdr{i}] =fdr_bh(res.p{i});
                [~,~,~,res.fdrr{i}]=fdr_bh(res.pr{i});

                res.label{i} = [label,', ranksum (fold=gap)'];
            otherwise
                error('model unknown')
        end
        try
            save OmicsRegress_tmp resc
        end
        
    end
    data.ana = res;
end