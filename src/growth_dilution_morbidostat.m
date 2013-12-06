function [growthPhaseData, dilutionPhaseData] = growth_dilution_morbidostat(parameters, iPhase, initialization, relayBoxes, growthPhaseData, dilutionPhaseData, handles)
%%%%%%%%%%
% This contains the main work of growth and dilution phases to maintain
% target growth rate.
%
%
%
% Adapted from growth_dilution by Laura Stone 02-Nov-2013
%%%%%%%%%%

% % Unpack initialization variables
% ai = initialization.ai;
% sampleRate = initialization.sampleRate;
% experimentStartTime = initialization.experimentStartTime;

% ___ Run Growth Phase ___
[growthPhaseData] = run_growth_phase_morbidostat(initialization,parameters,handles,growthPhaseData,iPhase) ;

% ___ Fit the growth curves ___%
[growthPhaseData,state_change] = calculateOD_morbidostat(growthPhaseData, iPhase) ;

% Save present data
save([parameters.dataFolder filesep 'run_data_' datestr(clock,'yyyy_mm_dd_HH') '.mat'], 'growthPhaseData', 'dilutionPhaseData', 'parameters');

% Check if there was a UI state change during the growth phase.
if state_change == 1
    return
end

% Choose pumps to activate
[pumpsToActivate, giveDrug, giveDrugB] = choosepumpstoactivate_morbidostat(growthPhaseData, iPhase, parameters); % LKS
growthPhaseData(iPhase).giveDrug = giveDrug ; % LKS
growthPhaseData(iPhase).giveDrugB = giveDrugB ; % LKS
dilutionPhaseData(iPhase).pumpStates = pumpsToActivate ;

fprintf('Activating pumps : \n')
disp(find(pumpsToActivate))

% Switch media and drug pumps on
pumpStates = switchpumps(pumpsToActivate, relayBoxes);

% Dilution Phase
[dilutionPhaseData] = run_dilution_phase_morbidostat(initialization,parameters,handles,dilutionPhaseData,iPhase);

%Stop all input pumps and start output pump
pumpStates = switchpumps(zeros(1,48), relayBoxes);

%Save present data
save([parameters.dataFolder filesep 'run_data_' datestr(clock,'yyyy_mm_dd_HH') '.mat'], 'growthPhaseData', 'dilutionPhaseData', 'parameters')

end