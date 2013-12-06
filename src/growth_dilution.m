function [growthPhaseData, dilutionPhaseData] = growth_dilution(parameters, iPhase, initialization, relayBoxes, growthPhaseData, dilutionPhaseData, handles) 
%%%%%%%%%%
% This contains the main work of growth and dilution phases to maintain
% target OD. 
%%%%%%%%%%
    
% Unpack initialization variables
ai = initialization.ai; 
sampleRate = initialization.sampleRate; 
experimentStartTime = initialization.experimentStartTime; 

% ___ Run Growth Phase ___ 
fprintf('Starting growth phase %d.\n', iPhase)
set(ai, 'SamplesPerTrigger', floor(sampleRate*parameters.growthPhaseDuration));
[sample_data, sample_time, state_change] = acquiredata(ai, parameters, experimentStartTime, handles);  % already checks for UI state change 

growthPhaseData(iPhase).sampleOD = sample_data;
growthPhaseData(iPhase).sampleTime = sample_time;  

% Save present data
save([parameters.dataFolder filesep 'run_data_' datestr(clock,'yyyy_mm_dd_HH') '.mat'], 'growthPhaseData', 'dilutionPhaseData', 'parameters');

% Check if acquiredata detected state change 
if state_change == 1    
    return
end 

% ___ Fit the growth curves ___ 
% calculate average OD
sum_of_all_OD_values = 0; 
all_current_ODs = zeros(parameters.activeCultures, 1); 
for iCulture=parameters.activeCultures
    
    % Fit growth curve
    % calculate growth rate 
    robfit = robustfit(sample_time-sample_time(1), log(sample_data(:,iCulture)));
    growthPhaseData(iPhase).growthRate(iCulture) = robfit(2);
    growthPhaseData(iPhase).startOD(iCulture) = exp(robfit(1));
    
    endOD = exp( robfit(1) + (sample_time(length(sample_time))-sample_time(1))*robfit(2) ); 
    growthPhaseData(iPhase).endOD(iCulture) = endOD;
    
    sum_of_all_OD_values = sum_of_all_OD_values + endOD; 
    all_current_ODs(iCulture) = endOD; 
    
    fprintf('Growth Phase %d, Culture %d : final OD = %f.\n', iPhase, iCulture, endOD)
end

% % calculate avg OD
% average_OD = sum_of_all_OD_values/max(parameters.activeCultures); 

% % If average OD is > 0.15, send text
% if average_OD > 0.15
%     title = num2str(average_OD); 
%     content = all_current_ODs(1); 
%     for i = 2:max(parameters.activeCultures)
%         od = all_current_ODs(i); 
%         content = sprintf('%s, %s', content, num2str(od));
%     end
% %     send_text_from_kishony_turbidostat('19199614423', title, content); 
% end

% ___ DILUTION ___ %

% Choose pumps to activate
[pumpsToActivate, dilutionTargets] = choosepumpstoactivate(growthPhaseData,...
    iPhase,...
    parameters);

fprintf('Activating pumps : \n')
disp(find(pumpsToActivate))

% Switch pumps
pumpStates = switchpumps(pumpsToActivate, relayBoxes);

% Dilution Phase
    set(ai, 'SamplesPerTrigger', floor(sampleRate*parameters.dilutionPhaseResolution));
    iDilution = 0;

    while find(pumpStates(1:45))
        % Check UI state 
        drawnow; 
        pState = get(handles.pause, 'Value'); 
        rState = get(handles.refill, 'Value'); 
        sState = get(handles.start, 'Value'); 
        ui_state = [pState rState sState];
        
        
        % IF BLOCK: checks whether UI state has changed 
        if iDilution > parameters.maxDilutionLength 
            % turn off all pumps
            % switchpumps(zeros(1,48), relayBoxes)  
            return  
        elseif eq(ui_state, [1 0 0]) %pause
            %Save present data
            save([parameters.dataFolder filesep 'run_data_' datestr(clock,'yyyy_mm_dd_HH') '.mat'], 'growthPhaseData', 'dilutionPhaseData', 'parameters'); 
            return
        elseif eq(ui_state, [0 1 0]) %refill 
            %Save present data
            save([parameters.dataFolder filesep 'run_data_' datestr(clock,'yyyy_mm_dd_HH') '.mat'], 'growthPhaseData', 'dilutionPhaseData', 'parameters'); 
            return
        else
            % Do Dilution 
            iDilution = iDilution + 1;

            [sample_data, sample_time, state_change] = acquiredata(ai, parameters.dilutionPhaseResolution, experimentStartTime, parameters.calibration, handles);
            
            % Check if acquiredata detected state change 
            if state_change == 1
                %Save present data
                save([parameters.dataFolder filesep 'run_data_' datestr(clock,'yyyy_mm_dd_HH') '.mat'], 'growthPhaseData', 'dilutionPhaseData', 'parameters');
                return 
            end 

            dilutionPhaseData(iPhase).sampleOD = [dilutionPhaseData(iPhase).sampleOD; sample_data];
            dilutionPhaseData(iPhase).sampleTime = [dilutionPhaseData(iPhase).sampleTime; sample_time];
            dilutionPhaseData(iPhase).pumpStates = [dilutionPhaseData(iPhase).pumpStates; (ones(1,length(sample_time))'*pumpStates)];

            dilution_state = median(sample_data);

            dilutionIsComplete = dilution_state < dilutionTargets;

            for iCulture=parameters.activeCultures
                if dilutionIsComplete(iCulture)           
                    pumpStates((iCulture-1)*3 + (1:3)) = zeros(1,3);
                else
                    fprintf('Dilution step %d. Extending dilution of culture %d. OD = %f\n', iDilution, iCulture, dilution_state(iCulture))
                end
            end

            pumpStates = switchpumps(pumpStates, relayBoxes);
            disp(find(pumpStates))
           
            %Save present data
            save([parameters.dataFolder filesep 'run_data_' datestr(clock,'yyyy_mm_dd_HH') '.mat'], 'growthPhaseData', 'dilutionPhaseData', 'parameters')
        end
    end

    %Stop all input pumps and start output pump
    pumpStates = switchpumps(zeros(1,48), relayBoxes);

    %Save present data
    save([parameters.dataFolder filesep 'run_data_' datestr(clock,'yyyy_mm_dd_HH') '.mat'], 'growthPhaseData', 'dilutionPhaseData', 'parameters')
end