function [Dip,Dir,Xp,Yp,sigmaT,sigma1,sigma2,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend,muIso,mu,weakPlanes,sigmaNmod,taumod,Ts,NTs,ANTs,Td,Anderson1Dip,Anderson1Dir,Anderson2Dip,Anderson2Dir,rho,depth,shapeRatio,tauPlunge,tauTrend,TjointDip,TjointDir] = loadST

disp(' ');
disp('9- Load previously saved data from .mat file');

try
    [file, path] = uigetfile('*.mat');
    load([path file]);
    
    if exist('Dip')*exist('Dir')*exist('Xp')*exist('Yp')*exist('sigmaT')*exist('sigma1')*exist('sigma2')*exist('sigma3')*exist('sigma1Plunge')*exist('sigma1Trend')*exist('sigma2Plunge')*exist('sigma2Trend')*exist('sigma3Plunge')*exist('sigma3Trend')*exist('muIso')*exist('mu')*exist('weakPlanes')*exist('sigmaNmod')*exist('taumod')*exist('Ts')*exist('NTs')*exist('ANTs')*exist('Td')*exist('Anderson1Dip')*exist('Anderson1Dir')*exist('Anderson2Dip')*exist('Anderson2Dir')*exist('TjointDip')*exist('TjointDir') == 0,
        disp(' ');
        disp([' -> some data is missing in file ' file '.']);
        disp(' ');
    else
        disp(' ');
        disp([' -> file ' file ' successfully loaded.']);
        disp(' ');
    end
    
    if exist('rho')*exist('depth') == 0
        disp(' ');
        disp([' -> rock density and depth not defined.']);
        disp([' -> input values or "-1" to leave them undefined.']);
        depth = input('                 depth [m] > ');
        rho = input(' rock mass density [kg/m3] > ');
    end
    
    if exist('Anderson1Dip')*exist('Anderson1Dir')*exist('Anderson2Dip')*exist('Anderson2Dir')*exist('TjointDip')*exist('TjointDir') == 0
        disp(' ');
        disp([' -> Andersonian planes and/or T joints and/or shape ratio not defined.']);
        disp([' -> do "calculate" before plotting.']);
    end
    
    if exist('shapeRatio') == 0
        shapeRatio=(sigma2 - sigma3)/(sigma1 - sigma3);
    end
    
    disp(' ');
    disp([' -> file ' file ' successfully loaded.']);
    disp(' ');
    
catch
    disp(' ');
    disp([' -> file NOT loaded.']);
    disp(' ');
    
end