% Fisher's Exact Test on isnan(O) (if no NaN, then zeros are analyzed
% instead)

function p = fishertest(O,g1,g2,varargin)

isna = isnan(O);
if sum(isna(:)==1)==0 % No NaN
    isna = get(O,'data')==0;
end

p = NaN(size(isna,1),1);
fprintf('fishertest: ')
for i=1:size(isna,1)
    if rem(i,round(size(isna,1)/10))==0
        fprintf('.');
    end
    X = zeros(2);
    X(1,1) = sum(isna(i,g1));
    X(1,2) = sum(isna(i,g2));
    X(2,1) = sum(~isna(i,g1));
    X(2,2) = sum(~isna(i,g2));
    [~,p(i)] = fishertest(X,varargin{:});
end
fprintf('done.\n');

