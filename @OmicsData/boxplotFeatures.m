% boxplot(O)
% 
%   boxplot von get(O,'data') über versch. Arrays
% 
%       accountCoefZero    consider get(O,'accountCoefZero') and
%                          plot only a proper fraction of zeros
% 
% The code can be extended by providing faktor as a variable.
% This faktor controls the postion in vertical direction of the labels.

function boxplotFeatures(O,X,xnames,file,accountCoefZero,varargin)
% if ~exist('xtick','var')
%     xtick = false;
% end

xuni = unique(X(:,1));

if ~exist('file','var') || isempty(file)
    file = '';
end
if ~exist('xnames','var') || isempty(xnames)
    xnames = {'X'};
end
if ~exist('accountCoefZero','var')
    accountCoefZero = 0;
end


labels = cell(size(xuni));
for i=1:length(xuni)
    labels{i} = [xnames{1},'=',num2str(xuni(i))];
end

dat = get(O,'data');
fnames  = str2label(get(O,'fnames'));
nf = get(O,'nf');

faktor = 1;
% Proper font size
if nf<10
    fs = 10;
    pos = [500   438   560   420]; 
elseif nf<=20
    fs = 9;
    pos = [500   438   750   420];
elseif nf<=50
    fs = 7;
    faktor = 0.9;
    pos = [500   438   850   420];
elseif nf <=70
    faktor = 0.8;
    fs = 6;
    pos = [500   438   950   420];
else % more than 60
    faktor = 0.7;
    fs = 5;
    pos = [100   438   1600   420];
end
if accountCoefZero
    dat = accountStructZero(O,dat);
end

if size(dat,1)>100
    dat = dat(1:100,:);
    warning('Only the first 100 features are plotted.')
end

dim1 = size(dat,1);
dim2 = size(dat,2);
subx = ceil(dim1^0.6);
suby = ceil(dim1/subx);

for i=1:size(dat,1)
    datplot = NaN(dim2,length(xuni));
    for j=1:length(xuni)
        ind = find(X(:,1)==xuni(j));
        datplot(1:length(ind),j) = dat(i,ind)';
    end
    subplot(suby,subx,i);
    set(gca,'YGrid','on','LineWidth',1.5,'FontSize',fs);
    hold on
    boxplot(datplot,'labels',labels,'labelorientation','inline',varargin{:});
    set(gca,'YGrid','on','LineWidth',1.5,'FontSize',fs);
% if xtick
%     set(gca,'XTick',1:size(O,2),'XGrid','on');
% end
%     hlabel = findobj(gca,'FontSize',10);
%     yl = ylim;
%     for ii=1:length(hlabel)
%         set(hlabel(ii),'FontSize',fs);
%         pos = get(hlabel(ii),'Position');
%         %     ex = get(hlabel(i),'extend');
%         pos(2) = yl(1)-faktor*(yl(1)-pos(2));
%         set(hlabel(ii),'Position',pos);
%     end

%     xlabel('sample','FontSize',10);
%     ylabel(str2label(get(O,'default_data')),'FontSize',10);
    title(fnames{i},'FontSize',fs)
    % set(gcf,'Position',pos);
end

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
