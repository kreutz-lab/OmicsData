% head(in)
% 
%   Zeigt die ersten 10 Zeilen an
function varargout = head(in,minlines)
if ~exist('minlines','var')
    minlines = 10;
end

if(isnumeric(in))
   out = in(1:min(minlines,size(in,1)),:)
elseif(islogical(in))
   out =  in(1:min(minlines,size(in,1)),:)
elseif(iscell(in))
   out = in(1:min(minlines,size(in,1)),:)
else
    in
end

if nargout > 0
    varargout{1} = out;
else
    varargout = cell(0);
end
