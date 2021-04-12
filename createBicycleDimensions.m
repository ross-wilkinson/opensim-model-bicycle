%% Create structure with bicycle dimensions
% 
% Author(s): Ross Wilkinson, Ph.D.
%
% Units: meters, radians, kg

% Platform
% ========
S.platformLength = 100; 
S.platformHeight = 0.100; 
S.platformWidth = 2;
S.platformSlope = deg2rad(-10);

% Bicycle
% =======
S.wheelRadius = 0.35; 
S.wheelWidth = 0.023;
S.tubeRadius = 0.012;
S.crankLength = 0.175;
S.pedalLength = 0.060; 
S.pedalWidth = 0.040;
S.seatpostLength = 0.380;
S.saddleWidth = 0.133; 
S.saddleLength = 0.180; 
S.saddleHeight = 0.02;
S.handlebarWidth = 0.420; 
S.toptubeLength = 0.540;
S.wheelbaseLength = 0.978;
S.chainstayLength = 0.410;
S.seatstayLength = 0.450;
S.bbdropHeight = 0.072;
S.seattubeAngle = deg2rad(74);
S.stackHeight = 0.544;
S.reachLength = 0.384;
S.downtubeLength = 0.580;
S.downtubeAngle = 0.85;
S.frontcenterLength = sqrt(0.579^2 - 0.074^2);
S.rearcenterLength = sqrt(0.410^2 - 0.074^2);
S.headtubeAngle = deg2rad(73);
S.seattubeLength = 0.481;
S.rearstayLength = sqrt(S.seattubeLength^2+S.rearcenterLength^2);
S.headtubeLength = 0.143;
S.forkLength = 0.363;
S.stemLength = 0.100;
S.stemAngle = deg2rad(6);
S.bbWidth = 0.073; 
S.bbRadius = 0.021;
S.hubWidth = 0.130;
S.spindleWidth = 0.150;
S.steeringTubeLength = 0.183;
S.chainstayAngle = acos(S.bbdropHeight/S.chainstayLength);
S.hoodLength = 0.100;
S.hoodAngle = deg2rad(6);
S.dropLength = 0.075;

% Save structure
% ==============
save('bicycleDimensions','S')
