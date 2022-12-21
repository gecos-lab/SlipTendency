function [Xl,Yl] = plotLine(Plunge,Trend);

% check for upwards vectors (with negative Plunge)
Trend = Trend + 180*(sign(Plunge)==-1);
Plunge = Plunge * sign(Plunge);

rho = sqrt(2).*sin(pi/4-Plunge*pi/180./2);   %projected distance from origin in equiareal Lambert poj. (Schmidt net)
Xl = rho .* sin(Trend*pi/180);
Yl = rho .* cos(Trend*pi/180);

end
