function px_bar_diff_col(values, range, colortype, delta, edgecolor)

% generate a nice color bar based on the values
% values: data to plot by bar(values)
% range:  the min and max range for the x ticks
% colortype: strings, eg.,'jet';'hot';'cool';'spring';'autumn';'winter'.See
%            doc colormap for details.
% delta:  the interval for the x ticks
% 
% example: barColor(1:30, [-1 1], 0.2)
if ~exist('range','var')
    range = [1 length(values)];
end
if ~exist('delta','var')
    delta = 1;
end
if ~exist('edgecolor','var')
    %edgecolor = 'none';
    edgecolor = [0 0 0];
end

eval(['colors = ' colortype '(' num2str(length(values)) ');'])
%colors = getNcolors(length(values));
%colors = jet(length(values));

yb = 0;%former
for i=1:numel(values)
    %x = [i-1 i-1 i i]
    x = [i-1 i-1 numel(values) numel(values)]
    y = [yb values(i) values(i) yb]
    c = colors(i,:)
    patch(x,y,c,'edgecolor',c);
    yb = values(i)
end
xlim([0 numel(values)])
grid on
nstep = (max(range) - min(range))/delta;
xtick = 0:(numel(values)/nstep):(numel(values));
set(gca,'XTick',xtick)

clear labels;
for i=1:nstep+1
    labels{i} = num2str(min(range)+(i-1)*delta);
end
set(gca,'XTickLabel',labels);