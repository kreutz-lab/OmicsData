% saveRimage(file)
% 
%   Speichert die momentanen R-variablen als image/workspace
%   R-Link muss offen sein
% 
%   file    Dateiname, default: r.rdata



function saveRimage(file)
if(~exist('file','var') | isempty(file))
    file = 'r.rdata';
end

setwdR;
evalR(['save.image("',file,'")'])
