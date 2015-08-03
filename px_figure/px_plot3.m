function px_plot3(x,y,z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORMAT px_plot3(x,y,z)
% 
% ALL OF x, y, z are one-dimensional array.
% 
% Pengfei Xu @ QCCUNY, 12/21/2011
% Copyright 2011-2011 Pengfei Xu Beijing Normal University
% Revision: 1.0 Date: 12/21/2011 00:00:00
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xmax = max(x);
Xmin = min(x);
Ymax = max(y);
Ymin = min(y);
[xX,yY] = meshgrid(linspace(Xmin,Xmax),linspace(Ymin,Ymax));
% Z = TriScatteredInterp(x,y,z,X,Y, 'v4');%interpolate
zZ = griddata(x,y,z,xX,yY, 'v4');%interpolate
%figure;
mesh(xX,yY,zZ);
% meshz(X,Y,Z);
% surf(X,Y,Z);
hold on;
plot3(x,y,z,'r.');