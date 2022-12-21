function directionCosines = pole(dip,dir)

% directionCosines are in column unit vector format with
%
% cos1 = East
% cos2 = North
% cos3 = Upward
%
% Andrea Bistacchi 27/10/2016

if dip >= 0
    plunge = 90 - dip;
else
    plunge = -90 - dip;
end

trend = dir + 180;

if trend > 360
    trend = trend - 360;
end

directionCosines = lineation(plunge,trend)';  % ' required because lineation now returns a row vector (modified 6/2/2019)
 
end
