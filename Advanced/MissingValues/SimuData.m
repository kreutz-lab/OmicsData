function full = SimuData(npep,rep,mu,sigP,sigG,sige)

if ~exist('mu','var') || isempty(mu)
    mu = 1.5;
end
if ~exist('sigP','var') || isempty(sigP)
    sigP=0.5;
end
if ~exist('sigG','var') || isempty(sigG)
    sigG=sigP;
end
if ~exist('sige','var') || isempty(sige)
    sige=sigG;
end

%% Simulate peptides
P = [(randn(npep,1)*sigP+mu)*ones(1,rep/2), (randn(npep,1)*sigP+mu)*ones(1,rep/2)]; % two groups of proteins
G = zeros(npep,rep);
G(1:round(0.2*npep),1:round(rep/2)) = (randn(1,round(rep/2))*sigG+mu).*ones(round(0.2*npep),1);
G(round(0.2*npep)+1:round(0.2*npep)*2,round(rep/2)+1:end) = (randn(1,round(rep/2))*sigG+mu).*ones(round(0.2*npep),1);
G = G(randperm(npep),:);  % distribute abundant peptides randomly
e = randn(npep,rep)*sige;
pep = P+G+e;

%% Simulate proteins
npro = ceil(npep/2);
m = randi(npro,1,npep); % for each peptide assign protein ID
for i=1:npro
    full(i,:) = sum(pep(m==i,:),1,'omitnan');  % assign mean peptide intensity if more than one
end
full = full(~all(full==0,2),:);


% u=unique(m);
% n=histc(m,u);
% s = u(n ==1);               % get indices for single peptide
% d = u(n > 1);               % get indices for more than one peptide
% full = nan(npro,rep);
% full(s,:) = pep(ismember(m,s),:);  % assign peptide intensity for single pep
% for i=1:length(d)
%     full(d(i),:) = nansum(pep(m==d(i),:));  % assign mean peptide intensity if more than one
% end