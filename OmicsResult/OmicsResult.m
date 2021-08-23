% Konstruktor der Klasse OmicsResult
%
% O = OmicsResult(res_struct,name)
%
%   res     Result Struct as generated by an analysis workflow
%   
%   name    Name of the project
% 
%   Examples:
%   O = OmicsResult;   % empty Object
% 

Not finished 


function R = OmicsResult(res, name)
if ~exist('name','var') || isempty(name)
    name = '';
end
if(~exist('res','var') || isempty(file_or_data))  % load default data set

end

    
    R = OmicsStruct;
    R.name  = name; % this is the user-defined name of the data object, not necessarily the filename
    R.info.path = file;
    R.info.filename = filename;
    R = class(R,'OmicsResult');

% R = OmicsCheckResult(R);  % Check the class and add missing properties

