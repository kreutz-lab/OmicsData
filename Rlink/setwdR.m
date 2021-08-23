% setwdR(path)
% 
% Wechselt das Verzeichnis unter R, Befehl setwd.r
% R-Link muss offen sein.
% 
%   path    Default: pwd.m
% 


function setwdR(path)
if(~exist('path','var'))
    path = pwd;
end
evalR(['setwd("',strrep(path,filesep,'/'),'")']);
