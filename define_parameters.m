function params = define_parameters(thresholdOD, dilutionTargetRatio, data1, realod1, data2, realod2, datadest, tubes1, tubes2) 
%%%%%
% Outputs parameters pacakage 
% Modified by Hattie to include input for calibration data 
% threshold OD = dilution threshold OD
% data1, realod1 = calibration data for media type 1
% tubes1 = tube numbers for media type 1. e.g. 1:5 
% data2, realod2 = calibration data for media type 2
% tubes2 = tube numbers for media type 2. e.g. 6:10 
%%%%%

%Parameters 
parameters.growthPhaseDuration = 60; %60*10; 
parameters.dilutionPhaseResolution = 5; 
parameters.activeCultures = [tubes1 tubes2];
parameters.firstMediaTubes = tubes1; 
parameters.secondMediaTubes = tubes2; 
parameters.maxDilutionLength = 72;
parameters.dataFolder = datadest;

%Extract calibration parameters
media1 = calibration_curve(data1, realod1); 
media2 = calibration_curve(data2, realod2); 

%Feed Calibration data
%initialize 
parameters.calibration.linear = ones(1,15);
parameters.calibration.constant = zeros(1,15);
%set for media type 1
parameters.calibration.linear(tubes1) = media1(1,tubes1); % slopes for media 1 tubes
parameters.calibration.constant(tubes1) = media1(2,tubes1); % intercept for media 1 tubes
%set for media type 2
parameters.calibration.linear(tubes2) = media2(1,tubes2); % slopes for media 2 tubes
parameters.calibration.constant(tubes2) = media2(2,tubes2); % intercept for media 2 tubes

%Settings
% parameters.dilutionThreshold = 0.5*[0.4538, 0.2614, 0.3589, 0.4382, 0.3702, 0.4858, 0.4860, 0.1396, 1.3079, 0.3323, 1, 1, 1, 1, 1];
parameters.dilutionThreshold = thresholdOD*ones(1,15); 
% no_bug_od = [0.1256, 0.0679, 0.1039, 0.1309, 0.1132, 0.1482, 0.1158, 0.0459, 0.1047, 0.0882, 0, 0, 0, 0, 0];
no_bug_od = zeros(1,15); 

parameters.dilutionTargets = dilutionTargetRatio*(parameters.dilutionThreshold-no_bug_od) + no_bug_od;

params = parameters; 

end