% boxplot(O)
% 
%   boxplot von get(O,'data') über versch. Arrays
% 
%       accountCoefZero    consider get(O,'accountCoefZero') and
%                          plot only a proper fraction of zeros
% 
%   makeViolinePlot     makes violineplots instead
% 
% The code can be extended by providing faktor as a variable.
% This faktor controls the postion in vertical direction of the labels.

function boxplot(O,file,accountCoefZero, makeViolinePlot)
% if ~exist('xtick','var')
%     xtick = false;
% end

if ~exist('file','var') || isempty(file)
    file = '';
end
if ~exist('makeViolinePlot','var') || isempty(makeViolinePlot)
    makeViolinePlot = false;
end
if ~exist('accountCoefZero','var')
    accountCoefZero = 0;
end

dat = get(O,'data');
snames  = str2label(get(O,'snames'));
ns = get(O,'ns');

faktor = 1;
% Proper font size
if ns<10
    fs = 10;
    pos = [500   438   560   420]; 
elseif ns<=20
    fs = 9;
    pos = [500   438   750   420];
elseif ns<=50
    fs = 8;
    faktor = 0.9;
    pos = [500   438   850   420];
elseif ns <=70
    faktor = 0.8;
    fs = 7;
    pos = [500   438   950   420];
else % more than 60
    faktor = 0.7;
    fs = 6;
    pos = [100   438   1600   420];
end
if accountCoefZero
    dat = accountStructZero(O,dat);
end

if makeViolinePlot
    violinplot(dat,[],'ShowData',false);
else
    boxplot(dat,'labels',snames,'labelorientation','inline');
end
set(gca,'YGrid','on','LineWidth',1.5,'FontSize',9);
% if xtick
%     set(gca,'XTick',1:size(O,2),'XGrid','on');
% end
hlabel = findobj(gca,'FontSize',10);
yl = ylim;
for i=1:length(hlabel)
    set(hlabel(i),'FontSize',fs);
    pos = get(hlabel(i),'Position');
%     ex = get(hlabel(i),'extend');
    pos(2) = yl(1)-faktor*(yl(1)-pos(2));
    set(hlabel(i),'Position',pos);
end

xlabel('sample','FontSize',10);
ylabel(str2label(get(O,'default_data')),'FontSize',10);
title(get(O,'name'))
% set(gcf,'Position',pos);

if ~isempty(file)
    set(gcf,'Position',[488.0000  238.2000  791.4000  523.8000]);
    print(gcf,file,'-dpng');
end

end

function dat = accountStructZero(O,dat)
    coef = get(O,'coefZero');
    prob = exp(coef)./(1+exp(coef));

    if sum(sum(isnan(dat)))==0 % cosider 0
        bol = dat==0;
        disp('Boxplots with plotting only the right number of zeros.')
    else
        bol = isnan(dat);
        disp('Boxplots with plotting the right number of NaNs as zeros.')
    end
    dat(bol) = NaN;  % make all concerned entries nan
    for i=1:size(dat,1)        
        anz0 = round(prob(i)*sum(bol(i,:)));
        if anz0>0
            ind = find(bol(i,:));
            dat(i,ind(1:anz0))=0; % overwrite proper fraction with 0
        end
    end
end
