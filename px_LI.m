function z = px_LI(x,y)

% Usage This function is used to calculate the lateralization index.

z    = 2*(x-y)./(x+y);
i    = x == 0 & y == 0;
z(i) = 0;
