function [O,idx] = sort(O,dim,direction)

%SORT   Sort in ascending or descending order.
%   B = SORT(A) sorts in ascending order.
%   The sorted output B has the same type and size as A:
%   - For vectors, SORT(A) sorts the elements of A in ascending order.
%   - For matrices, SORT(A) sorts each column of A in ascending order.
%   - For N-D arrays, SORT(A) sorts along the first non-singleton dimension.
%
%   B = SORT(A,DIM) also specifies a dimension DIM to sort along.
%
%   B = SORT(A,DIRECTION) and B = SORT(A,DIM,DIRECTION) also specify the
%   sort direction. DIRECTION must be:
%       'ascend'  - (default) Sorts in ascending order.
%       'descend' - Sorts in descending order.
%   [B,I] = SORT(A,...) also returns a sort index I which specifies how the
%   elements of A were rearranged to obtain the sorted output B:
%   - If A is a vector, then B = A(I).  
%   - If A is an m-by-n matrix and DIM = 1, then
%       for j = 1:n, B(:,j) = A(I(:,j),j); end
%
% %   Examples:
% O = sort(O);

if nargin<1
    error('sort.m requires class O as input argument.')
end
if ~exist('dim','var') || isempty(dim)
    dim = 1;
end
if ~isnumeric(dim)
    direction = dim;
end
if ~exist('direction','var') || isempty(direction)
    direction = 'ascend';
end

dat = get(O,'data');
[~,idx] = sort(dat,dim,direction);

if dim==1
    O = O(idx,:);    
    fprintf('sort.m: Rows are sorted by intensity.\n');
elseif dim ==2
    O = O(:,idx);
    fprintf('sort.m: Columns are sorted by intensity.\n');
end

 
