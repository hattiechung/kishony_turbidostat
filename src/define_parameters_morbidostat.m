function params = define_parameters_morbidostat(thresholdOD, dilutionTargetRatio, allCalibrationData, mediaTubeAssign, datadest, assignPumps, growthPhaseDuration, dilutionPhaseDuration, piecewise, plotall) 
% ______________________________________________________________
% written by HC, modified 05/15/2013
% Outputs parameters package 
% threshold OD = dilution threshold OD
% allCalibrationData = cell(struct), each struct is loaded calibration data
% mediaTubeAssign = cell(array), each array = tube numbers for each media type 
% datadest = data destination, string containing the path where data will
% be saved
% assignPumps = 1x3 structure containing .media, .drugA, and .drugB with
% values 1-3
%
% may also want addLiquidTime, waitTime
%
% adapted from define_parameters by Laura Stone 07-Nov-2013
% ______________________________________________________________

if nargin < 6
    assignPumps.media = 1 ;
    assignPumps.drugA = 2 ;
    assignPumps.drugB = 3 ;
end
% Default growth phase resolution is 10 min 
if nargin < 7
    growthPhaseDuration = 60*10;
end
if nargin < 8
    dilutionPhaseDuration = 5; %%%% change?
end
if nargin < 9
    piecewise = 0; 
end
if nargin < 10
    plotall = 0; 
end

% Parameters 
parameters.thresholdOD = thresholdOD ;
parameters.growthPhaseDuration = growthPhaseDuration; 
parameters.activeCultures = [mediaTubeAssign{:}];
parameters.assignPumps = assignPumps ;
parameters.dataFolder = datadest;
parameters.dilutionPhaseDuration = dilutionPhaseDuration ;

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

% Set dilution threshold and target
parameters.dilutionThreshold = thresholdOD*ones(1,15); 
no_bug_od = zeros(1,15); 
parameters.dilutionTargets = dilutionTargetRatio*(parameters.dilutionThreshold-no_bug_od) + no_bug_od;

params = parameters; 

end
