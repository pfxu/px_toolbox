% extract_hrfs_for_datamatrix(group, condition, roi)
D1 = extract_hrfs_for_datamatrix('all', 1, 2);
D2 = extract_hrfs_for_datamatrix('all', 2, 2);
D3 = extract_hrfs_for_datamatrix('all', 3, 2);
D4 = extract_hrfs_for_datamatrix('all', 4, 2);
D5 = extract_hrfs_for_datamatrix('all', 5, 2);

gind = {1:14, 15:31,32:47}; %HC,SZ,BD
%% first try with a single condition!!!
[coeff1,score1,latent1]=princomp(D1);
%% now with all conditions
%[coeff1,score1,latent1]=princomp(cat(2,D1,D2,D3,D4,D5));

%% find the best fitting principle components
ncomp=10;
plist=zeros(ncomp,1);
% check only SZ vs HC
subsel=cat(2,gind{1},gind{2});
label=zeros(size(subsel));
label(gind{1})=1;
tmp=ceil(sqrt(ncomp));
for k=1:ncomp
    [b,dev,stat]=glmfit(score1(subsel,k),label','binomial','link','logit');
    plist(k)=stat.p(end);
    yfit=glmval(b,score1(subsel,k),'logit');
    [x,ind]=sort(score1(subsel,k));
    subplot(tmp,tmp,k);
    plot(score1(subsel,k),label,'o');
    hold on;
    plot(x,yfit(ind),'g');
    title(sprintf('PC %d : %0.5g',k,plist(k)));
end

ncomp=10;
plist=zeros(ncomp,1);
% check only SZ vs BD
subsel=cat(2,gind{2},gind{3});
label=zeros(size(subsel));
label(gind{2})=1;
tmp=ceil(sqrt(ncomp));
for k=1:ncomp
    [b,dev,stat]=glmfit(score1(subsel,k),label','binomial','link','logit');
    plist(k)=stat.p(end);
    yfit=glmval(b,score1(subsel,k),'logit');
    [x,ind]=sort(score1(subsel,k));
    subplot(tmp,tmp,k);
    plot(score1(subsel,k),label,'o');
    hold on;
    plot(x,yfit(ind),'g');
    title(sprintf('PC %d : %0.5g',k,plist(k)));
end

ncomp=10;
plist=zeros(ncomp,1);
% check only HC vs BD
subsel=cat(2,gind{1},gind{3});
label=zeros(size(subsel));
label(gind{1})=1;
tmp=ceil(sqrt(ncomp));
for k=1:ncomp
    [b,dev,stat]=glmfit(score1(subsel,k),label','binomial','link','logit');
    plist(k)=stat.p(end);
    yfit=glmval(b,score1(subsel,k),'logit');
    [x,ind]=sort(score1(subsel,k));
    subplot(tmp,tmp,k);
    plot(score1(subsel,k),label,'o');
    hold on;
    plot(x,yfit(ind),'g');
    title(sprintf('PC %d : %0.5g',k,plist(k)));
end


plot(coeff1(:,8))
grid on
stem(coeff1(:,8))