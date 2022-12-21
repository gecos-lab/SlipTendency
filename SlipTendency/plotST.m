function plotST(Dip,Dir,Xp,Yp,sigmaT,sigma1,sigma2,sigma3,sigma1Plunge,sigma1Trend,sigma2Plunge,sigma2Trend,sigma3Plunge,sigma3Trend,muIso,mu,weakPlanes,sigmaNmod,taumod,Ts,NTs,ANTs,Td,Anderson1Dip,Anderson1Dir,Anderson2Dip,Anderson2Dir,rho,depth,shapeRatio,tauPlunge,tauTrend,TjointDip,TjointDir)

disp(' ');
disp('5- Plot');
disp(' ');
disp(['                depth [m] = ' num2str(depth)]);
disp(['rock mass density [kg/m3] = ' num2str(rho)]);
disp(' ');
disp(['            shapeRatio [] = ' num2str(shapeRatio)]);

% projected coordinates of poles
[sigma1Xl,sigma1Yl] = plotLine(sigma1Plunge,sigma1Trend);
[sigma2Xl,sigma2Yl] = plotLine(sigma2Plunge,sigma2Trend);
[sigma3Xl,sigma3Yl] = plotLine(sigma3Plunge,sigma3Trend);

[weakPlanesXp,weakPlanesYp] = plotPole(weakPlanes(:,1),weakPlanes(:,2));

[Anderson1Xp,Anderson1Yp] = plotPole(Anderson1Dip,Anderson1Dir);
[Anderson2Xp,Anderson2Yp] = plotPole(Anderson2Dip,Anderson2Dir);

% Mohr circles
[unitCircleX,unitCircleY] = pol2cart(linspace(0,2*pi,90),ones(1,90));
circle13X = unitCircleX*(sigma1-sigma3)/2+(sigma1+sigma3)/2;
circle12X = unitCircleX*(sigma1-sigma2)/2+(sigma1+sigma2)/2;
circle23X = unitCircleX*(sigma2-sigma3)/2+(sigma2+sigma3)/2;
circle13Y = unitCircleY*(sigma1-sigma3)/2;
circle12Y = unitCircleY*(sigma1-sigma2)/2;
circle23Y = unitCircleY*(sigma2-sigma3)/2;

% find parameters for Andersonian planes
% Anderson 1
[Anderson1I,Anderson1J]=find(round(Anderson1Dip)==Dip & round(Anderson1Dir)==Dir);
sigmaNmodAnderson1 = sigmaNmod(Anderson1I,Anderson1J);
taumodAnderson1 = taumod(Anderson1I,Anderson1J);
% TsAnderson1 = Ts(Anderson1I,Anderson1J);
NTsAnderson1 = NTs(Anderson1I,Anderson1J);
ANTsAnderson1 = ANTs(Anderson1I,Anderson1J);
TdAnderson1 = Td(Anderson1I,Anderson1J);
tauPlungeAnderson1 = tauPlunge(Anderson1I,Anderson1J);
tauTrendAnderson1 = tauTrend(Anderson1I,Anderson1J);
%%%%%%%%_____________%%%%%%%%
disp(' ')
disp('Predicted Anderson 1 plane Dip/Dir ; slip vector Plunge/Trend->');
disp([num2str(Anderson1Dip,'%02.0f') ' / ' num2str(Anderson1Dir,'%03.0f') ' ; ' num2str(tauPlungeAnderson1,'%02.0f') ' / ' num2str(tauTrendAnderson1,'%03.0f')]);

