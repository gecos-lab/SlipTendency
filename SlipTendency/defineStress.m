function [sigmaT,sigma1,sigma2,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend,rho,depth,shapeRatio] = defineStress
% DEFINE STRESS

disp(' ');
disp('2- Define stress tensor.');
disp(' ');
disp('   Choose input data [3]:');
disp('   1 ->  six components');
disp('   2 ->  principal stresses and orientations');
disp('   3 ->  depth, limit state condition, PHI, cohesion, pore pressure and orientations');

action = round(input(' > ')); if isempty(action), action = 3; end

if     action == 1	% six components
    
    disp(' ');
    disp('Input EFFECTIVE stress tensor components');
    sigma11 = input(' sigma11 [Pa] > ');
    sigma12 = input(' sigma12 [Pa] > ');
    sigma13 = input(' sigma13 [Pa] > ');
    sigma22 = input(' sigma22 [Pa] > ');
    sigma23 = input(' sigma23 [Pa] > ');
    sigma33 = input(' sigma33 [Pa] > ');
    lambda = input('  pore pressure factor = Pf / Sv [] [0.4]> '); if isempty(lambda), lambda = 0.4; end

    sigmaT = [sigma11 sigma12 sigma13 ; sigma12 sigma22 sigma23 ; sigma13 sigma23 sigma33];
    
    [sigma1,sigma2,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend] = formattedEig(sigmaT);
    
    sigmaV = sigmaT(3,3); % sigma vertical unscaled
    
    rho = -1;     % flag for undefined rock density
    depth = -1;   % flag for undefined depth
    
    % SHAPE RATIO
    
    shapeRatio = (sigma2 - sigma3)/(sigma1 - sigma3);
    
    % CALCULATE TOTAL STRESSES
    
    Pf = sigmaV*lambda;
    
    SIGMA1 = sigma1 + Pf;
    SIGMA2 = sigma2 + Pf;
    SIGMA3 = sigma3 + Pf;
    
    SIGMAT = sigmaT + Pf*eye(3);
    
    SIGMAV = SIGMAT(3,3);
    
