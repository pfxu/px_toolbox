function px_scatter3(x,y,z)

xy = [ones(size(x)) x y x.*y];
b = regress(z,xy); % Removes NaN data

scatter3(x,y,z,'filled')
hold on
Xmax = max(x);
Xmin = min(x);
Ymax = max(y);
Ymin = min(y);
[xfit,yfit] = meshgrid(linspace(Xmin,Xmax),linspace(Ymin,Ymax));

zfit = b(1) + b(2)*xfit + b(3)*yfit + b(4)*xfit.*yfit;
mesh(xfit,yfit,zfit);
% view(50,10)