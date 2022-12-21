function [plunge,trend] = plungeTrend(directionCosines)

% directionCosines must be in row unit vector format, one row for each vector, with
%
% cos1 = East
% cos2 = North
% cos3 = Upward
%
% Andrea Bistacchi 27/10/2016, modified 6/2/2019 to process several inputs

trend = atan2(directionCosines(:,1),directionCosines(:,2))*180/pi;  % IMPORTANT. DO NOT USE ATAN! IT IS LIMITED TO -PI/2 PI/2.
plunge = -asin(directionCosines(:,3))*180/pi;

% check NaNs and negative trends
trend(isnan(trend)) = 0;
trend(trend<0) = trend(trend<0) + 360;

end