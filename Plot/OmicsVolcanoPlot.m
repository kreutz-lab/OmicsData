% OmicsVolcanoPlot(O,p,fold)
%
%   p       p-values, array or matrix
%
%   fold    fold-changes, usually at the log2 scale, array or matrix
%
%   titel   string or cell of string (title of the plot)
%
%   If several columns of p-values and fold-changes are plotted, then there
%   are two options
%
%   crossAnalysis   true    fold of one column is plotted against -log10(p)
%                           of all other coloumns
%                   false   Standard volcano plots for each pair of columns

function hax = OmicsVolcanoPlot(O,p,fold,titel,crossAnalysis,color)
if ~exist('titel','var') || (isempty(titel) && ~strcmp('',titel))
    titel = get(O,'name');
    defaultTit = 1;
else
    defaultTit = 0;
end
if ~exist('crossAnalysis','var') || isempty(crossAnalysis)
    crossAnalysis = false;
end
if ~exist('color','var') || isempty(color)
    color = [0.00,0.45,0.74];
end


if (min(size(p))>1) % matrix: make plots for each column
    if(crossAnalysis) % cross analysis volcano plots
        figure
        subx = size(p,2);
        suby = size(p,2);
        ii=0;
        for i1=1:size(p,2)
            for i2=1:size(fold,2)
                ii=ii+1;
                subplot(subx,suby,ii)
                if i1==i2
                    color='k';
                else
                    color = [];
                end
                if(iscell(titel))
                    hax = OmicsVolcanoPlot(O,p(:,i1),fold(:,i2),'',[],color);
                    if(rem(ii,size(fold,2))==1)
                        ylabel(titel{i1})
                    end
                    if(ii > subx*suby-size(fold,2))
                        xlabel('fold-change [log2]')
                    else
                        xlabel('')
                    end
                    if(ii <= suby)
                        title(titel{i2})
                    end
                else
                    hax = OmicsVolcanoPlot(O,p(:,i1),fold(:,i2),'',[],color);
                end
                fs = max(2,10-subx);
                set(hax,'FontSize',fs)

                if(size(fold,2)>5) % no labels
                    xlabel('')
                    ylabel('')
                end
            end
        end

    else  % Many standard volcano plots
        figure
        suby = ceil(sqrt(size(p,2)));
        subx = ceil(size(p,2)/suby);
        for i=1:size(p,2)
            subplot(subx,suby,i)
            if(iscell(titel))
                hax = OmicsVolcanoPlot(O,p(:,i),fold(:,i),titel{i});
            else
                hax = OmicsVolcanoPlot(O,p(:,i),fold(:,i),'');
            end
            fs = max(3,10-subx);
            set(hax,'FontSize',fs)
        end
    end

else % 1 volcano plot

    y = -log10(p);
    y10 = y;
    y10(y>10)=10;

    isPK = get(O,'isPositiveControl')==1;
    if ~isempty(isPK)
        plot(fold(~isPK),y10(~isPK),'.','Color',color);
        hold on
        plot(fold(isPK),y10(isPK),'.','Color',0.6*ones(1,3));
        plot(fold(~isPK & y>10),y10(~isPK & y>10),'o','Color',color);
        plot(fold(isPK & y>10),y10(isPK & y>10),'o','Color',0.6*ones(1,3));
    else
        plot(fold,y10,'.');
        hold on
        plot(fold(y>10),y10(y>10),'o');
    end
    xlabel('fold-change [log2]')
    ylabel('-log_{10}(p)');
    if length(titel)>20
        title(titel,'FontSize',6);
    else
        title(titel);
    end
    xl = xlim;
    xlim([-max(abs(xl)),max(abs(xl))])

    plot([-1,-1],ylim,'k-')
    plot([1,1],ylim,'k-')
    plot(xlim,2*ones(1,2),'k-')
    grid on

    hax = gca;
end