% Anderson 2
[Anderson2I,Anderson2J]=find(round(Anderson2Dip)==Dip & round(Anderson2Dir)==Dir);
sigmaNmodAnderson2 = sigmaNmod(Anderson2I,Anderson2J);
taumodAnderson2 = taumod(Anderson2I,Anderson2J);
% TsAnderson2 = Ts(Anderson2I,Anderson2J);
NTsAnderson2 = NTs(Anderson2I,Anderson2J);
ANTsAnderson2 = ANTs(Anderson2I,Anderson2J);
TdAnderson2 = Td(Anderson2I,Anderson2J);
tauPlungeAnderson2 = tauPlunge(Anderson2I,Anderson2J);
tauTrendAnderson2 = tauTrend(Anderson2I,Anderson2J);
%%%%%%%%_____________%%%%%%%%
disp(' ')
disp('Predicted Anderson 2 plane Dip/Dir ; slip vector Plunge/Trend->');
disp([num2str(Anderson2Dip,'%02.0f') ' / ' num2str(Anderson2Dir,'%03.0f') ' ; ' num2str(tauPlungeAnderson2,'%02.0f') ' / ' num2str(tauTrendAnderson2,'%03.0f')]);

% find parameters for weak planes
sigmaNmodWeak = zeros(size(weakPlanes,1),1);
taumodWeak = zeros(size(weakPlanes,1),1);
% TsWeak = zeros(size(weakPlanes,1),1);
NTsWeak = zeros(size(weakPlanes,1),1);
ANTsWeak = zeros(size(weakPlanes,1),1);
TdWeak = zeros(size(weakPlanes,1),1);

for i = 1:size(weakPlanes,1)

[weakPlanesI,weakPlanesJ]=find(round(weakPlanes(i,1))==Dip & round(weakPlanes(i,2))==Dir);
sigmaNmodWeak(i) = sigmaNmod(weakPlanesI,weakPlanesJ);
taumodWeak(i) = taumod(weakPlanesI,weakPlanesJ);
% TsWeak(i) = Ts(weakPlanesI,weakPlanesJ);
NTsWeak(i) = NTs(weakPlanesI,weakPlanesJ);
ANTsWeak(i) = ANTs(weakPlanesI,weakPlanesJ);
TdWeak(i) = Td(weakPlanesI,weakPlanesJ);

end

% plotting

figure(1); hold off; clf; hold on; title('Anisotropic Friction Coefficient - Schmidt plot'); axis equal; axis off;
figure(2); hold off; clf; hold on; title('Isotropic Normalized Slip Tendency NTs - Schmidt plot'); axis equal; axis off;
figure(3); hold off; clf; hold on; title('Isotropic Normailzed Slip Tendency NTs - Mohr plot'); axis equal; axis off;
figure(4); hold off; clf; hold on; title('Anisotropic Normalized Slip Tendency ANTs - Schmidt plot'); axis equal; axis off;
figure(5); hold off; clf; hold on; title('Anisotropic Normailzed Slip Tendency ANTs - Mohr plot'); axis equal; axis off;
figure(6); hold off; clf; hold on; title('Dilation Tendency Td - Schmidt plot'); axis equal; axis off;
figure(7); hold off; clf; hold on; title('Dilation Tendency Td - Mohr plot'); axis equal; axis off;
figure(9); hold off; clf; hold on; title('Isotropic Normalized Slip Tendency NTs and predicted slip vectors - Schmidt plot'); axis equal; axis off;

