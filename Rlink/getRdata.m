% val = getRdata(varname)
% 
%   varname     name of an R variable which should be picked
% 
%   val         the value of the variable in R
% 
%  This function is for getting the results of calculations in R. The
%  buffered R commands in OPENR.cmd are executed before. Therefore, it
%  might take some time.
%  Picking the variables is also rather slow since *.mat workspaces has to
%  be written.
% 
%   This function requires the R.matlab package that has to be installed in
%   R (e.g. via install.packages("R.matlab")

function val = getRdata(varname)
%global OPENR

val = Rpull(varname);

% switch(varname)
%     case 'c'
%         warning('Variable name ''c'' might not work because it has a special meaning in R')
% end
% 
% evalR_writeAndExecute
% 
% %% Schreibe *.Rdata in evalR und konvertiere varname und speichere varname in getRdata.mat
% fid = fopen('getRdata.R','w');
% 
% fprintf(fid,'%s\n',['setwd("',strrep(pwd,filesep,'/'),'")']);
% if isfield(OPENR,'myLibPath') && ~isempty(OPENR.myLibPath) && exist(OPENR.myLibPath,'file')  
%     fprintf(fid,'%s\n',['.libPaths("',OPENR.myLibPath,'")']); % my own library
% end
% fprintf(fid,'require(R.matlab)\n');
% fprintf(fid,'rm(list=ls())\n');
% fprintf(fid,'\n');
% 
% fprintf(fid,'%s\n','load("evalR.Rdata")');
% fprintf(fid,'%s\n',sprintf('writeMat("getRdata.mat",%s=%s)',varname,varname));
% fclose(fid);
% 
% system(sprintf('%s CMD BATCH --vanilla --slave "%s%sgetRdata.R"',OPENR.Rexe,pwd,filesep));
% 
% try
%     a = load('getRdata.mat');
% catch
%     warning('Error: Maybe there is a file getRdata.mat.tmp from unfinished call: Please delete it!')
%     rethrow(lasterr)
% end
% 
% if ~isstruct(a)
%     val = a;
% else
%     if isfield(a,varname)
%         val = a.(varname);
%     else
%         error('%s does not exist.',varname);
%     end 
% end
