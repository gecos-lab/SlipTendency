function directionCosines = lineation(plunges,trends)

% directionCosines are row unit vector format, one row for each vector
%
% cos1 = East
% cos2 = North
% cos3 = Upward
%
% Andrea Bistacchi 27/10/2016, modified 6/2/2019 to process several inputs
% at once and obtain row vectors

% check plunge trend format
if size(plunges,2)>1 , plunges = plunges'; end
if size(trends,2)>1 , trends = trends'; end

directionCosines = [cos(plunges*pi/180).*sin(trends*pi/180)   cos(plunges*pi/180).*cos(trends*pi/180)   -sin(plunges*pi/180)];

end