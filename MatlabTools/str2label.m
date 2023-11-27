% lab = str2label(str)
%   
%   Entfernt Unterstriche, und konvertiert "e-00" zu "e-"
% 
%   str     string oder cell of strings

function lab = str2label(str)
if(iscell(str))
    lab = cell(1,length(str));
    for i=1:length(str)
        lab{i} = str2label(str{i});
    end
    if(size(str,2)==1)
        lab = lab';
    end    
else        
    lab = strrep(str,'^','');
    lab = strrep(lab,'_','\_');
    lab = strrep(lab,'e-00','e-');
    lab = strrep(lab,'e-0','e-');
    lab = strrep(lab,'e+000','');
    lab = strrep(lab,'e+00','e+');
    lab = strrep(lab,'e+0','e+');
    lab = regexprep(lab,'e\+$','');
    lab = regexprep(lab,'e\+\s','');
    lab = strrep(lab,'.000000e','e');
    lab = strrep(lab,'.100000e','.1e');
    lab = strrep(lab,'.200000e','.2e');
    lab = strrep(lab,'.300000e','.3e');
    lab = strrep(lab,'.400000e','.4e');
    lab = strrep(lab,'.500000e','.5e');
    lab = strrep(lab,'.600000e','.6e');
    lab = strrep(lab,'.700000e','.7e');
    lab = strrep(lab,'.800000e','.8e');
    lab = strrep(lab,'.900000e','.9e');

    lab = strtrim(lab);

    if length(lab)==6
        lab = strrep(lab,'1.5e-1','0.15');
        lab = strrep(lab,'2.5e-1','0.25');
        lab = strrep(lab,'3.5e-1','0.35');
        lab = strrep(lab,'4.5e-1','0.45');
        lab = strrep(lab,'5.5e-1','0.55');
        lab = strrep(lab,'6.5e-1','0.65');
        lab = strrep(lab,'7.5e-1','0.75');
        lab = strrep(lab,'8.5e-1','0.85');
        lab = strrep(lab,'9.5e-1','0.95');
    end
    if length(lab)==4
        lab = strrep(lab,'5e-2','0.05');
        lab = strrep(lab,'1e-1','0.1');
        lab = strrep(lab,'2e-1','0.2');
        lab = strrep(lab,'3e-1','0.3');
        lab = strrep(lab,'4e-1','0.4');
        lab = strrep(lab,'5e-1','0.5');
        lab = strrep(lab,'6e-1','0.6');
        lab = strrep(lab,'7e-1','0.7');
        lab = strrep(lab,'8e-1','0.8');
        lab = strrep(lab,'9e-1','0.9');
    end
end