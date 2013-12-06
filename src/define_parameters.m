function params = define_parameters(thresholdOD, dilutionTargetRatio, allCalibrationData, mediaTubeAssign, datadest, growthPhaseResolution, piecewise, plotall) 
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
if nargin < 7
    piecewise = 0; 
end
if nargin < 8
    plotall = 0; 
end

% Parameters 
parameters.growthPhaseDuration = growthPhaseResolution; 
parameters.dilutionPhaseResolution = 5; 
parameters.activeCultures = [mediaTubeAssign{:}];
parameters.maxDilutionLength = 72; % min? 
parameters.dataFolder = datadest;

% Detect number of media
num_media = numel(mediaTubeAssign);
disp(sprintf('Detected %i media types', num_media)); 

%initialize calibration for all
parameters.calibration.linear(1:15) = 0; 
parameters.calibration.constant(1:15) = 0; 

% Define calibration for each media 
for m = 1:num_media
    % create fit
    volts = allCalibrationData{m}.data; 
    actual_OD = allCalibrationData{m}.realod;
    calibration_fit = calibration_curve(volts, actual_OD, plotall, piecewise);
    % get which tubes for this media
    tubes = mediaTubeAssign{m}; 
    % store fit data
    parameters.calibration.linear(tubes) = calibration_fit(1,tubes); % slopes 
    parameters.calibration.constant(tubes) = calibration_fit(2,tubes); % intercept
end

% Set dilution threshodl and target
parameters.dilutionThreshold = thresholdOD*ones(1,15); 
no_bug_od = zeros(1,15); 
parameters.dilutionTargets = dilutionTargetRatio*(parameters.dilutionThreshold-no_bug_od) + no_bug_od;

params = parameters; 

end
