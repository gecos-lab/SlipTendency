function [sigmaNmod,taumod,Ts,NTs,ANTs,Td,Anderson1Dip,Anderson1Dir,Anderson2Dip,Anderson2Dir,tauPlunge,tauTrend,TjointDip,TjointDir] = calculateST(sigmaT,muIso,mu,Dip,Dir,sigma1,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend)

disp(' ');
disp('4- Calculate');
disp(' ');

% calculate normal and shear stress using Cauchy formula

% sigmaV = zeros([size(Dip),3]); % MODIFIED 20/6/2019
% sigmaN = zeros([size(Dip),3]); % MODIFIED 20/6/2019
% tau = zeros([size(Dip),3]); % MODIFIED 20/6/2019
sigmaNmod = zeros(size(Dip));
taumod = zeros(size(Dip));
tauPlunge = zeros(size(Dip));
tauTrend = zeros(size(Dip));

sigma2Vers = lineation(sigma2Plunge,sigma2Trend)';  % ' required because lineation now returns a row vector (modified 6/2/2019)

for i=1:size(Dip,1)       % cicle Dip matrix along rows
    for j=1:size(Dip,2)   % cicle Dip matrix along columns
        n = -(pole(Dip(i,j),Dir(i,j)));  % versor normal to Dip/Dir plane, pointing upwards (pole function returns a downwards pointing versor)"-" MODIFIED 20/6/2019 to have upwards pointing versor
        sigmaV = sigmaT*n;               % stress vector (traction) resolved on Dip/Dir plane
        sigmaNmod(i,j) = sigmaV'*n;      % modulus of normal component of sigmaV
        sigmaN = sigmaNmod(i,j)*n;       % normal component of sigmaV
        tau = sigmaV - sigmaN;           % tangential component of sigmaV
        %taumod(i,j) = sqrt(tau'*tau) * (((sigma2Vers'*cross(n,tau)) >=0 ) - ((sigma2Vers'*cross(n,tau)) <0 )); % modulus of tangential component of sigmaV - last strange part required because sign(0) = 0
        taumod(i,j) = sqrt(tau'*tau);    % MODIFIED 20/6/2019 controlling this with sigma 2 was a strange solution
        tauVers = -tau./taumod(i,j);     % versor parallel to tangential component of sigmaV "-" MODIFIED 20/6/2019 to get slip vector on hangingwall
        [tauPlunge(i,j),tauTrend(i,j)] = plungeTrend(tauVers');   % ' required because plungetrend now accepts a row vector (modified 6/2/2019)
    end
end

% calculate slip tendency

Ts = abs(taumod)./sigmaNmod;

NTs = Ts./muIso;

ANTs = Ts./mu;

Td = (sigma1 - sigmaNmod)/(sigma1 - sigma3);

% calculate Andersonian and T joints planes

phi = atan(muIso)*180/pi; % friction angle [°]
theta = 45-phi/2; % fault to sigma1 angle [°]

Anderson1V = [ sin(theta*pi/180) 0 cos(theta*pi/180)]';
Anderson2V = [-sin(theta*pi/180) 0 cos(theta*pi/180)]';

sigma1Vers = lineation(sigma1Plunge,sigma1Trend)';   % ' required because lineation now returns a row vector (modified 6/2/2019)
sigma2Vers = lineation(sigma2Plunge,sigma2Trend)';
sigma3Vers = lineation(sigma3Plunge,sigma3Trend)';

rotMatrix = [sigma1Vers' ; sigma2Vers' ; sigma3Vers'];

Anderson1V = rotMatrix' * Anderson1V;
Anderson2V = rotMatrix' * Anderson2V;

[Anderson1Dip,Anderson1Dir] = dipDir(Anderson1V);
[Anderson2Dip,Anderson2Dir] = dipDir(Anderson2V);

% T joints are simply perpendicular to sigma3
[TjointDip,TjointDir] = dipDir(sigma3Vers);

% correction for overturned Andersonian plane 1
if Anderson1Dip < 0
    Anderson1Dip = -Anderson1Dip;
    Anderson1Dir = Anderson1Dir - 180;
    if Anderson1Dir < 0
        Anderson1Dir = Anderson1Dir +360;
    end
end

% correction for overturned Andersonian plane 2
if Anderson2Dip < 0
    Anderson2Dip = -Anderson2Dip;
    Anderson2Dir = Anderson2Dir - 180;
    if Anderson2Dir < 0
        Anderson2Dir = Anderson2Dir +360;
    end
end

% correction for overturned T joint
if TjointDip < 0
    TjointDip = -TjointDip;
    TjointDir = TjointDir - 180;
    if TjointDir < 0
        TjointDir = TjointDir +360;
    end
end

disp(' ');
disp([' -> Slip tendency calculation completed.']);
disp(' ');

end