function circle;  % empty circular plots

[XC,YC] = pol2cart(linspace(0,2*pi,360/4),ones(1,360/4));

plot(XC,YC,'-k','LineWidth',2);

end