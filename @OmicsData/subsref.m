%   O = subsref(O,S)
% 
%   Indexing, i.e. Filtering of the data
% 
% Example:
% O(1:4,1:3)
% 
% 
% If O(1:2,:) is evaluated, then subsref is called with 
% S.type='()' and S.subs={1:2,':'}
% 
%   Attention: It seems that subsref does not work in general (in Matlab)
%   if indexing is used from inside a class function.
%   A workaround is calling subsref instead of using indexing, e.g. replace
%   O(rf,:) by 
%   s = struct('type','()');
%   s.subs = {rf,':'};
%   subsref(O,s)

function O = subsref(O,S)
 
switch S.type
    case '()'
        if length(S.subs)==2
            fn = fieldnames(O.data);
            for i=1:length(fn)
                O.data.(fn{i}) = subsref(O.data.(fn{i}),S);
            end
                        

            Stmp = S;
            Stmp.subs{1} = 1;
            fn = fieldnames(O.rows);
            ncol = length(O.rows.(fn{1}));
            
            for i=1:length(fn)
                O.rows.(fn{i}) = subsref(O.rows.(fn{i}),Stmp);
            end
            
            fn = fieldnames(O.container);
            for i=1:length(fn)
                if size(O.container.(fn{i}),2)==ncol
                    O.container.(fn{i}) = subsref(O.container.(fn{i}),Stmp);
                end
            end
            
            Stmp = S;
            Stmp.subs{2} = 1;
            fn = fieldnames(O.cols);
            nrow = length(O.cols.(fn{1}));
            for i=1:length(fn)
                O.cols.(fn{i}) = subsref(O.cols.(fn{i}),Stmp);
            end
            
            fn = fieldnames(O.container);
            for i=1:length(fn)
                if size(O.container.(fn{i}),1)==nrow
                    O.container.(fn{i}) = subsref(O.container.(fn{i}),Stmp);
                end
            end
        else
            error('OmicsData/subsref.m: Only two-dimensional indexing implemented/feasible.')
        end
        
        if ischar(S.subs{1})
            str1 = S.subs{1};
        elseif length(S.subs{1})==1
            str1 = num2str(S.subs{1});
        elseif length(S.subs{1})==2
            str1 = sprintf('%i:%i',S.subs{1}(1),S.subs{1}(end));
        else
            str1 = sprintf('%i...%i',S.subs{1}(1),S.subs{1}(end));            
        end
        if ischar(S.subs{2})
            str2 = S.subs{2};
        elseif length(S.subs{2})==1
            str2 = num2str(S.subs{2});
        elseif length(S.subs{2})==2
            str2 = sprintf('%i:%i',S.subs{2}(1),S.subs{2}(end));
        else
            str2 = sprintf('%i...%i',S.subs{2}(1),S.subs{2}(end));
        end
        
        O = OmicsAddAnalysis(O,sprintf('filtering with (%s,%s)',str1,str2));
        
    case '.'
        S
        error('Direct access to fields is not allowed. Use get(O,property) by default or in rare necessary cases [but not recommended!] getfield(O,fieldname).')
        
    otherwise
        error('OmicsData/subsref.m: Only () indexing implemented so far.')
end



