% Slip Tendency Analysis, including Anisotropic Ts and Dilation Tendency
%  Andrea Bistacchi 05/10/2010 - last update 27/10/2016
function SlipTendency

clear all; close all; clc;

% find path of this function and add sub-folders
addpath(genpath(fileparts(which(mfilename))));

% Initialize figures etc.
set(0,'DefaultFigureWindowStyle','docked','DefaultFigureColor','w');
set(0,'DefaultAxesFontName','Times','DefaultAxesFontSize',16);

figure('Name','FC - S'); % figure(1)
figure('Name','NTs - S'); % figure(2)
figure('Name','NTs - M'); % figure(3)
figure('Name','ANTs - S'); % figure(4)
figure('Name','ANTs - M'); % figure(5)
figure('Name','Td - S'); % figure(6)
figure('Name','Td - M'); % figure(7)
figure('Name','M'); % figure(8)
figure('Name','Slip - Colorbar'); % figure(9); ADDED 20/6/2019
drawnow; commandwindow % focus on command window

% define default values

% 1- stereoplot analysis
[Dip,Dir]=meshgrid(0:90,0:360);
poletrend = (Dir-180).*pi/180;     % trend of pole to plane in radians
poleplunge = (90-Dip).*pi/180;    % plunge of pole to plane in radians
rho = sqrt(2).*sin(pi/4-poleplunge./2);   %projected distance from origin in equiareal Lambert poj. (Schmidt net)
Xp = rho .* sin(poletrend);
Yp = rho .* cos(poletrend);
clear poletrend poleplunge rho;

% 3- isotropic friction = 0.7
muIso = 0.7;
mu = ones(size(Dip)).*muIso;
%weakPlanes = zeros(-1,2);
weakPlanes = zeros(-1,3);

% welcome message
disp(' ');
disp('Slip Tendency Analysis, including Anisotropic Ts and Dilation Tendency');

% Root menu

while 1
    
    disp(' ');
    disp('__________');
    disp('ROOT MENU:');
    disp(' ');
    disp('1- Define analysis: stereoplot or gOcad fault surface(s) [stereoplot]');
    disp('2- Define stress tensor');
    disp('3- Define friction parameters [mu = 0.7 isotropic]');
    disp('4- Calculate');
    disp('5- Plot');
    disp('6- Save processed data');
    disp('7- Load previously saved data');
    disp('8- Summary plot of multiple saved files NOT ACTIVE');
    disp('9- Quit');
    disp(' ');
    disp('-- Each step must be completed at least once before going to the next --');
    disp(' ');
    
    action = 0;
    while (action < 1) | (action > 9);
        action = round(input(' > '));
    end
    
    if     action == 1,	[Dip,Dir,Xp,Yp] = defineAnalysis;	% DEFINE ANALYSIS
    elseif action == 2,	[sigmaT,sigma1,sigma2,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend,rho,depth,shapeRatio] = defineStress;	% DEFINE STRESS
    elseif action == 3,	[muIso,mu,weakPlanes] = defineParameters(Dip,Dir,Xp,Yp);	% DEFINE PARAMETERS
    elseif action == 4,	[sigmaNmod,taumod,Ts,NTs,ANTs,Td,Anderson1Dip,Anderson1Dir,Anderson2Dip,Anderson2Dir,tauPlunge,tauTrend,TjointDip,TjointDir] = calculateST(sigmaT,muIso,mu,Dip,Dir,sigma1,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend);	% CALCULATE ST
    elseif action == 5,	plotST(Dip,Dir,Xp,Yp,sigmaT,sigma1,sigma2,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend,muIso,mu,weakPlanes,sigmaNmod,taumod,Ts,NTs,ANTs,Td,Anderson1Dip,Anderson1Dir,Anderson2Dip,Anderson2Dir,rho,depth,shapeRatio,tauPlunge,tauTrend,TjointDip,TjointDir);	% PLOT
    elseif action == 6, saveST(Dip,Dir,Xp,Yp,sigmaT,sigma1,sigma2,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend,muIso,mu,weakPlanes,sigmaNmod,taumod,Ts,NTs,ANTs,Td,Anderson1Dip,Anderson1Dir,Anderson2Dip,Anderson2Dir,rho,depth,shapeRatio,tauPlunge,tauTrend,TjointDip,TjointDir);	% saveST
    elseif action == 7,	clear; [Dip,Dir,Xp,Yp,sigmaT,sigma1,sigma2,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend,muIso,mu,weakPlanes,sigmaNmod,taumod,Ts,NTs,ANTs,Td,Anderson1Dip,Anderson1Dir,Anderson2Dip,Anderson2Dir,rho,depth,shapeRatio,tauPlunge,tauTrend,TjointDip,TjointDir] = loadST;% LOAD
    elseif action == 9, break;  % BREAK
    end
end

end
