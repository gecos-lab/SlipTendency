function [Dip,Dir,Xp,Yp] = defineAnalysis
% DEFINE ANALYSIS

disp(' ');
disp('1- Define analysis: (1) stereoplot or (2) gOcad fault surface(s) NOT ACTIVE [1]:');
disp('');

action = round(input(' > '));

if isempty(action), action = 1; end

if action == 1	% stereoplot
    
    [Dip,Dir]=meshgrid(0:90,0:360);
    
    poletrend = (Dir-180).*pi/180;     % trend of pole to plane in radians
    poleplunge = (90-Dip).*pi/180;    % plunge of pole to plane in radians
    rho = sqrt(2).*sin(pi/4-poleplunge./2);   %projected distance from origin in equiareal Lambert poj. (Schmidt net)
    Xp = rho .* sin(poletrend);
    Yp = rho .* cos(poletrend);
    
elseif action == 2	% gOcad fault surface(s)

end

disp(' ');
disp([' -> Dip/Dir and Xp/Yp matrix successfully created.']);
disp(' ');

end