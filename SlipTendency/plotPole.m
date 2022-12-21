function [Xp,Yp] = plotPole(Dip,Dir);

poletrend = (Dir-180).*pi/180;     % trend of pole to plane in radians
poleplunge = (90-Dip).*pi/180;    % plunge of pole to plane in radians
rho = sqrt(2).*sin(pi/4-poleplunge./2);   %projected distance from origin in equiareal Lambert poj. (Schmidt net)
Xp = rho .* sin(poletrend);
Yp = rho .* cos(poletrend);

end