elseif action == 2	% principal stresses and orientations
    
    disp(' ');
    disp('Input EFFECTIVE principal stresses');
    sigma1 = input(' sigma1 [Pa] > ');
    sigma2 = input(' sigma2 [Pa] > ');
    sigma3 = input(' sigma3 [Pa] > ');
    lambda = input('  pore pressure factor = Pf / Sv [] [0.4]> '); if isempty(lambda), lambda = 0.4; end

    %ORIENTATION
    sigma1Vers = [1;0;0]; % initialize
    while 1
        disp(' ');
        sigma1Plunge = input(' sigma1 Plunge > ');
        sigma1Trend  = input(' sigma1 Trend  > ');
        sigma3Plunge = input(' sigma3 Plunge > ');
        sigma3Trend  = input(' sigma3 Trend  > ');
        
        tol = 2; % tol = 2 degrees corrensponds to an angle of at least 88 degrees between input axes
        [sigma1Vers,sigma2Vers,sigma3Vers] = threeOrthoAxes(sigma1Plunge,sigma1Trend,sigma3Plunge,sigma3Trend,tol);
        
        if sigma1Vers(1,1) ~= -999  % exits while loop if versors are OK according to tolerance tol
            break
        else
            disp(' ');
            disp(' ERROR - vectros are not orthogonal');
            disp(' ');
        end
    end
    
    [sigma1Plunge,sigma1Trend] = plungeTrend(sigma1Vers');   % ' required because plungetrend now accepts a row vector (modified 6/2/2019)
    [sigma2Plunge,sigma2Trend] = plungeTrend(sigma2Vers');
    [sigma3Plunge,sigma3Trend] = plungeTrend(sigma3Vers');
    
    % ROTATION
    
    rotMatrix = [sigma1Vers' ; sigma2Vers' ; sigma3Vers'];
    
    sigmaT = rotMatrix' * [sigma1 0 0 ; 0 sigma2 0 ; 0 0 sigma3] * rotMatrix;
    
    sigmaV = sigmaT(3,3); % sigma vertical unscaled
    
    rho = -1;     % flag for undefined rock density
    depth = -1;   % flag for undefined depth
    
    % SHAPE RATIO
    
    shapeRatio = (sigma2 - sigma3)/(sigma1 - sigma3);
    
    % CALCULATE TOTAL STRESSES
    
    Pf = sigmaV*lambda;
    
    SIGMA1 = sigma1 + Pf;
    SIGMA2 = sigma2 + Pf;
    SIGMA3 = sigma3 + Pf;
    
    SIGMAT = sigmaT + Pf*eye(3);
    
    SIGMAV = SIGMAT(3,3);
    
elseif action == 3	% depth, limit state condition, PHI, cohesion, pore pressure and orientations
    
    % VERTICAL STRESS
    disp(' ');
    disp('Environmental conditions:');
    depth = input('                 depth [m] [5000 m] > '); if isempty(depth), depth = 5e3; end
    rho = input(' rock mass density [kg/m3] [2700 kg/m]> '); if isempty(rho), rho = 2700; end
    
    %ORIENTATION
    sigma1Vers = [1;0;0]; % initialize
    while 1
        disp(' ');
        sigma1Plunge = input(' sigma1 Plunge  [0]> '); if isempty(sigma1Plunge), sigma1Plunge = 0; end
        sigma1Trend  = input(' sigma1 Trend   [0]> '); if isempty(sigma1Trend),  sigma1Trend =  0; end
        sigma3Plunge = input(' sigma3 Plunge  [0]> '); if isempty(sigma3Plunge), sigma3Plunge = 0; end
        sigma3Trend  = input(' sigma3 Trend  [90]> '); if isempty(sigma3Trend),  sigma3Trend = 90; end
        
        tol = 2; % tol = 2 degrees corrensponds to an angle of at least 88 degrees between input axes
        [sigma1Vers,sigma2Vers,sigma3Vers] = threeOrthoAxes(sigma1Plunge,sigma1Trend,sigma3Plunge,sigma3Trend,tol);
        
        if sigma1Vers(1,1) ~= -999  % exits while loop if versors are OK according to tolerance tol
            break
        else
            disp(' ');
            disp(' ERROR - vectros are not orthogonal');
            disp(' ');
        end
    end
    
    [sigma1Plunge,sigma1Trend] = plungeTrend(sigma1Vers');   % ' required because plungetrend now accepts a row vector (modified 6/2/2019)
    [sigma2Plunge,sigma2Trend] = plungeTrend(sigma2Vers');
    [sigma3Plunge,sigma3Trend] = plungeTrend(sigma3Vers');
    
    % STRESS RATIO, FRICTION, PORE PRESSURE
    disp(' ');
    shapeRatio = input('shape ratio PHI=(s2 – s3)/(s1 – s3) [] [0.5]> '); if isempty(shapeRatio), shapeRatio = 0.5; end
    lambda = input('  pore pressure factor = Pf / Sv [] [0.4]> '); if isempty(lambda), lambda = 0.4; end
    disp(' ');
    disp('Linear Mohr/Coulomb failure envelope parameters:');
    mu = input('   friction coefficient [] [0.7]> '); if isempty(mu), mu = 0.7; end
    So = input('          cohesion So [Pa] [0]> '); if isempty(So), So = 0; end
    
    % NON-SCALED STRESS
    
    radius = ((mu + sqrt(mu^2+1))^2-1)/2;
    
    sigma3 = 1;
    sigma2 = 1 + shapeRatio*2*radius;
    sigma1 = 1 + 2*radius;
    
    % ROTATION
    
    rotMatrix = [sigma1Vers' ; sigma2Vers' ; sigma3Vers'];
    
    sigmaT = rotMatrix' * [sigma1 0 0 ; 0 sigma2 0 ; 0 0 sigma3] * rotMatrix;
    
    sigmaV = sigmaT(3,3); % sigma vertical unscaled
    
    % SCALING EFFECTIVE STRESSES
    
    g = 9.80665; % international standard value of g acceleration at Earth's surface
    
    % scaled Mohr circle -> (STRESS * (rho*g*depth + So/mu )/sigmaV) - So/mu
    % these stresses are first referred to the horizontal intercept of the
    % linear Mohr/Coulomb failure envelope (multiplication by the ratio), then
    % the origin is shifted back to zero normal stresses
    
    sigma1 = sigma1*((rho*g*depth+So/mu)/sigmaV)-So/mu;
    sigma2 = sigma2*((rho*g*depth+So/mu)/sigmaV)-So/mu;
    sigma3 = sigma3*((rho*g*depth+So/mu)/sigmaV)-So/mu;
    
    sigmaT = sigmaT.*((rho*g*depth+So/mu)/sigmaV)-So/mu;
    
    sigmaV = sigmaT(3,3); % sigma vertical NOW SCALED
    
    % CALCULATE TOTAL STRESSES
    
    Pf = sigmaV*lambda;
    
    SIGMA1 = sigma1 + Pf;
    SIGMA2 = sigma2 + Pf;
    SIGMA3 = sigma3 + Pf;
    
    SIGMAT = sigmaT + Pf*eye(3);
    
    SIGMAV = SIGMAT(3,3);
    
end

% Display values

disp(' ');
disp(' -> Stress tensor matrix successfully created.');
disp(' ');
disp(['Effective vertical stress [Pa]): ' num2str(sigmaV)]);
disp(['    Total vertical stress [Pa]): ' num2str(SIGMAV)]);
disp(['      Pore fluid pressure [Pa]): ' num2str(Pf)]);

disp(' ');
disp('Effective principal stresses (Plunge / Trend / Value [Pa]):');
disp(['Sigma1: ' num2str(sigma1Plunge) ' / ' num2str(sigma1Trend) ' / '  num2str(sigma1,'%+10.5g')]);
disp(['Sigma2: ' num2str(sigma2Plunge) ' / ' num2str(sigma2Trend) ' / '  num2str(sigma2,'%+10.5g')]);
disp(['Sigma3: ' num2str(sigma3Plunge) ' / ' num2str(sigma3Trend) ' / '  num2str(sigma3,'%+10.5g')]);
disp(' ');
disp(['             | ' num2str(sigmaT(1,1),'%+10.5g') '  ' num2str(sigmaT(1,2),'%+10.5g') '  ' num2str(sigmaT(1,3),'%+10.5g') ' |']);
disp(['sigmaT [Pa] = | ' num2str(sigmaT(2,1),'%+10.5g') '  ' num2str(sigmaT(2,2),'%+10.5g') '  ' num2str(sigmaT(2,3),'%+10.5g') ' |']);
disp(['             | ' num2str(sigmaT(3,1),'%+10.5g') '  ' num2str(sigmaT(3,2),'%+10.5g') '  ' num2str(sigmaT(3,3),'%+10.5g') ' |']);

disp(' ');
disp('Total principal stresses (Plunge / Trend / Value [Pa]):');
disp(['SIGMA1: ' num2str(sigma1Plunge) ' / ' num2str(sigma1Trend) ' / '  num2str(SIGMA1,'%+10.5g')]);
disp(['SIGMA2: ' num2str(sigma2Plunge) ' / ' num2str(sigma2Trend) ' / '  num2str(SIGMA2,'%+10.5g')]);
disp(['SIGMA3: ' num2str(sigma3Plunge) ' / ' num2str(sigma3Trend) ' / '  num2str(SIGMA3,'%+10.5g')]);
disp(' ');
disp(['             | ' num2str(SIGMAT(1,1),'%+10.5g') '  ' num2str(SIGMAT(1,2),'%+10.5g') '  ' num2str(SIGMAT(1,3),'%+10.5g') ' |']);
disp(['SIGMAT [Pa] = | ' num2str(SIGMAT(2,1),'%+10.5g') '  ' num2str(SIGMAT(2,2),'%+10.5g') '  ' num2str(SIGMAT(2,3),'%+10.5g') ' |']);
disp(['             | ' num2str(SIGMAT(3,1),'%+10.5g') '  ' num2str(SIGMAT(3,2),'%+10.5g') '  ' num2str(SIGMAT(3,3),'%+10.5g') ' |']);

disp(' ');
disp('z=up');
disp('|    y=N');
disp('|   /');
disp('|  /');
disp('| /');
disp('|/________x=E');
disp(' ');

% definition of stress regime -> normal, strike-slip, or thrust faulting.

% Mohr plot

% Mohr circles
[unitCircleX,unitCircleY] = pol2cart(linspace(0,2*pi,90),ones(1,90));
circle13X = unitCircleX*(sigma1-sigma3)/2+(sigma1+sigma3)/2;
circle12X = unitCircleX*(sigma1-sigma2)/2+(sigma1+sigma2)/2;
circle23X = unitCircleX*(sigma2-sigma3)/2+(sigma2+sigma3)/2;
circle13Y = unitCircleY*(sigma1-sigma3)/2;
circle12Y = unitCircleY*(sigma1-sigma2)/2;
circle23Y = unitCircleY*(sigma2-sigma3)/2;

% plot limits
if action == 3
    minX = -So/mu * 1.2;
    maxY = (sigma1*mu+So)*1.1;
    minY = -(sigma1*mu+So)*1.1;
else
    minX = 0;
    maxY = (sigma1-sigma3)/2*1.1;
    minY = -(sigma1-sigma3)/2*1.1;
end
maxX = max([sigma1 * 1.1 SIGMA1 * 1.1]);

% plot
figure(8); clf(8);

subplot(1,2,1); hold on;
title('Effective stress'); axis equal; axis off;
plot(circle13X,circle13Y,'-b','LineWidth',2);
plot(circle12X,circle12Y,'-b','LineWidth',2);
plot(circle23X,circle23Y,'-b','LineWidth',2);
if action == 3
    plot([-So/mu sigma1*1.2],[0 sigma1*1.2*mu+So],'--k','LineWidth',2);  % upper envelope
    plot([-So/mu sigma1*1.2],[0 -(sigma1*1.2*mu+So)],'--k','LineWidth',2);  % lower envelope
end
plot([minX maxX],[0 0],'-k','LineWidth',2);  % horizontal axis
plot([0 0],[minY maxY],'-k','LineWidth',2);  % vertical axis
plot([sigmaV sigmaV],[minY maxY],'-g','LineWidth',2);  % effective vertical stress

hold off;

subplot(1,2,2); hold on;
title('Total stress'); axis equal; axis off;
plot(circle13X+Pf,circle13Y,'-r','LineWidth',2);
plot(circle12X+Pf,circle12Y,'-r','LineWidth',2);
plot(circle23X+Pf,circle23Y,'-r','LineWidth',2);
if action == 3
    plot([-So/mu sigma1*1.2],[0 sigma1*1.2*mu+So],'--k','LineWidth',2);  % upper envelope
    plot([-So/mu sigma1*1.2],[0 -(sigma1*1.2*mu+So)],'--k','LineWidth',2);  % lower envelope
end
plot([minX maxX],[0 0],'-k','LineWidth',2);  % horizontal axis
plot([0 0],[minY maxY],'-k','LineWidth',2);  % vertical axis
plot([sigmaV+Pf sigmaV+Pf],[minY maxY],'-g','LineWidth',2);  % total vertical stress

hold off;

drawnow; commandwindow % focus on command window

end