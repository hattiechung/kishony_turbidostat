function growthPhaseData = ODmeter(parameters, iPhase, initialization, relayBoxes, growthPhaseData, handles) 
%%%%%%%%%%
% This contains the main work to measure and record OD. 
%%%%%%%%%%

% Unpack initialization variables
ai = initialization.ai; 
sampleRate = initialization.sampleRate; 
experimentStartTime = initialization.experimentStartTime; 

% ___ Run Growth Phase ___ 
fprintf('Starting OD measuring phase %d.\n', iPhase)
set(ai, 'SamplesPerTrigger', floor(sampleRate*parameters.growthPhaseDuration));
[sample_data, sample_time, state_change] = acquiredata(ai, parameters.growthPhaseDuration, experimentStartTime, parameters.calibration, handles); % already checks for UI state change 

growthPhaseData(iPhase).sampleOD = sample_data;
growthPhaseData(iPhase).sampleTime = sample_time;  

% ___ Fit the growth curves ___ 
% calculate average OD
all_current_ODs = zeros(max(parameters.activeCultures), 1); 

for iCulture=parameters.activeCultures
    % Fit growth curves

    % get OD, logOD of all active cultures
    sample_data(:,iCulture);
    log(sample_data(:,iCulture));
    
    % calculate growth rate 
    robfit = robustfit(sample_time-sample_time(1), log(sample_data(:,iCulture)));
    growthPhaseData(iPhase).growthRate(iCulture) = robfit(2);
    growthPhaseData(iPhase).startOD(iCulture) = exp(robfit(1));
    
    endOD = exp( robfit(1) + (sample_time(length(sample_time))-sample_time(1))*robfit(2) );
    growthPhaseData(iPhase).endOD(iCulture) = endOD;
   
    all_current_ODs(iCulture) = endOD; 
    
    fprintf('OD measuring phase %d, Culture %d : final OD = %f.\n', iPhase, iCulture, endOD)
    
end



% Save present data
save([parameters.dataFolder filesep 'run_data_' datestr(clock,'yyyy_mm_dd_HH') '.mat'], 'growthPhaseData', 'parameters');

% Check if acquiredata detected state change 
if state_change == 1    
    return
end 

% Calculate avg OD

text_threshold_OD = parameters.dilutionThreshold(1); 

first_media_average_OD = mean(all_current_ODs(1:4));
sprintf('Average MOPS Minimal %.3f', first_media_average_OD)

second_media_average_OD = mean(all_current_ODs([6 7 9 10]));
sprintf('Average MOPS Rich %.3f', second_media_average_OD)

% If average OD is > thresold, send text

first_media_condition = first_media_average_OD > text_threshold_OD && first_media_average_OD <= 0.3;
second_media_condition = second_media_average_OD > text_threshold_OD && second_media_average_OD <= 0.3; 
if first_media_condition || second_media_condition
    
    if first_media_condition && second_media_condition
        msgTitle = sprintf('MOPS Min %.2f, MOPS Rich %.2f', first_media_average_OD, second_media_average_OD); 
    elseif first_media_condition
        msgTitle = sprintf('MOPS Minimal %.3f', first_media_average_OD); 
    elseif second_media_condition
        msgTitle = sprintf('MOPS Rich %.3f', second_media_average_OD);
    end
    
    msgContent = all_current_ODs(1); 
    for k = 2:max(parameters.activeCultures)
        od = all_current_ODs(k); 
        msgContent = sprintf('\n %s \n %s', msgContent, num2str(od));
    end
    
    send_text_from_kishony_turbidostat('19199614423', msgTitle, msgContent); 
end

end