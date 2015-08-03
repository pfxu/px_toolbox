function [hpatch,hline] = px_serrorbar(X,Y,E,C,T)
% USAGE  Makes a 2-d line plot with a pretty shaded error bar made using patch. % 
% 
% FORMAT px_serrorbar(X,Y,E), plots the graph of vector X vs. vector Y with 
%        error patch specified bythe vector E.
%
% FORMAT px_serrorbar(...,'ColorSpec') uses the color specified by the string
%        'ColorSpec'. The color is applied to the data line and error patch.<DEFAULT = 'k'>

% FORMAT px_serrorbar(X,Y,E,C,T) make the shaded error bar transparent, <DEFAULT = .4>
% 
% FORMAT [HPATCH,HLINE] = px_serrorbar(...) returns a vector of patchseries and
%        lineseries handles in HPATCH and HLINE, respectively.

% (c) 2011 Marc van Wanrooij
% e-mail: marcvanwanrooij@neural-code.com
%
% Revise by Pengfei Xu, 05/07/2015

%% Initialization
% Check whether
if size(X,1)>1
	X=X(:)';
	if size(X,1)>1
		error('X should be a row vector');
	end
end
if size(Y,1)>1
	Y   = Y(:)';
	if size(Y,1)>1
		error('Y should be a row vector');
	end
end
if size(E,1)>2
	E   = E(:)';
	if size(E,1)>2
		error('E should be a row vector or 2-row matrix');
	end
end
if length(Y)~=length(X)
	error('Y and X should be the same size');
end
if size(E,2)~=size(X,2)
	error('E and X should be the same size');
end
if nargin<4
	C = 'k';
end
if nargin<5
    T = .4;
end

%% remove nans
if size(E,1)>1
	sel		= isnan(X) | isnan(Y) | isnan(E(1,:)) | isnan(E(2,:));
	E		= E(:,~sel);
else
	sel		= isnan(X) | isnan(Y) | isnan(E);
	E		= E(~sel);
end
X		= X(~sel);
Y		= Y(~sel);

%% Create patch
x           = [X fliplr(X)];
if size(E,1)>1
	y           = [E(1,:) fliplr(E(2,:))];
else
	y           = [Y+E fliplr(Y-E)];
end
%% Graph
hpatch           = patch(x,y,C);
alpha(hpatch,T);
set(hpatch,'EdgeColor','none');
hold on;
hline = plot(X,Y,'k-'); 
set(hline,'LineWidth',1.5,'Color',C);
box on;