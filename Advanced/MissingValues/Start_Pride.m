
files = dir('Pride/**/*proteinGroups*.txt'); 
set(0,'DefaultFigureVisible','off')  

for i=1:length(files)
    i
    tic
    O = OmicsData([files(i).folder '\' files(i).name]); % Write in class O    
    if size(O,2)>100
        continue
    end
    O = OmicsFilter(O);
    O = DIMA(O);
    O = set(O,'time',toc);
    saveO(O,[],'ODima')   
end