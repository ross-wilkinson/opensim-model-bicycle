function osimModel = buildModelBicycle(S)
%BUILDMODELBICYCLE Summary of this function goes here
%
% Author(s): Ross Wilkinson, Ph.D.
%
% The body dimensions shown below are commonly reported by bicycle
% manufacturers who make high-quality road and mountain bikes. The default
% values are based on a 54cm 2019 Specialized Tarmac road bicycle.
%
% Units: meters, radians, kg
%
% Input:
% ======
% * S: A structure containing the required body dimenions to build the
% model. To create this structure run 'createBicycleDimensions.m'.

% Import OpenSim Libraries into Matlab
% ====================================
import org.opensim.modeling.*

% Initialize an (empty) OpenSim Model
% ===================================
osimModel = Model();
osimModel.setName('Bicycle');

% Get a reference to the ground object
% ====================================
ground = osimModel.getGround();

% Define the acceleration of gravity
% ==================================
osimModel.setGravity(Vec3(0, -9.80665, 0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Construct Bodies and Joints %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Body: Platform
% ==============
platform = Body();
platform.setName('platform');
platform.setMass(1);
platform.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
platformGeometry = Brick( Vec3(S.platformLength/2,S.platformHeight/2,S.platformWidth/2) );
platformGeometry.setColor( Vec3(1,0,0) );
platform.attachGeometry(platformGeometry);
% Add Body to the Model
osimModel.addBody(platform);

% Joint: Platform {Pin} Ground 
% ============================
platformToGround = PinJoint('platformToGround',... % Joint Name
    ground,... % Parent Frame
    Vec3(0,-S.platformHeight/2,0),... % Translation in Parent Frame
    Vec3(0,0,0),... % Orientation in Parent Frame
    platform,... % Child Frame
    Vec3(0,0,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% RotationZ
platform_rz = platformToGround.upd_coordinates(0);
platform_rz.setRange([deg2rad(-100), deg2rad(100)]);
platform_rz.setName('platform_rz');
platform_rz.setDefaultValue(S.platformSlope); % -10 deg. slope
platform_rz.setDefaultSpeedValue(0);
platform_rz.setDefaultLocked(true)
% Add the PlatformToGround Joint to the Model
osimModel.addJoint(platformToGround);

% Body: Rear Wheel
% ================
rearWheel = Body();
rearWheel.setName('RearWheel');
rearWheel.setMass(1);
rearWheel.setInertia( Inertia(1,1,1,0.11,0,0) );
% Add geometry for display
rearWheelGeometry = Cylinder(S.wheelRadius,S.wheelWidth/2);
rearWheelGeometry.setColor( Vec3(0.1) );
rearWheel.attachGeometry(rearWheelGeometry);
% Add Body to the Model
osimModel.addBody(rearWheel);

% Joint: Rear Wheel {Free} Platform 
% =================================
rearWheelToPlatform = FreeJoint('rearWheelToPlatform',...
    platform,... % Parent Frame
    Vec3(0,S.platformHeight,0),... % Translation in Parent Frame
    Vec3(pi/2,0,0),... % Orientation in Parent Frame
    rearWheel,... % Child Frame
    Vec3(0,0,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% RotationX
rearWheel_rx = rearWheelToPlatform.upd_coordinates(0); 
rearWheel_rx.setName('rearWheel_rx');
rearWheel_rx.setDefaultValue(0);
rearWheel_rx.set_locked(1);
% RotationY
rearWheel_ry = rearWheelToPlatform.upd_coordinates(1); 
rearWheel_ry.setName('rearWheel_ry');
rearWheel_ry.setRange([-pi,pi]);
rearWheel_ry.setDefaultValue(0);
% RotationZ
rearWheel_rz = rearWheelToPlatform.upd_coordinates(2); 
rearWheel_rz.setName('rearWheel_rz');
rearWheel_rz.setDefaultValue(0);
rearWheel_rz.set_locked(1);
% TranslationX 
rearWheel_tx = rearWheelToPlatform.upd_coordinates(3); 
rearWheel_tx.setRange([0, 50]);
rearWheel_tx.setName('rearWheel_tx');
rearWheel_tx.setDefaultValue(0);
rearWheel_tx.setDefaultSpeedValue(0)
% TranslationY
rearWheel_ty = rearWheelToPlatform.upd_coordinates(4); 
rearWheel_ty.setName('rearWheel_ty');
rearWheel_ty.setDefaultValue(0);
rearWheel_ty.set_locked(1);
% TranslationZ
rearWheel_tz = rearWheelToPlatform.upd_coordinates(5);
rearWheel_tz.setRange([-5, 5]);
rearWheel_tz.setName('rearWheel_tz');
rearWheel_tz.setDefaultValue(-S.wheelRadius);
% Add Joint to model
osimModel.addJoint(rearWheelToPlatform)

% Body: Right Chainstay
% =====================
rightChainstay = Body();
rightChainstay.setName('rightChainstay');
rightChainstay.setMass(0.25);
rightChainstay.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
rightChainstayGeometry = Cylinder(S.tubeRadius,S.chainstayLength/2);
rightChainstayGeometry.setColor( Vec3(1) );
rightChainstay.attachGeometry(rightChainstayGeometry);
% Add Body to the Model
osimModel.addBody(rightChainstay);

% Joint: Right Chainstay {Ball} Rear Wheel 
% =======================================
rightChainstayToRearWheel = BallJoint('rightChainstayToRearWheel',...
    rearWheel,... % Parent Frame
    Vec3(0,S.bbWidth/2,0),... % Translation in Parent Frame
    Vec3(0,0,pi/2),... % Orientation in Parent Frame
    rightChainstay,... % Child Frame
    Vec3(0,S.chainstayLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% RotationX
rightChainstay_rx = rightChainstayToRearWheel.upd_coordinates(0); 
rightChainstay_rx.setName('rightChainstay_rx');
rightChainstay_rx.setRange([-pi,pi]);
rightChainstay_rx.setDefaultValue(0);
% RotationY
rightChainstay_ry = rightChainstayToRearWheel.upd_coordinates(1); 
rightChainstay_ry.setName('rightChainstay_ry');
rightChainstay_ry.setDefaultValue(0);
rightChainstay_ry.set_locked(1);
% RotationZ
rightChainstay_rz = rightChainstayToRearWheel.upd_coordinates(2); 
rightChainstay_rz.setName('rightChainstay_rz');
rightChainstay_rz.setDefaultValue(0);
rightChainstay_rz.set_locked(1);
% Add Joint to model
osimModel.addJoint(rightChainstayToRearWheel)

% Body: Left Chainstay
% ====================
leftChainstay = Body();
leftChainstay.setName('leftChainstay');
leftChainstay.setMass(0.25);
leftChainstay.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
leftChainstayGeometry = Cylinder(S.tubeRadius,S.chainstayLength/2);
leftChainstayGeometry.setColor( Vec3(1) );
leftChainstay.attachGeometry(leftChainstayGeometry);
% Add Body to the Model
osimModel.addBody(leftChainstay);

% Joint: Left Chainstay {Ball} Rear Wheel 
% ======================================
leftChainstayToRearWheel = BallJoint('leftChainstayToRearWheel',...
    rearWheel,... % Parent Frame
    Vec3(0,-S.bbWidth/2,0),... % Translation in Parent Frame
    Vec3(0,0,pi/2),... % Orientation in Parent Frame
    leftChainstay,... % Child Frame
    Vec3(0,S.chainstayLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% RotationX
leftChainstay_rx = leftChainstayToRearWheel.upd_coordinates(0); 
leftChainstay_rx.setName('leftChainstay_rx');
leftChainstay_rx.setRange([-pi,pi]);
leftChainstay_rx.setDefaultValue(0);
% RotationY
leftChainstay_ry = leftChainstayToRearWheel.upd_coordinates(1); 
leftChainstay_ry.setName('leftChainstay_ry');
leftChainstay_ry.setDefaultValue(0);
leftChainstay_ry.set_locked(1);
% RotationZ
leftChainstay_rz = leftChainstayToRearWheel.upd_coordinates(2); 
leftChainstay_rz.setName('leftChainstay_rz');
leftChainstay_rz.setDefaultValue(0);
leftChainstay_rz.set_locked(1);
% Add Joint to model
osimModel.addJoint(leftChainstayToRearWheel)

% Body: Bottom Bracket
% ====================
bottomBracket = Body();
bottomBracket.setName('bottomBracket');
bottomBracket.setMass(0.25);
bottomBracket.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
bottomBracketGeometry = Cylinder(S.bbRadius,S.bbWidth/2);
bottomBracketGeometry.setColor( Vec3(1) );
bottomBracket.attachGeometry(bottomBracketGeometry);
% Add Body to the Model
osimModel.addBody(bottomBracket);

% Joint: Bottom Bracket {Weld} Right Chainstay 
% ============================================
bottomBracketToRightChainstay = WeldJoint('bottomBracketToRightChainstay',...
    rightChainstay,... % Parent Frame
    Vec3(0,-S.chainstayLength/2,0),... % Translation in Parent Frame
    Vec3(0,0,pi/2),... % Orientation in Parent Frame
    bottomBracket,... % Child Frame
    Vec3(0,-S.bbWidth/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(bottomBracketToRightChainstay)

% Joint: Bottom Bracket {Weld} Left Chainstay 
% ===========================================
bottomBracketToLeftChainstay = WeldJoint('bottomBracketToLeftChainstay',...
    leftChainstay,... % Parent Frame
    Vec3(0,-S.chainstayLength/2,0),... % Translation in Parent Frame
    Vec3(0,0,pi/2),... % Orientation in Parent Frame
    bottomBracket,... % Child Frame
    Vec3(0,S.bbWidth/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(bottomBracketToLeftChainstay)

% Body: Seat Tube
% ===============
seatTube = Body();
seatTube.setName('seatTube');
seatTube.setMass(0.25);
seatTube.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
seatTubeGeometry = Cylinder(S.tubeRadius,S.seattubeLength/2);
seatTubeGeometry.setColor( Vec3(1) );
seatTube.attachGeometry(seatTubeGeometry);
% Add Body to the Model
osimModel.addBody(seatTube);

% Joint: Seat Tube {Weld} Bottom Bracket 
% ======================================
seatTubeToBottomBracket = WeldJoint('seatTubeToBottomBracket',...
    bottomBracket,... % Parent Frame
    Vec3(0,0,0),... % Translation in Parent Frame
    Vec3(pi/2,0,0),... % Orientation in Parent Frame
    seatTube,... % Child Frame
    Vec3(0,S.seattubeLength/2,0),... % Translation in Child Frame
    Vec3(0,0,(-pi/2)+S.seattubeAngle) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(seatTubeToBottomBracket)

% Body: Down Tube
% ===============
downTube = Body();
downTube.setName('downTube');
downTube.setMass(0.25);
downTube.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
downTubeGeometry = Cylinder(S.tubeRadius,S.downtubeLength/2);
downTubeGeometry.setColor( Vec3(1) );
downTube.attachGeometry(downTubeGeometry);
% Add Body to the Model
osimModel.addBody(downTube);

% Joint: Down Tube {Weld} Bottom Bracket 
% ======================================
downTubeToBottomBracket = WeldJoint('downTubeToBottomBracket',...
    bottomBracket,... % Parent Frame
    Vec3(0,0,0),... % Translation in Parent Frame
    Vec3(pi/2,0,0),... % Orientation in Parent Frame
    downTube,... % Child Frame
    Vec3(0,S.downtubeLength/2,0),... % Translation in Child Frame
    Vec3(0,0,S.downtubeAngle) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(downTubeToBottomBracket)

% Body: Top Tube
% ==============
topTube = Body();
topTube.setName('topTube');
topTube.setMass(0.25);
topTube.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
topTubeGeometry = Cylinder(S.tubeRadius,S.toptubeLength/2);
topTubeGeometry.setColor( Vec3(1) );
topTube.attachGeometry(topTubeGeometry);
% Add Body to the Model
osimModel.addBody(topTube);

% Joint: Top Tube {Weld} Seat Tube 
% ================================
topTubeToSeatTube = WeldJoint('topTubeToSeatTube',...
    seatTube,... % Parent Frame
    Vec3(0,-S.seattubeLength/2,0),... % Translation in Parent Frame
    Vec3(0,0,-pi+S.seattubeAngle),... % Orientation in Parent Frame
    topTube,... % Child Frame
    Vec3(0,S.toptubeLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(topTubeToSeatTube)

% Body: Head Tube
% ===============
headTube = Body();
headTube.setName('headTube');
headTube.setMass(0.25);
headTube.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
headTubeGeometry = Cylinder(S.bbRadius,S.headtubeLength/2);
headTubeGeometry.setColor( Vec3(1) );
headTube.attachGeometry(headTubeGeometry);
% Add Body to the Model
osimModel.addBody(headTube);

% Joint: Head Tube {Weld} Top Tube 
% ================================
headTubeToTopTube = WeldJoint('headTubeToTopTube',...
    topTube,... % Parent Frame
    Vec3(0,-S.toptubeLength/2,0),... % Translation in Parent Frame
    Vec3(0,0,-S.headtubeAngle),... % Orientation in Parent Frame
    headTube,... % Child Frame
    Vec3(0,S.headtubeLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(headTubeToTopTube)

% Body: Left Seatstay
% ===================
leftSeatstay = Body();
leftSeatstay.setName('leftSeatstay');
leftSeatstay.setMass(0.25);
leftSeatstay.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
leftSeatstayGeometry = Cylinder(S.tubeRadius,S.seatstayLength/2);
leftSeatstayGeometry.setColor( Vec3(1) );
leftSeatstay.attachGeometry(leftSeatstayGeometry);
% Add Body to the Model
osimModel.addBody(leftSeatstay);

% Joint: Left Seatstay {Weld} Left Chainstay 
% ==========================================
leftSeatStayToChainStay = WeldJoint('leftSeatStayToChainStay',...
    leftChainstay,... % Parent Frame
    Vec3(0,S.chainstayLength/2,0),... % Translation in Parent Frame
    Vec3(pi/2,0,0),... % Orientation in Parent Frame
    leftSeatstay,... % Child Frame
    Vec3(0,S.seatstayLength/2,0),... % Translation in Child Frame
    Vec3(pi/4,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(leftSeatStayToChainStay)

% Body: Right Seatstay
% ====================
rightSeatstay = Body();
rightSeatstay.setName('rightSeatstay');
rightSeatstay.setMass(0.25);
rightSeatstay.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
rightSeatstayGeometry = Cylinder(S.tubeRadius,S.seatstayLength/2);
rightSeatstayGeometry.setColor( Vec3(1) );
rightSeatstay.attachGeometry(rightSeatstayGeometry);
% Add Body to the Model
osimModel.addBody(rightSeatstay);

% Joint: Right Seatstay {Weld} Right Chainstay
% ============================================
rightSeatStayToChainStay = WeldJoint('rightSeatStayToChainStay',...
    rightChainstay,... % Parent Frame
    Vec3(0,S.chainstayLength/2,0),... % Translation in Parent Frame
    Vec3(pi/2,0,0),... % Orientation in Parent Frame
    rightSeatstay,... % Child Frame
    Vec3(0,S.seatstayLength/2,0),... % Translation in Child Frame
    Vec3(pi/4,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(rightSeatStayToChainStay)

% Body: Steering Tube
% ===================
steeringTube = Body();
steeringTube.setName('steeringTube');
steeringTube.setMass(0.25);
steeringTube.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
steeringTubeGeometry = Cylinder(S.tubeRadius,S.steeringTubeLength/2);
steeringTubeGeometry.setColor( Vec3(0.1) );
steeringTube.attachGeometry(steeringTubeGeometry);
% Add Body to the Model
osimModel.addBody(steeringTube);

% Joint: Steering Tube {Ball} Head Tube 
% =====================================
steeringTubeToHeadTube = BallJoint('steeringTubeToHeadTube',...
    headTube,... % Parent Frame
    Vec3(0,0,0),... % Translation in Parent Frame
    Vec3(0,0,0),... % Orientation in Parent Frame
    steeringTube,... % Child Frame
    Vec3(0,0,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% RotationX
steeringTube_rx = steeringTubeToHeadTube.upd_coordinates(0); 
steeringTube_rx.setName('steeringTube_rx');
steeringTube_rx.setDefaultValue(0);
steeringTube_rx.set_locked(1);
% RotationY
steeringTube_ry = steeringTubeToHeadTube.upd_coordinates(1); 
steeringTube_ry.setName('steeringTube_ry');
steeringTube_ry.setDefaultValue(0);
steeringTube_ry.setRange([-deg2rad(60),deg2rad(60)]);
% RotationZ
steeringTube_rz = steeringTubeToHeadTube.upd_coordinates(2); 
steeringTube_rz.setName('steeringTube_rz');
steeringTube_rz.setDefaultValue(0);
steeringTube_rz.set_locked(1);
% Add Joint to model
osimModel.addJoint(steeringTubeToHeadTube)

% Body: Stem
% ==========
stem = Body();
stem.setName('stem');
stem.setMass(0.25);
stem.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
stemGeometry = Cylinder(S.tubeRadius,S.stemLength/2);
stemGeometry.setColor( Vec3(0.1) );
stem.attachGeometry(stemGeometry);
% Add Body to the Model
osimModel.addBody(stem);

% Joint: Stem {Weld} Steering Tube 
% ================================
stemToSteeringTube = WeldJoint('stemToSteeringTube',...
    steeringTube,... % Parent Frame
    Vec3(0,S.steeringTubeLength/2,0),... % Translation in Parent Frame
    Vec3(0,0,S.headtubeAngle+S.stemAngle),... % Orientation in Parent Frame
    stem,... % Child Frame
    Vec3(0,S.stemLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(stemToSteeringTube)

% Body: Handlebar
% ===============
handlebar = Body();
handlebar.setName('handlebar');
handlebar.setMass(0.25);
handlebar.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
handlebarGeometry = Cylinder(S.tubeRadius,S.handlebarWidth/2);
handlebarGeometry.setColor( Vec3(0.1) );
handlebar.attachGeometry(handlebarGeometry);
% Add Body to the Model
osimModel.addBody(handlebar);

% Joint: Handlebar {Weld} Stem 
% ============================
handlebarToStem = WeldJoint('handlebarToStem',...
    stem,... % Parent Frame
    Vec3(0,-S.stemLength/2,0),... % Translation in Parent Frame
    Vec3(pi/2,0,0),... % Orientation in Parent Frame
    handlebar,... % Child Frame
    Vec3(0,0,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(handlebarToStem)

% Body: Left Hood
% ===============
leftHood = Body();
leftHood.setName('leftHood');
leftHood.setMass(0.1);
leftHood.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
leftHoodGeometry = Cylinder(S.tubeRadius,S.hoodLength/2);
leftHoodGeometry.setColor( Vec3(0.1) );
leftHood.attachGeometry(leftHoodGeometry);
% Add Body to the Model
osimModel.addBody(leftHood);

% Joint: Left Hood {Weld} Handlebar 
% =================================
leftHoodToHandlebar = WeldJoint('leftHoodToHandlebar',...
    handlebar,... % Parent Frame
    Vec3(0,-S.handlebarWidth/2,0),... % Translation in Parent Frame
    Vec3(pi/2,0,0),... % Orientation in Parent Frame
    leftHood,... % Child Frame
    Vec3(0,-S.hoodLength/2,0),... % Translation in Child Frame
    Vec3(0,0,-S.hoodAngle) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(leftHoodToHandlebar)

% Body: Right Hood
% ================
rightHood = Body();
rightHood.setName('rightHood');
rightHood.setMass(0.1);
rightHood.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
rightHoodGeometry = Cylinder(S.tubeRadius,S.hoodLength/2);
rightHoodGeometry.setColor( Vec3(0.1) );
rightHood.attachGeometry(rightHoodGeometry);
% Add Body to the Model
osimModel.addBody(rightHood);

% Joint: Right Hood {Weld} Handlebar 
% ==================================
rightHoodToHandlebar = WeldJoint('rightHoodToHandlebar',...
    handlebar,... % Parent Frame
    Vec3(0,S.handlebarWidth/2,0),... % Translation in Parent Frame
    Vec3(pi/2,0,0),... % Orientation in Parent Frame
    rightHood,... % Child Frame
    Vec3(0,-S.hoodLength/2,0),... % Translation in Child Frame
    Vec3(0,0,-S.hoodAngle) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(rightHoodToHandlebar)

% Body: Left Drop
% ===============
leftDrop = Body();
leftDrop.setName('leftDrop');
leftDrop.setMass(0.1);
leftDrop.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
leftDropGeometry = Cylinder(S.tubeRadius,S.dropLength/2);
leftDropGeometry.setColor( Vec3(0.1) );
leftDrop.attachGeometry(leftDropGeometry);
% Add Body to the Model
osimModel.addBody(leftDrop);

% Joint: Left Drop {Weld} Left Hood 
% =================================
leftDropToLeftHood = WeldJoint('leftDropToLeftHood',...
    leftHood,... % Parent Frame
    Vec3(0,0,0),... % Translation in Parent Frame
    Vec3(0,0,pi/2),... % Orientation in Parent Frame
    leftDrop,... % Child Frame
    Vec3(0,-S.dropLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(leftDropToLeftHood)

% Body: Left Drop 2
% =================
leftDrop2 = Body();
leftDrop2.setName('leftDrop2');
leftDrop2.setMass(0.1);
leftDrop2.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
leftDrop2Geometry = Cylinder(S.tubeRadius,S.dropLength/2);
leftDrop2Geometry.setColor( Vec3(0.1) );
leftDrop2.attachGeometry(leftDrop2Geometry);
% Add Body to the Model
osimModel.addBody(leftDrop2);

% Joint: Left Drop 2 {Weld} Left Drop 
% ===================================
leftDrop2ToLeftDrop = WeldJoint('leftDrop2ToLeftDrop',...
    leftDrop,... % Parent Frame
    Vec3(0,S.dropLength/2,0),... % Translation in Parent Frame
    Vec3(0,0,deg2rad(60)),... % Orientation in Parent Frame
    leftDrop2,... % Child Frame
    Vec3(0,-S.dropLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(leftDrop2ToLeftDrop)

% Body: Right Drop
% ================
rightDrop = Body();
rightDrop.setName('rightDrop');
rightDrop.setMass(0.1);
rightDrop.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
rightDropGeometry = Cylinder(S.tubeRadius,S.dropLength/2);
rightDropGeometry.setColor( Vec3(0.1) );
rightDrop.attachGeometry(rightDropGeometry);
% Add Body to the Model
osimModel.addBody(rightDrop);

% Joint: Right Drop {Weld} Right Hood 
% ===================================
rightDropToRightHood = WeldJoint('rightDropToRightHood',...
    rightHood,... % Parent Frame
    Vec3(0,0,0),... % Translation in Parent Frame
    Vec3(0,0,pi/2),... % Orientation in Parent Frame
    rightDrop,... % Child Frame
    Vec3(0,-S.dropLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(rightDropToRightHood)

% Body: Right Drop 2
% ==================
rightDrop2 = Body();
rightDrop2.setName('rightDrop2');
rightDrop2.setMass(0.1);
rightDrop2.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
rightDrop2Geometry = Cylinder(S.tubeRadius,S.dropLength/2);
rightDrop2Geometry.setColor( Vec3(0.1) );
rightDrop2.attachGeometry(rightDrop2Geometry);
% Add Body to the Model
osimModel.addBody(rightDrop2);

% Joint: Right Drop 2 {Weld} Right Drop 
% =====================================
rightDrop2ToRightDrop = WeldJoint('rightDrop2ToRightDrop',...
    rightDrop,... % Parent Frame
    Vec3(0,S.dropLength/2,0),... % Translation in Parent Frame
    Vec3(0,0,deg2rad(60)),... % Orientation in Parent Frame
    rightDrop2,... % Child Frame
    Vec3(0,-S.dropLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(rightDrop2ToRightDrop)

% Body: Left Fork
% ===============
leftFork = Body();
leftFork.setName('leftFork');
leftFork.setMass(0.25);
leftFork.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
leftForkGeometry = Cylinder(S.tubeRadius,S.forkLength/2);
leftForkGeometry.setColor( Vec3(1) );
leftFork.attachGeometry(leftForkGeometry);
% Add Body to the Model
osimModel.addBody(leftFork);

% Joint: Left Fork {Weld} Steering Tube 
% =====================================
leftForkToSteeringTube = WeldJoint('leftForkToSteeringTube',...
    steeringTube,... % Parent Frame
    Vec3(0,-S.steeringTubeLength/2,S.bbWidth/2),... % Translation in Parent Frame
    Vec3(0,0,0),... % Orientation in Parent Frame
    leftFork,... % Child Frame
    Vec3(0,S.forkLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(leftForkToSteeringTube)

% Body: Right Fork
% ================
rightFork = Body();
rightFork.setName('rightFork');
rightFork.setMass(0.25);
rightFork.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
rightForkGeometry = Cylinder(S.tubeRadius,S.forkLength/2);
rightForkGeometry.setColor( Vec3(1) );
rightFork.attachGeometry(rightForkGeometry);
% Add Body to the Model
osimModel.addBody(rightFork);

% Joint: Right Fork {Weld} Steering Tube 
% ======================================
rightForkToSteeringTube = WeldJoint('rightForkToSteeringTube',...
    steeringTube,... % Parent Frame
    Vec3(0,-S.steeringTubeLength/2,-S.bbWidth/2),... % Translation in Parent Frame
    Vec3(0,0,0),... % Orientation in Parent Frame
    rightFork,... % Child Frame
    Vec3(0,S.forkLength/2,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(rightForkToSteeringTube)

% Body: Front Wheel
% =================
frontWheel = Body();
frontWheel.setName('frontWheel');
frontWheel.setMass(0.8);
frontWheel.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
steeringTubeGeometry = Cylinder(S.wheelRadius,S.wheelWidth/2);
steeringTubeGeometry.setColor( Vec3(0.1) );
frontWheel.attachGeometry(steeringTubeGeometry);
% Add Body to the Model
osimModel.addBody(frontWheel);

% Joint: Front Wheel {Ball} Left Fork 
% ===================================
frontWheelToLeftFork = BallJoint('frontWheelToLeftFork',...
    leftFork,... % Parent Frame
    Vec3(0,-S.forkLength/2,-S.bbWidth/2),... % Translation in Parent Frame
    Vec3(-pi/2,0,0),... % Orientation in Parent Frame
    frontWheel,... % Child Frame
    Vec3(0,0,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% RotationX
frontWheel_rx = frontWheelToLeftFork.upd_coordinates(0); 
frontWheel_rx.setName('frontWheel_rx');
frontWheel_rx.setDefaultValue(0);
frontWheel_rx.set_locked(1);
% RotationY
frontWheel_ry = frontWheelToLeftFork.upd_coordinates(1); 
frontWheel_ry.setName('frontWheel_ry');
frontWheel_ry.setDefaultValue(0);
frontWheel_ry.setRange([-pi,pi]);
% RotationZ
frontWheel_rz = frontWheelToLeftFork.upd_coordinates(2); 
frontWheel_rz.setName('frontWheel_rz');
frontWheel_rz.setDefaultValue(0);
frontWheel_rz.set_locked(1);
% Add Joint to model
osimModel.addJoint(frontWheelToLeftFork)

% Body: Seatpost
% ==============
seatpost = Body();
seatpost.setName('seatpost');
seatpost.setMass(0.25);
seatpost.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
seatpostGeometry = Cylinder(S.tubeRadius*0.8,S.seatpostLength/2);
seatpostGeometry.setColor( Vec3(0.1) );
seatpost.attachGeometry(seatpostGeometry);
% Add Body to the Model
osimModel.addBody(seatpost);

% Joint: Seatpost {Sliding} Seat Tube 
% ===================================
seatpostToSeatTube = SliderJoint('seatpostToSeatTube',...
    seatTube,... % Parent Frame
    Vec3(0,-S.seattubeLength/2,0),... % Translation in Parent Frame
    Vec3(0,0,pi/2),... % Orientation in Parent Frame
    seatpost,... % Child Frame
    Vec3(0,0,0),... % Translation in Child Frame
    Vec3(0,0,pi/2) ); % Orientation in Child Frame
% TranslationX
seatpost_tx = seatpostToSeatTube.upd_coordinates(0); 
seatpost_tx.setName('seatpost_tx');
seatpost_tx.setRange([-S.seatpostLength,S.seatpostLength]);
seatpost_tx.setDefaultValue(0);
seatpost_tx.set_locked(1);
% Add Joint to model
osimModel.addJoint(seatpostToSeatTube)

% Body: Saddle
% ============
saddle = Body();
saddle.setName('saddle');
saddle.setMass(0.25);
saddle.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
saddleGeometry = Ellipsoid(S.saddleLength/2,S.saddleHeight/2,S.saddleWidth/2);
saddleGeometry.setColor( Vec3(0.1) );
saddle.attachGeometry(saddleGeometry);
% Add Body to the Model
osimModel.addBody(saddle);

% Joint: Saddle {Planar} Seatpost 
% ===============================
saddleToSeatpost = PlanarJoint('saddleToSeatpost',...
    seatpost,... % Parent Frame
    Vec3(0,-S.seatpostLength/2,0),... % Translation in Parent Frame
    Vec3(0,pi,(pi/2)-S.seattubeAngle),... % Orientation in Parent Frame
    saddle,... % Child Frame
    Vec3(0,0,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% RotationZ
saddle_rz = saddleToSeatpost.upd_coordinates(0); 
saddle_rz.setName('saddle_rz');
saddle_rz.setRange([-pi,pi]);
saddle_rz.setDefaultValue(0);
saddle_rz.set_locked(1);
% TranslationX
saddle_tx = saddleToSeatpost.upd_coordinates(1); 
saddle_tx.setName('saddle_tx');
saddle_tx.setRange([-S.seatpostLength,S.seatpostLength]);
saddle_tx.setDefaultValue(0);
saddle_tx.set_locked(1);
% TranslationY
saddle_ty = saddleToSeatpost.upd_coordinates(2); 
saddle_ty.setName('saddle_ty');
saddle_ty.setDefaultValue(0);
saddle_ty.set_locked(1);
% Add Joint to model
osimModel.addJoint(saddleToSeatpost)

% Body: Crank Spindle
% ===================
crankSpindle = Body();
crankSpindle.setName('crankSpindle');
crankSpindle.setMass(0.25);
crankSpindle.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
crankSpindleGeometry = Cylinder(S.tubeRadius,S.spindleWidth/2);
crankSpindleGeometry.setColor( Vec3(0.1) );
crankSpindle.attachGeometry(crankSpindleGeometry);
% Add Body to the Model
osimModel.addBody(crankSpindle);

% Joint: Crank Spindle {Ball} Bottom Bracket 
% ==========================================
crankSpindleToBottomBracket = BallJoint('crankSpindleToBottomBracket',...
    bottomBracket,... % Parent Frame
    Vec3(0,0,0),... % Translation in Parent Frame
    Vec3(0,0,0),... % Orientation in Parent Frame
    crankSpindle,... % Child Frame
    Vec3(0,0,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% RotationX
crankSpindle_rx = crankSpindleToBottomBracket.upd_coordinates(0); 
crankSpindle_rx.setName('crankSpindle_rx');
crankSpindle_rx.setDefaultValue(0);
crankSpindle_rx.set_locked(1);
% RotationY
crankSpindle_ry = crankSpindleToBottomBracket.upd_coordinates(1); 
crankSpindle_ry.setName('crankSpindle_ry');
crankSpindle_ry.setDefaultValue(0);
crankSpindle_ry.setRange([-pi,pi]);
% RotationZ
crankSpindle_rz = crankSpindleToBottomBracket.upd_coordinates(2); 
crankSpindle_rz.setName('crankSpindle_rz');
crankSpindle_rz.setDefaultValue(0);
crankSpindle_rz.set_locked(1);
% Add Joint to model
osimModel.addJoint(crankSpindleToBottomBracket)

% Body: Left Crank
% ================
leftCrank = Body();
leftCrank.setName('leftCrank');
leftCrank.setMass(0.25);
leftCrank.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
leftCrankGeometry = Brick( Vec3(S.crankLength/2,0.015,0.005) );
leftCrankGeometry.setColor( Vec3(0.1) );
leftCrank.attachGeometry(leftCrankGeometry);
% Add Body to the Model
osimModel.addBody(leftCrank);

% Joint: Left Crank {Weld} Crank Spindle 
% ======================================
leftCrankToSpindle = WeldJoint('leftCrankToSpindle',...
    crankSpindle,... % Parent Frame
    Vec3(0,S.spindleWidth/2,0),... % Translation in Parent Frame
    Vec3(pi/2,0,0),... % Orientation in Parent Frame
    leftCrank,... % Child Frame
    Vec3(-S.crankLength/2,0,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(leftCrankToSpindle)

% Body: Left Pedal
% ================
leftPedal = Body();
leftPedal.setName('leftPedal');
leftPedal.setMass(0.25);
leftPedal.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
leftPedalGeometry = Brick( Vec3(S.pedalLength/2,0.005,S.pedalWidth/2) );
leftPedalGeometry.setColor( Vec3(0.1) );
leftPedal.attachGeometry(leftPedalGeometry);
% Add Body to the Model
osimModel.addBody(leftPedal);

% Joint: Left Pedal {Pin} Left Crank
% ==================================
leftPedalToLeftCrank = PinJoint('leftPedalToLeftCrank',...
    leftCrank,... % Parent Frame
    Vec3(S.crankLength/2,0,-0.005),... % Translation in Parent Frame
    Vec3(0,0,0),... % Orientation in Parent Frame
    leftPedal,... % Child Frame
    Vec3(0,0,S.pedalWidth/2),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% RotationZ
leftPedal_rz = leftPedalToLeftCrank.upd_coordinates(0); 
leftPedal_rz.setName('leftPedal_rz');
leftPedal_rz.setRange([-pi,pi]);
leftPedal_rz.setDefaultValue(0);
% Add Joint to model
osimModel.addJoint(leftPedalToLeftCrank)

% Body: Right Crank
% =================
rightCrank = Body();
rightCrank.setName('rightCrank');
rightCrank.setMass(0.25);
rightCrank.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
rightCrankGeometry = Brick( Vec3(S.crankLength/2,0.015,0.005) );
rightCrankGeometry.setColor( Vec3(0.1) );
rightCrank.attachGeometry(rightCrankGeometry);
% Add Body to the Model
osimModel.addBody(rightCrank);

% Joint: Right Crank {Weld} Crank Spindle
% =======================================
rightCrankToSpindle = WeldJoint('rightCrankToSpindle',...
    crankSpindle,... % Parent Frame
    Vec3(0,-S.spindleWidth/2,0),... % Translation in Parent Frame
    Vec3(pi/2,0,0),... % Orientation in Parent Frame
    rightCrank,... % Child Frame
    Vec3(S.crankLength/2,0,0),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% Add Joint to model
osimModel.addJoint(rightCrankToSpindle)

% Body: Right Pedal
% =================
rightPedal = Body();
rightPedal.setName('rightPedal');
rightPedal.setMass(0.25);
rightPedal.setInertia( Inertia(1,1,1,0,0,0) );
% Add geometry to the body
rightPedalGeometry = Brick( Vec3(S.pedalLength/2,0.005,S.pedalWidth/2) );
rightPedalGeometry.setColor( Vec3(0.1) );
rightPedal.attachGeometry(rightPedalGeometry);
% Add Body to the Model
osimModel.addBody(rightPedal);

% Joint: Right Pedal {Pin} Right Crank
% ====================================
rightPedalToRightCrank = PinJoint('rightPedalToRightCrank',...
    rightCrank,... % Parent Frame
    Vec3(-S.crankLength/2,0,0.005),... % Translation in Parent Frame
    Vec3(0,0,0),... % Orientation in Parent Frame
    rightPedal,... % Child Frame
    Vec3(0,0,-S.pedalWidth/2),... % Translation in Child Frame
    Vec3(0,0,0) ); % Orientation in Child Frame
% RotationZ
rightPedal_rz = rightPedalToRightCrank.upd_coordinates(0); 
rightPedal_rz.setName('rightPedal_rz');
rightPedal_rz.setRange([-pi,pi]);
rightPedal_rz.setDefaultValue(0);
% Add Joint to model
osimModel.addJoint(rightPedalToRightCrank)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Construct Contact Geometries %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Contact Geometry: Platform
% ==========================
platformContactSpace = ContactHalfSpace(...
    Vec3(0,0.05,0),... % Contact Location
    Vec3(0,0,-pi/2),... % Contact Orientation
    platform); % Parent Body
platformContactSpace.setName('platformContact');
osimModel.addContactGeometry(platformContactSpace);

% Contact Geometry: Rear Wheel
% ============================
rearWheelContactSphere = ContactSphere();
rearWheelContactSphere.setRadius(S.wheelRadius);
rearWheelContactSphere.setLocation( Vec3(0,0,0) );
rearWheelContactSphere.setFrame(rearWheel)
rearWheelContactSphere.setName('rearWheelContact');
osimModel.addContactGeometry(rearWheelContactSphere);

% Contact Geometry: Front Wheel
% =============================
frontWheelContactSphere = ContactSphere();
frontWheelContactSphere.setRadius(S.wheelRadius);
frontWheelContactSphere.setLocation( Vec3(0,0,0) );
frontWheelContactSphere.setFrame(frontWheel)
frontWheelContactSphere.setName('frontWheelContact');
osimModel.addContactGeometry(frontWheelContactSphere);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add Hunt-Crossley Forces %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set properties
stiffness = 1000000;
dissipation = 2.0;
staticFriction = 0.75;
dynamicFriction = 0.0033;
viscousFriction = 0.47;
transitionVelocity = 0.001;

% Contact Force: Rear Wheel
% =========================
rearWheelHuntCrossley = HuntCrossleyForce();
rearWheelHuntCrossley.setName('rearWheelForce');
rearWheelHuntCrossley.addGeometry('rearWheelContact');
rearWheelHuntCrossley.addGeometry('platformContact');
rearWheelHuntCrossley.setStiffness(stiffness);
rearWheelHuntCrossley.setDissipation(dissipation);
rearWheelHuntCrossley.setStaticFriction(staticFriction);
rearWheelHuntCrossley.setDynamicFriction(dynamicFriction);
rearWheelHuntCrossley.setViscousFriction(viscousFriction);
rearWheelHuntCrossley.setTransitionVelocity(transitionVelocity);
% Add force to model
osimModel.addForce(rearWheelHuntCrossley);

% Contact Force: Front Wheel
% ==========================
frontWheelHuntCrossley = HuntCrossleyForce();
frontWheelHuntCrossley.setName('frontWheelForce');
frontWheelHuntCrossley.addGeometry('frontWheelContact');
frontWheelHuntCrossley.addGeometry('platformContact');
frontWheelHuntCrossley.setStiffness(stiffness);
frontWheelHuntCrossley.setDissipation(dissipation);
frontWheelHuntCrossley.setStaticFriction(staticFriction);
frontWheelHuntCrossley.setDynamicFriction(dynamicFriction);
frontWheelHuntCrossley.setViscousFriction(viscousFriction);
frontWheelHuntCrossley.setTransitionVelocity(transitionVelocity);
% Add force to model
osimModel.addForce(frontWheelHuntCrossley);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize and Save Model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check model for consistency
osimModel.initSystem();
% Save the model to a file
osimModel.print('bicycleModel.osim');
disp('bicycleModel.osim printed!');

end