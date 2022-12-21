function [eigVal1,eigVal2,eigVal3,eigVect1Plunge,eigVect1Trend,eigVect2Plunge,eigVect2Trend,eigVect3Plunge,eigVect3Trend] = formattedEig(Tensor)

[eigVect,eigVal] = eig(Tensor);

[eigVal1,column1] = max([eigVal(1,1) eigVal(2,2) eigVal(3,3)]);
[eigVal3,column3] = min([eigVal(1,1) eigVal(2,2) eigVal(3,3)]);
column2 = 6 - column1 - column3;
eigVal2 = eigVal(column2,column2);

eigVect1 = eigVect(:,column1);
eigVect2 = eigVect(:,column2);
eigVect3 = eigVect(:,column3);

[eigVect1Plunge,eigVect1Trend] = plungeTrend(eigVect1');   % ' required because plungetrend now accepts a row vector (modified 6/2/2019)
[eigVect2Plunge,eigVect2Trend] = plungeTrend(eigVect2');
[eigVect3Plunge,eigVect3Trend] = plungeTrend(eigVect3');

end
