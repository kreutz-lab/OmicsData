% Returns a logical indicating whether the original data (when the class
% was created) was NaN.

function was = wasnan(O)
was = get(O,'wasNaN');