% 1- Anisotropic Friction Coefficient - Schmidt plot
if size(weakPlanes,1)>0
    figure(1);
    contourf(Xp,Yp,mu,20,'LineStyle','none');
    circle;
    plot(weakPlanesXp,weakPlanesYp,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
    axis equal;
    plot(1.2,0.9,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
    text(1.2,0.9,'    Weak plane(s):','HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    for i=1:size(weakPlanes,1)
        text(1.2,0.9-.10*i,['    ' num2str(weakPlanes(i,1),'%02.0f') ' / ' num2str(weakPlanes(i,2),'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    end
end


% 2- Isotropic Normalized Slip Tendency NTs - Schmidt plot
figure(2);
contourf(Xp,Yp,NTs,20,'LineStyle','none');
circle;
plot(weakPlanesXp,weakPlanesYp,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
plot(sigma1Xl,sigma1Yl,'h','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
plot(sigma2Xl,sigma2Yl,'p','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
plot(sigma3Xl,sigma3Yl,'d','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',12);
quiver(Anderson1Xp,Anderson1Yp,sin(tauTrendAnderson1*pi/180),cos(tauTrendAnderson1*pi/180),'-k','AutoScaleFactor',0.15,'LineWidth',2,'MaxHeadSize',2,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);   % MODIFIED 20/6/2019
quiver(Anderson2Xp,Anderson2Yp,sin(tauTrendAnderson2*pi/180),cos(tauTrendAnderson2*pi/180),'-k','AutoScaleFactor',0.15,'LineWidth',2,'MaxHeadSize',2,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);   % MODIFIED 20/6/2019
axis equal;

plot(1.2,0.9    ,'h','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
text(1.2,0.9    ,['    Sigma1: ' num2str(sigma1Plunge,'%02.0f') ' / ' num2str(sigma1Trend,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
plot(1.2,0.9-.15,'p','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
text(1.2,0.9-.15,['    Sigma2: ' num2str(sigma2Plunge,'%02.0f') ' / ' num2str(sigma2Trend,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
plot(1.2,0.9-.30,'d','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',12);
text(1.2,0.9-.30,['    Sigma3: ' num2str(sigma3Plunge,'%02.0f') ' / ' num2str(sigma3Trend,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
text(1.2,0.9-.40,['    T joints: ' num2str(TjointDip,'%02.0f') ' / ' num2str(TjointDir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
plot(1.2,0.9-.55,'o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);
text(1.2,0.9-.55,'    Andersonian planes:','HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
text(1.2,0.9-.65,['    ' num2str(Anderson1Dip,'%02.0f') ' / ' num2str(Anderson1Dir,'%03.0f') '  &  ' num2str(Anderson2Dip,'%02.0f') ' / ' num2str(Anderson2Dir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');

if size(weakPlanes,1)>0
    plot(1.2,0.9-.80,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
    text(1.2,0.9-.80,'    Weak plane(s)','HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    for i=1:size(weakPlanes,1)
        text(1.2-.36+.36*i,0.9-.90,['    ' num2str(weakPlanes(i,1),'%02.0f') ' / ' num2str(weakPlanes(i,2),'%03.0f') ';'],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    end
end

% 3- Isotropic Normailzed Slip Tendency NTs - Mohr plot
figure(3);
scatter(reshape(sigmaNmod,size(sigmaNmod,1)*size(sigmaNmod,2),1),reshape(taumod,size(sigmaNmod,1)*size(sigmaNmod,2),1),15,reshape(NTs,size(sigmaNmod,1)*size(sigmaNmod,2),1),'filled');
plot(circle13X,circle13Y,'-k','LineWidth',2);
plot(circle12X,circle12Y,'-k','LineWidth',2);
plot(circle23X,circle23Y,'-k','LineWidth',2);
plot([0 sigma1*1.2],[0 0],'-k','LineWidth',2);
plot([0 0],[-(sigma1-sigma3)/2*1.2 (sigma1-sigma3)/2*1.2],'-k','LineWidth',2);
plot(sigmaNmodAnderson1,taumodAnderson1,'o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);
plot(sigmaNmodAnderson2,taumodAnderson2,'o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);
plot(sigmaNmodWeak,taumodWeak,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
% plot([-So/muIso sigma1*1.2],[0 sigma1*1.2*muIso+So],'--k','LineWidth',2);  % upper envelope
% plot([-So/muIso sigma1*1.2],[0 -(sigma1*1.2*muIso+So)],'--k','LineWidth',2);  % lower envelope
plot([0 sigma1*1.2],[0 sigma1*1.2*muIso],'--k','LineWidth',2);  % upper envelope
plot([0 sigma1*1.2],[0 -(sigma1*1.2*muIso)],'--k','LineWidth',2);  % lower envelope
for i = 1:size(weakPlanes,1)
    plot([0 sigma1*1.2],[0 sigma1*1.2*weakPlanes(i,3)],'--k','LineWidth',2);  % upper envelope
    plot([0 sigma1*1.2],[0 -(sigma1*1.2*weakPlanes(i,3))],'--k','LineWidth',2);  % lower envelope
end
text(sigmaNmodAnderson1,taumodAnderson1,['NTs = ' num2str(NTsAnderson1,2) '     '],'HorizontalAlignment','right','FontName','Times','FontSize',12,'FontWeight','bold');
text(sigmaNmodAnderson2,taumodAnderson2,['NTs = ' num2str(NTsAnderson2,2) '     '],'HorizontalAlignment','right','FontName','Times','FontSize',12,'FontWeight','bold');

% 4- Anisotropic Normalized Slip Tendency ANTs - Schmidt plot
figure(4); contourf(Xp,Yp,ANTs,20,'LineStyle','none'); circle;
plot(weakPlanesXp,weakPlanesYp,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
plot(sigma1Xl,sigma1Yl,'h','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
plot(sigma2Xl,sigma2Yl,'p','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
plot(sigma3Xl,sigma3Yl,'d','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',12);
quiver(Anderson1Xp,Anderson1Yp,sin(tauTrendAnderson1*pi/180),cos(tauTrendAnderson1*pi/180),'-k','AutoScaleFactor',0.15,'LineWidth',2,'MaxHeadSize',2,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);   % MODIFIED 20/6/2019
quiver(Anderson2Xp,Anderson2Yp,sin(tauTrendAnderson2*pi/180),cos(tauTrendAnderson2*pi/180),'-k','AutoScaleFactor',0.15,'LineWidth',2,'MaxHeadSize',2,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);   % MODIFIED 20/6/2019
axis equal;

plot(1.2,0.9    ,'h','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
text(1.2,0.9    ,['    Sigma1: ' num2str(sigma1Plunge,'%02.0f') ' / ' num2str(sigma1Trend,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
plot(1.2,0.9-.15,'p','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
text(1.2,0.9-.15,['    Sigma2: ' num2str(sigma2Plunge,'%02.0f') ' / ' num2str(sigma2Trend,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
plot(1.2,0.9-.30,'d','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',12);
text(1.2,0.9-.30,['    Sigma3: ' num2str(sigma3Plunge,'%02.0f') ' / ' num2str(sigma3Trend,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
text(1.2,0.9-.40,['    T joints: ' num2str(TjointDip,'%02.0f') ' / ' num2str(TjointDir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
plot(1.2,0.9-.55,'o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);
text(1.2,0.9-.55,'    Andersonian planes:','HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
text(1.2,0.9-.65,['    ' num2str(Anderson1Dip,'%02.0f') ' / ' num2str(Anderson1Dir,'%03.0f') '  &  ' num2str(Anderson2Dip,'%02.0f') ' / ' num2str(Anderson2Dir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
if size(weakPlanes,1)>0
    plot(1.2,0.9-.80,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
    text(1.2,0.9-.80,'    Weak plane(s)','HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    for i=1:size(weakPlanes,1)
        text(1.2-.36+.36*i,0.9-.80,['    ' num2str(weakPlanes(i,1),'%02.0f') ' / ' num2str(weakPlanes(i,2),'%03.0f') ';'],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    end
end

% 5- Anisotropic Normailzed Slip Tendency ANTs - Mohr plot
figure(5); scatter(reshape(sigmaNmod,size(sigmaNmod,1)*size(sigmaNmod,2),1),reshape(taumod,size(sigmaNmod,1)*size(sigmaNmod,2),1),15,reshape(ANTs,size(sigmaNmod,1)*size(sigmaNmod,2),1),'filled');
plot(circle13X,circle13Y,'-k','LineWidth',2);
plot(circle12X,circle12Y,'-k','LineWidth',2);
plot(circle23X,circle23Y,'-k','LineWidth',2);
plot([0 sigma1*1.2],[0 0],'-k','LineWidth',2);
plot([0 0],[-(sigma1-sigma3)/2*1.2 (sigma1-sigma3)/2*1.2],'-k','LineWidth',2);
plot(sigmaNmodAnderson1,taumodAnderson1,'o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);
plot(sigmaNmodAnderson2,taumodAnderson2,'o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);
plot(sigmaNmodWeak,taumodWeak,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
% plot([-So/muIso sigma1*1.2],[0 sigma1*1.2*muIso+So],'--k','LineWidth',2);  % upper envelope
% plot([-So/muIso sigma1*1.2],[0 -(sigma1*1.2*muIso+So)],'--k','LineWidth',2);  % lower envelope
plot([0 sigma1*1.2],[0 sigma1*1.2*muIso],'--k','LineWidth',2);  % upper envelope
plot([0 sigma1*1.2],[0 -(sigma1*1.2*muIso)],'--k','LineWidth',2);  % lower envelope
for i = 1:size(weakPlanes,1)
    plot([0 sigma1*1.2],[0 sigma1*1.2*weakPlanes(i,3)],'--k','LineWidth',2);  % upper envelope
    plot([0 sigma1*1.2],[0 -(sigma1*1.2*weakPlanes(i,3))],'--k','LineWidth',2);  % lower envelope
end
text(sigmaNmodAnderson1,taumodAnderson1,['ANTs = ' num2str(ANTsAnderson1,2) '     '],'HorizontalAlignment','right','FontName','Times','FontSize',12,'FontWeight','bold');
text(sigmaNmodAnderson2,taumodAnderson2,['ANTs = ' num2str(ANTsAnderson2,2) '     '],'HorizontalAlignment','right','FontName','Times','FontSize',12,'FontWeight','bold');

% 6- Dilation Tendency Td - Schmidt plot
figure(6); contourf(Xp,Yp,Td,20,'LineStyle','none'); circle;
plot(weakPlanesXp,weakPlanesYp,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
plot(sigma1Xl,sigma1Yl,'h','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
plot(sigma2Xl,sigma2Yl,'p','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
plot(sigma3Xl,sigma3Yl,'d','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',12);
quiver(Anderson1Xp,Anderson1Yp,sin(tauTrendAnderson1*pi/180),cos(tauTrendAnderson1*pi/180),'-k','AutoScaleFactor',0.15,'LineWidth',2,'MaxHeadSize',2,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);   % MODIFIED 20/6/2019
quiver(Anderson2Xp,Anderson2Yp,sin(tauTrendAnderson2*pi/180),cos(tauTrendAnderson2*pi/180),'-k','AutoScaleFactor',0.15,'LineWidth',2,'MaxHeadSize',2,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);   % MODIFIED 20/6/2019
axis equal;

plot(1.2,0.9    ,'h','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
text(1.2,0.9    ,['    Sigma1: ' num2str(sigma1Plunge,'%02.0f') ' / ' num2str(sigma1Trend,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
plot(1.2,0.9-.15,'p','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',15);
text(1.2,0.9-.15,['    Sigma2: ' num2str(sigma2Plunge,'%02.0f') ' / ' num2str(sigma2Trend,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
plot(1.2,0.9-.30,'d','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',12);
text(1.2,0.9-.30,['    Sigma3: ' num2str(sigma3Plunge,'%02.0f') ' / ' num2str(sigma3Trend,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
text(1.2,0.9-.40,['    T joints: ' num2str(TjointDip,'%02.0f') ' / ' num2str(TjointDir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
plot(1.2,0.9-.55,'o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);
text(1.2,0.9-.55,'    Andersonian planes:','HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
text(1.2,0.9-.65,['    ' num2str(Anderson1Dip,'%02.0f') ' / ' num2str(Anderson1Dir,'%03.0f') '  &  ' num2str(Anderson2Dip,'%02.0f') ' / ' num2str(Anderson2Dir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
if size(weakPlanes,1)>0
    plot(1.2,0.9-.80,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
    text(1.2,0.9-.80,'    Weak plane(s)','HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    for i=1:size(weakPlanes,1)
        text(1.2-.36+.36*i,0.9-.80,['    ' num2str(weakPlanes(i,1),'%02.0f') ' / ' num2str(weakPlanes(i,2),'%03.0f') ';'],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    end
end

% 7- Dilation Tendency Td - Mohr plot
figure(7); scatter(reshape(sigmaNmod,size(sigmaNmod,1)*size(sigmaNmod,2),1),reshape(taumod,size(sigmaNmod,1)*size(sigmaNmod,2),1),15,reshape(Td,size(sigmaNmod,1)*size(sigmaNmod,2),1),'filled');
plot(circle13X,circle13Y,'-k','LineWidth',2);
plot(circle12X,circle12Y,'-k','LineWidth',2);
plot(circle23X,circle23Y,'-k','LineWidth',2);
plot([0 sigma1*1.2],[0 0],'-k','LineWidth',2);
plot([0 0],[-(sigma1-sigma3)/2*1.2 (sigma1-sigma3)/2*1.2],'-k','LineWidth',2);
plot(sigmaNmodAnderson1,taumodAnderson1,'o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);
plot(sigmaNmodAnderson2,taumodAnderson2,'o','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',11);
plot(sigmaNmodWeak,taumodWeak,'v','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',11);
% plot([-So/muIso sigma1*1.2],[0 sigma1*1.2*muIso+So],'--k','LineWidth',2);  % upper envelope
% plot([-So/muIso sigma1*1.2],[0 -(sigma1*1.2*muIso+So)],'--k','LineWidth',2);  % lower envelope
plot([0 sigma1*1.2],[0 sigma1*1.2*muIso],'--k','LineWidth',2);  % upper envelope
plot([0 sigma1*1.2],[0 -(sigma1*1.2*muIso)],'--k','LineWidth',2);  % lower envelope
for i = 1:size(weakPlanes,1)
    plot([0 sigma1*1.2],[0 sigma1*1.2*weakPlanes(i,3)],'--k','LineWidth',2);  % upper envelope
    plot([0 sigma1*1.2],[0 -(sigma1*1.2*weakPlanes(i,3))],'--k','LineWidth',2);  % lower envelope
end
text(sigmaNmodAnderson1,taumodAnderson1,['Td = ' num2str(TdAnderson1,2) '     '],'HorizontalAlignment','right','FontName','Times','FontSize',12,'FontWeight','bold');
text(sigmaNmodAnderson2,taumodAnderson2,['Td = ' num2str(TdAnderson2,2) '     '],'HorizontalAlignment','right','FontName','Times','FontSize',12,'FontWeight','bold');

% 9- Slip vectors - Schmidt plot - ADDED 20/6/2019
figure(9); contourf(Xp,Yp,NTs,20,'LineStyle','none'); colorbar; circle;
quiver(Xp(1:10:end,1:10:end),Yp(1:10:end,1:10:end),sin(tauTrend(1:10:end,1:10:end)*pi/180),cos(tauTrend(1:10:end,1:10:end)*pi/180),'-k','LineWidth',1,'MaxHeadSize',0.2,'AutoScaleFactor',0.4,'Marker','o','MarkerSize',1);
axis equal;


% interactive plot of several fault planes
drawnow; commandwindow % focus on command window
i = 0;
while 1
    i = i+1;
    disp(' ');
    disp('Define fault plane (negative values to break) ->');
    faultDip = input(' Fault Dip [°] > '); if faultDip<0, break, end
    faultDir = input(' Fault Dir [°] > '); if faultDir<0, break, end
    
    [faultXp,faultYp] = plotPole(faultDip,faultDir);
    
    [faultI,faultJ]=find(round(faultDip)==Dip & round(faultDir)==Dir);
    sigmaNmodFault = sigmaNmod(faultI,faultJ);
    taumodFault = taumod(faultI,faultJ);
    % TsFault = Ts(faultI,faultJ);
    NTsFault = NTs(faultI,faultJ);
    ANTsFault = ANTs(faultI,faultJ);
    TdFault = Td(faultI,faultJ);
    tauPlungeFault = tauPlunge(faultI,faultJ);
    tauTrendFault = tauTrend(faultI,faultJ);
    %%%%%%%%_____________%%%%%%%%
    disp('Predicted fault plane Dip/Dir ; slip vector Plunge/Trend ->');
    disp([num2str(round(faultDip),'%02.0f') ' / ' num2str(round(faultDir),'%03.0f') ' ; ' num2str(tauPlungeFault,'%02.0f') ' / ' num2str(tauTrendFault,'%03.0f')]);

    
    % 2- Isotropic Normalized Slip Tendency NTs - Schmidt plot
    figure(2);
    
    %plot(faultXp,faultYp,'s','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);
    if i==1
        plot(1.2,0.9-.95,'s','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);
        text(1.2,0.9-.95,'    Fault plane(s):','HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    end
    text(1.2,0.9-.95-.15*i,['    ' num2str(faultDip,'%02.0f') ' / ' num2str(faultDir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    
    quiver(faultXp,faultYp,sin(tauTrendFault*pi/180),cos(tauTrendFault*pi/180),'-k','AutoScaleFactor',0.15,'LineWidth',2,'MaxHeadSize',2,'Marker','s','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);   % MODIFIED 20/6/2019
    text(faultXp,faultYp,['     NTs = ' num2str(NTsFault,2)],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    
    % 3- Isotropic Normailzed Slip Tendency NTs - Mohr plot
    figure(3);
    plot(sigmaNmodFault,taumodFault,'s','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);
    text(sigmaNmodFault,taumodFault,['     NTs = ' num2str(NTsFault,2) ' @ ' num2str(faultDip,'%02.0f') ' / ' num2str(faultDir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    
    % 4- Anisotropic Normalized Slip Tendency ANTs - Schmidt plot
    figure(4);
    plot(faultXp,faultYp,'s','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);
    if i==1
        plot(1.2,0.9-.95,'s','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);
        text(1.2,0.9-.95,'    Fault plane(s):','HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    end
    text(1.2,0.9-.95-.15*i,['    ' num2str(faultDip,'%02.0f') ' / ' num2str(faultDir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    
    quiver(faultXp,faultYp,sin(tauTrendFault*pi/180),cos(tauTrendFault*pi/180),'-k','AutoScaleFactor',0.15,'LineWidth',2,'MaxHeadSize',2,'Marker','s','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);   % MODIFIED 20/6/2019
    text(faultXp,faultYp,['     ANTs = ' num2str(ANTsFault,2)],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    
    % 5- Anisotropic Normailzed Slip Tendency ANTs - Mohr plot
    figure(5);
    plot(sigmaNmodFault,taumodFault,'s','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);
    text(sigmaNmodFault,taumodFault,['     ANTs = ' num2str(ANTsFault,2) ' @ ' num2str(faultDip,'%02.0f') ' / ' num2str(faultDir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    
    % 6- Dilation Tendency Td - Schmidt plot
    figure(6);
    plot(faultXp,faultYp,'s','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);
    if i==1
        plot(1.2,0.9-.95,'s','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);
        text(1.2,0.9-.95,'    Fault plane(s):','HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    end
    text(1.2,0.9-.95-.15*i,['    ' num2str(faultDip,'%02.0f') ' / ' num2str(faultDir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    
    quiver(faultXp,faultYp,sin(tauTrendFault*pi/180),cos(tauTrendFault*pi/180),'-k','AutoScaleFactor',0.15,'LineWidth',2,'MaxHeadSize',2,'Marker','s','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);   % MODIFIED 20/6/2019
    text(faultXp,faultYp,['     Td = ' num2str(TdFault,2)],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    
    % 7- Dilation Tendency Td - Mohr plot
    figure(7);
    plot(sigmaNmodFault,taumodFault,'s','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',11);
    text(sigmaNmodFault,taumodFault,['     Td = ' num2str(TdFault,2) ' @ ' num2str(faultDip,'%02.0f') ' / ' num2str(faultDir,'%03.0f')],'HorizontalAlignment','left','FontName','Times','FontSize',12,'FontWeight','bold');
    
end

disp(' ');
disp([' -> Plotting completed.']);
disp(' ');
drawnow; commandwindow % focus on command window

end