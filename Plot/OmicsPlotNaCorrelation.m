% OmicsPlotNaCorrelation

function OmicsPlotNaCorrelation(O,file)
if ~exist('file','var') || isempty(file)
    file = '';
end


propNA = sum(isnan(O),1)/size(O,1);
if (sum(propNA)==0)
    propNA = mean(get(O,'data')<100*eps,1);
end

sampleMean = nanmean(O,1);

plot(sampleMean,100*propNA,'k.')


set(gca,'LineWidth',1.5,'FontSize',16);
grid on
ylabel('% NA or zeros');
xlabel('sample mean')
% title(strrep(get(O,'name'),'_','\_'));

if ~isempty(file)
    set(gcf,'Position',[488.0000  238.2000  791.4000  523.8000]);
    print(gcf,file,'-dpng');
end
