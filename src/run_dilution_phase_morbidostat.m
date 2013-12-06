function [dilutionPhaseData] = run_dilution_phase_morbidostat(initialization,parameters,handles,dilutionPhaseData,iPhase)
%initialization,parameters,handles,growthPhaseData,iPhase)
% dilutionPhaseData(iPhase).dilution = zeros(1,15);   %this does not appear to be used.
%     dilutionPhaseData(iPhase).sampleOD = zeros(0,15);
%     dilutionPhaseData(iPhase).sampleTime = zeros(0,1);
%     dilutionPhaseData(iPhase).pumpStates = zeros(0,48);
%

% Unpack initialization variables
ai = initialization.ai;
sampleRate = initialization.sampleRate;
experimentStartTime = initialization.experimentStartTime;

set(ai, 'SamplesPerTrigger', floor(sampleRate*parameters.dilutionPhaseDuration));

[sample_data, sample_time, state_change, rawdata] = acquiredata_morbidostat(ai, parameters, experimentStartTime, parameters.dilutionPhaseDuration, handles);

dilutionPhaseData(iPhase).sampleOD = [dilutionPhaseData(iPhase).sampleOD; sample_data];
dilutionPhaseData(iPhase).sampleTime = [dilutionPhaseData(iPhase).sampleTime; sample_time];
dilutionPhaseData(iPhase).pumpStates = [dilutionPhaseData(iPhase).pumpStates; (ones(1,length(sample_time))'*pumpStates)];
dilutionPhaseData(iPhase).rawdata = rawdata ;

end