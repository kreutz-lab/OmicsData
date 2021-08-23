% Examples:
% res = Workflow_Regression_core(O,res);
% 
% res2 = Rfilter(res,'label','ranksum') % only ranksum
% res2 = WritePipelineResult(res2,'res2')
% 
% res3 = Rfilter(res,'label','ranksum','unequal')  % everything except ranksum
% res3 = WritePipelineResult(res3,'res3')

function R = Rfilter(R,property,value,compareFlag)
if ~exist('compareFlag','var') || isempty(compareFlag)
    compareFlag = 'equal';
end

switch property
    case 'label'
        switch compareFlag
            case 'equal'
                ind = find(~cellfun(@isempty,regexp(R.out.pr.label,value)));
            case 'unequal'
                ind = find(cellfun(@isempty,regexp(R.out.pr.label,value)));
            otherwise
                error('compareFlag=%s not implemented.',compareFlag);
        end
                
        fn = fieldnames(R.out);
        fnX = fieldnames(R.out.pr);
        
        for ix=1:length(fnX)
            dims = size(R.out.pr.(fnX{ix}));
            for f=1:length(fn)
                if isstruct(R.out.(fn{f}))
                    if sum(abs(size(R.out.(fn{f}).(fnX{ix}))-dims))==0
                        R.out.(fn{f}).(fnX{ix}) = R.out.(fn{f}).(fnX{ix})(:,ind);
                    end
                end
            end
        end
end


