
file = ['..' filesep 'TestData' filesep 'Test6'];

O = OmicsData(file);
O = OmicsFilter(O,0.8,'auto');  % log2-transform data, cut features with >0.8% MVs
image(O)
O = DIMA(O);