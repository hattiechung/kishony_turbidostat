function [growthPhaseData,state_change] = run_growth_phase_morbidostat(initialization,parameters,handles,growthPhaseData,iPhase)
%
%
%
% Adapted from turbidostatUI.m by Laura Stone 11-Nov-2013

% Unpack initialization variables
ai = initialization.ai;
sampleRate = initialization.sampleRate;
experimentStartTime = initialization.experimentStartTime;

fprintf('Starting growth phase %d.\n', iPhase)

set(ai, 'SamplesPerTrigger', floor(sampleRate*parameters.growthPhaseDuration)); % Not sure what this actually does. LKS

acquisitionTime = parameters.growthPhaseDuration; 
[sample_data, sample_time, state_change, rawdata] = acquiredata_morbidostat(ai, parameters, experimentStartTime, acquisitionTime, handles);  % already checks for UI state change

growthPhaseData(iPhase).sampleOD = sample_data;
growthPhaseData(iPhase).sampleTime = sample_time;
growthPhaseData(iPhase).rawdata = rawdata ;

end