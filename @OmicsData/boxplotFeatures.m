% boxplot(O)
% 
%   boxplot von get(O,'data') über versch. Arrays
% 
%       accountCoefZero    consider get(O,'accountCoefZero') and
%                          plot only a proper fraction of zeros
% 
% The code can be extended by providing faktor as a variable.
% This faktor controls the postion in vertical direction of the labels.
% 
% Example:
%     boxplotFeatures(Otmp,X,xnames,[],accountStructZero,'Notch','on')

function xcombi=boxplotFeatures(O,X,xnames,file,accountCoefZero,varargin)
% if ~exist('xtick','var')
%     xtick = false;
% end

if ~exist('file','var') || isempty(file)
    file = '';
end
if ~exist('xnames','var') || isempty(xnames)
    xnames = {'X'};
end
if ~exist('accountCoefZero','var')
    accountCoefZero = 0;
end

% xuni = unique(X(:,1));
% 
% labels = cell(size(xuni));
% for i=1:length(xuni)
%     labels{i} = [xnames{1},'=',num2str(xuni(i))];
% end

xcombi = Xcombinations(X,xnames);
labels = unique(xcombi);

dat = get(O,'data');
fnames  = str2label(get(O,'fnames'));
nf = get(O,'nf');

% Proper font size
if nf<10
    fs = 10;
elseif nf<=20
    fs = 9;
elseif nf<=50
    fs = 7;
elseif nf <=70
    fs = 6;
else % more than 70
    fs = 5;
end

labelsShort = cell(size(labels));
for i=1:length(labels)
    labelsShort{i} = labels{i}(1:min(3,length(labels{i})));
end

nletters = max(celllength(labels));
if nletters<6
    fsTick = 9;
elseif nletters<10 % more than 60
    fsTick = 7;
else
    fsTick = 5;
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
    datplot = NaN(dim2,length(labels));
    N0 = zeros(1,length(labels));
    for j=1:length(labels)
%         ind = find(X(:,1)==xuni(j));
        ind = strmatch(labels{j},xcombi,'exact');
        datplot(1:length(ind),j) = dat(i,ind)';
        N0(j) = sum(isnan(dat(i,ind)))/length(ind)*100;
    end
    
    subplot(suby,subx,i);
    set(gca,'YGrid','on','LineWidth',1.5,'FontSize',fs);
    hold on
    boxplot(datplot,'labels',labelsShort,'labelorientation','inline',varargin{:});
    f = findobj(gca,'type','text');
    % sort objects according to x-position:
    xpos = NaN(size(f));
    for ii=1:length(f)
        tmp = get(f(ii),'Position');
        xpos(ii) = tmp(1);
    end
    [~,RF] = sort(xpos);
    f = f(RF);
    for ii=1:length(f)
        set(f(ii),'FontSize',fsTick,'String',labels{ii});
    end
    yl = ylim;
    ytext = yl(1)+0.95*diff(yl);
    if subx*suby<=16
        fs = 6;
    else
        fs = 5;
    end
    for j=1:length(N0)
        text(j+.1,ytext,[num2str(round(N0(j))),'%NA'],'FontSize',fs);
    end
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
    title(OmicsRenameLabels(fnames{i}),'FontSize',fs)
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
