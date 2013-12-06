function params = define_parameters_chemostat_lks(allCalibrationData, mediaTubeAssign, datadest, addLiquidTime, waitTime, growthPhaseResolution) 
% ______________________________________________________________
% written by HC, modified 05/15/2013
% Outputs parameters package 
% threshold OD = dilution threshold OD
% allCalibrationData = cell(struct), each struct is loaded calibration data
% mediaTubeAssign = cell(array), each array = tube numbers for each media type 
% ______________________________________________________________

% Default growth phase resolution is 10 min 
if nargin < 6
    growthPhaseResolution = 60*10;
end

% Parameters 
parameters.growthPhaseDuration = growthPhaseResolution; 
parameters.dilutionPhaseResolution = 5; 
parameters.activeCultures = [mediaTubeAssign{:}];
parameters.maxDilutionLength = 72;
parameters.dataFolder = datadest;
parameters.addLiquidTime = addLiquidTime; 
parameters.waitTime = waitTime; 

% Detect number of media
num_media = numel(mediaTubeAssign); 

% Define calibration for each media 
for m = 1:num_media
    % create fit
    volts = allCalibrationData{m}.data; 
    actual_OD = allCalibrationData{m}.realod;
    calibration_fit = calibration_curve(volts, actual_OD);
    % get which tubes for this media
    tubes = mediaTubeAssign{m}; 
    % initialize even for non-active tubes
    parameters.calibration.linear = ones(1,15); 
    parameters.calibration.constant = zeros(1,15); 
    % store fit data
    parameters.calibration.linear(tubes) = calibration_fit(1,tubes); % slopes 
    parameters.calibration.constant(tubes) = calibration_fit(2,tubes); % intercept
end

%added by LKS
thresholdOD = 0.285;  
dilutionTargetRatio = (3/4); 
parameters.dilutionThreshold = thresholdOD*ones(1,15); 
no_bug_od = zeros(1,15); 
parameters.dilutionTargets = dilutionTargetRatio*(parameters.dilutionThreshold-no_bug_od) + no_bug_od;
%end added by LKS

params = parameters; 

end
