function [vers1,vers2,vers3] = threeOrthoAxes(vers1Plunge,vers1Trend,vers3Plunge,vers3Trend,tol)

% returns a DEXTRAL set of orthogonal axes
% vers1 and vers3 are the first and last axes resp. expressed as plunge/trend
% tol could be 2 degrees corrensponding to an angle of at least 88 degrees
% between input axes
%
% Andrea Bistacchi 27/10/2016

% column versors from plunge/trend
vers1 = lineation(vers1Plunge,vers1Trend)'; % ' required because lineation now returns a row vector (modified 6/2/2019)
vers3 = lineation(vers3Plunge,vers3Trend)';

% vers2 from normalized cross product
vers2 = -cross(vers1,vers3);
modVers2 = sqrt(vers2(1,1)^2 + vers2(2,1)^2 + vers2(3,1)^2);
vers2 = vers2/modVers2;

% recalculate vers 3 to ensure orthogonality
vers3 = cross(vers1,vers2);

% if modulus of vers2 is shorter than tol, gives an error code
if modVers2 < sin((90-tol)*pi/180)
    vers1 = [-999; -999;-999]; % error code
    vers2 = [-999; -999;-999]; % error code
    vers3 = [-999; -999;-999]; % error code
end

end