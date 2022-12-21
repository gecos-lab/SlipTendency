function saveST(Dip,Dir,Xp,Yp,sigmaT,sigma1,sigma2,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend,muIso,mu,weakPlanes,sigmaNmod,taumod,Ts,NTs,ANTs,Td,Anderson1Dip,Anderson1Dir,Anderson2Dip,Anderson2Dir,rho,depth,shapeRatio,tauPlunge,tauTrend,TjointDip,TjointDir)

disp(' ');
disp('8- Save processed data to .mat file');

try
    [file, path] = uiputfile('*.mat');
    save([path file]);
    
    disp(' ');
    disp([' -> file ' file ' successfully saved.']);
    disp(' ');
    
catch
    disp(' ');
    disp([' -> file NOT saved.']);
    disp(' ');
    
end