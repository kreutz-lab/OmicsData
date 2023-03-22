% status = WriteDataNormFinder(O,file)
% 
%   Writing the data to a file including the annotating columns.
% 
%   O           @OmicsData
%   
%   file        filename
% 
%   status      the output of the fclose function. A value zero indicates
%               normal exit status.
% 
% Example:
% WriteDataNormFinder(O, 'Data.txt')

function status = WriteDataNormFinder(O,file,maxnanProp,groupLabels)
if ~exist('maxnanProp','var') || isempty(maxnanProp)
    maxnanProp = 0;
end
if ~exist('groupLabels','var') || isempty(groupLabels)
    groupLabels = [];
end


% O = O(find(get(O,'antna')<=maxnanProp),:);  % klappt irgendwie gerade
% nicht
if sum(get(O,'antna')>0)>0
    error('geNorm cannot work with NaN')
end
    
decsep = '.';

data       = get(O,'data');
snames   = strrep(strrep(get(O,'snames'),' ','_'),'%','');

%% Annotation of the rows (i.e. all columns O.cols of @OmicsData)
% [colval,colnames] = getColumns(O,'char');
colval = strrep(get(O,'IDs'),' ','_');
colnames = {'IDs'};

titel = '';
for i=1:length(colnames)
    titel = [titel,'\t',colnames{i}];
end
for i=1:length(snames)
    titel = [titel,'\t',snames{i}];
end
titel = [titel(3:end),'\n'];

%% Writing
fid = fopen(file,'w');
fprintf(fid,titel);
for ig=1:size(colval,1)
    fprintf(fid,'%s',colval{ig,1});
    for c=2:size(colval,2)
        fprintf(fid,'\t%s',colval{ig,c});
    end
    
    for ih = 1:length(snames)
        fprintf(fid,'\t%s',strrep(sprintf('%f',data(ig,ih)),'.',decsep));
    end
    fprintf(fid,'\n');
end

if iscell(groupLabels)
    [~,~,gl] = unique(groupLabels);
else
    gl = groupLabels;
end
    
if ~isempty(groupLabels)
    fprintf(fid,'group\t%i',gl(1));
    for i=2:length(groupLabels)
        fprintf(fid,'\t%i',gl(i));
    end
    fprintf(fid,'\n');
end

status = fclose(fid);




