function [muIso,mu,weakPlanes] = defineParameters(Dip,Dir,Xp,Yp)
% DEFINE PARAMETERS

disp(' ');
disp('3- Define friction parameters.');
disp(' ');
muIso = input(' isotropic friction coefficient [] [0.7] > '); if isempty(muIso), muIso = 0.7; end
disp(' ');

mu = ones(size(Dip)).*muIso;   % initialize friction coefficient matrix to muIso

nPlanes= -1;
while (nPlanes < 0) || (nPlanes > 3)
    nPlanes = round(input(' how many weak planes? [0]> ')); if isempty(nPlanes), nPlanes = 0; end
end

%weakPlanes = zeros(nPlanes,2);
weakPlanes = zeros(nPlanes,3);

for i=1:nPlanes
    
    disp(' ');
    disp([' weak plane number ' num2str(i)]);
    disp(' ');
    muMin = input('   minimum friction coefficient [] [0.3]> '); if isempty(muMin), muMin = 0.3; end
    DipWeak = input('    dip angle of weak plane [°] > ');
    DirWeak = input('    direction of weak plane [°] > ');
    deltaAlpha = input('    anisotropy trough width [°] [15°]> '); if isempty(deltaAlpha), deltaAlpha = 15; end
    disp(' ');
    
    weakPlanes(i,:) = [DipWeak DirWeak muMin];
    
    % ANGULAR DISTANCES FROM WEAK PLANE
    
    Plunge = 90 - Dip;
    Trend = Dir + 180;
    
    Versor1 = sin(Trend.*pi/180).*cos(Plunge.*pi/180);
    Versor2 = cos(Trend.*pi/180).*cos(Plunge.*pi/180);
    Versor3 = -sin(Plunge.*pi/180);
    
    PlungeWeak = 90 - DipWeak;
    TrendWeak = DirWeak + 180;
    
    VersorWeak1 = sin(TrendWeak.*pi/180).*cos(PlungeWeak.*pi/180);
    VersorWeak2 = cos(TrendWeak.*pi/180).*cos(PlungeWeak.*pi/180);
    VersorWeak3 = -sin(PlungeWeak.*pi/180);
    
    alpha = acos( Versor1.*VersorWeak1 +  Versor2.*VersorWeak2 + Versor3.*VersorWeak3 )*180/pi;
    
    %MU PARA
    
    muPara = (muIso - muMin).*(alpha./deltaAlpha).^2 + muMin;
    
    %MIN MU
    
    mu = min(mu,muPara);
    
end

disp(' ');
disp([' -> Friction coefficient matrix successfully created.']);
disp(' ');


end