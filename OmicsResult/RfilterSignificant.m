% Examples:
% res = Workflow_Regression_core(O,res);
% 
% res2 = RfilterSignificant(res,find(nanmax(res.out.pr.Krank,[],2)<=0.05) % only ranksum
% res2 = WritePipelineResult(res2,'res2')
% 
% bol = sign(nanmin(abs(res.out.fold.Krank),[],2))==sign(nanmax(abs(res.out.fold.Krank),[],2)) & nanmin(abs(res.out.fold.Krank),[],2)>1 & nanmax(abs(res.out.fold.Krank),[],2)>1;
% res3 = RfilterSignificant(res,find(bol & nanmax(res.out.pr.Krank,[],2)<=0.05)) % only ranksum
% res3 = WritePipelineResult(res3,'res3')

function R = RfilterSignificant(R,ind)


fn = setdiff(fieldnames(R.out),'out');
fnX = setdiff(fieldnames(R.out.pr),'label');

for ix=1:length(fnX)
    dims = size(R.out.pr.(fnX{ix}));
    for f=1:length(fn)
        if isstruct(R.out.(fn{f}))
            if sum(abs(size(R.out.(fn{f}).(fnX{ix}))-dims))==0
%                 fn{f}
%                 fnX{ix}
                R.out.(fn{f}).(fnX{ix}) = R.out.(fn{f}).(fnX{ix})(ind,:);
            end
        end
    end
end

if isfield(R.out,'out')
    fn = fieldnames(R.out.out);
    for i=1:length(fn)
        R.out.out.(fn{i}) = R.out.out.(fn{i})(ind);
    end
end

R.O = R.O(ind,:);
R.out.rf = [];
R.out.IDs = R.out.IDs(ind);

