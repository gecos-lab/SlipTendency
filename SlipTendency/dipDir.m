function [dip,dir] = dipDir(directionCosines)

% directionCosines must be in column unit vector format with
%
% cos1 = East
% cos2 = North
% cos3 = Upward
%
% Andrea Bistacchi 27/10/2016

[plunge,trend] = plungeTrend(directionCosines');   % ' required because plungetrend now accepts a row vector (modified 6/2/2019)

if plunge >= 0,
    dip = 90 - plunge;
else
    dip = -90 - plunge;
end

dir = 180 + trend;

if dir > 360,
    dir = dir - 360;
end

end
