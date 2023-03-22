function C = OmicsSampleCorrelation(O)

snames = str2label(get(O,'snames'));

C = corr(get(O,'data'),'Rows','pairwise');
% image(C*100);
imagesc(C)
cm=colormap(hot);
colormap(cm(end:-1:1,:));
colorbar
set(gca,'XTick',1:size(C,2),'YTick',1:size(C,1),'XTickLabel',snames,'YTickLabel',snames);
xtickangle(90);
title(get(O,'name'));


