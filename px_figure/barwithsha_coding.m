%% Create fake data
X    = -90:10:90; % stimulus X
Nrep  = 50; % 50 repetitions
X    = repmat(X,1,Nrep); % apply repeats
Y    = 50*sind(1.2*X); % let's take a sinusoidal relationship between stimulus and response
Y    = Y+(abs(X)+20)/3.*randn(size(Y)); % add some Gaussian noise/variation (standard deviation depends on stimulus size)

figure(1)
h = plot(X,Y,'k.');
axis square
box off
xlabel('X');
ylabel('Y');
axis([-100 100 -100 100]);
set(gca,'XTick',-90:30:90,'YTick',-90:30:90);

%% Determine mean and std response for each stimulus
uX = unique(X); % unique values of X
nX = numel(uX); % number of unique X
 
mu = NaN(size(uX)); % initialization mean vector
sd = mu; % initialization std vector
se = mu; % also determine the standard error
for ii = 1:nX
  sel = X==uX(ii);
  mu(ii) = mean(Y(sel));
  sd(ii) = std(Y(sel));
  n = sum(sel); % number of responses
  se(ii) = sd(ii)./sqrt(n); % standard error
end
ci = 1.96*se; % 95% confidence interval

figure(2)
h = errorbar(uX,mu,sd,'ko-');
set(h,'MarkerFaceColor','w','LineWidth',2);
axis square
box off
xlabel('X');
ylabel('Y');
set(gca,'XTick',-90:30:90,'YTick',-90:30:90);
axis([-100 100 -100 100]);

x           = [uX fliplr(uX)];
y           = [mu+sd fliplr(mu-sd)];
 
figure(3)
hpatch = patch(x,y,'k'); % the errorpatch
set(hpatch,'EdgeColor','none'); % remove the edge
set(hpatch,'FaceColor',[.7 .7 .7]); % and change the 
hold on;
hline = plot(uX,mu,'k-'); % central line
set(hline,'LineWidth',2); % make nice thick line
set(hline,'Color','k'); % change color
axis square
box off
xlabel('X');
ylabel('Y');
set(gca,'XTick',-90:30:90,'YTick',-90:30:90);
 
hpatch = patch(x,y,'k'); % the errorpatch
set(hpatch,'EdgeColor','none'); % remove the edge
alpha(hpatch,0.4); % another option would be to use transparency
 