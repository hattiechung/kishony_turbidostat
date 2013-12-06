function [growthPhaseData] = calculateOD_morbidostat(growthPhaseData, iPhase)
%
% Taken from turbidostatUI.m by Laura Stone 14-Nov-2013

for iCulture=parameters.activeCultures
    
    % Fit growth curve
    % calculate growth rate
    robfit = robustfit(growthPhaseData(iPhase).sampleTime-growthPhaseData(iPhase).sampleTime(1), log(growthPhaseData(iPhase).sampleOD(:,iCulture)));
    growthPhaseData(iPhase).growthRate(iCulture) = robfit(2);
    growthPhaseData(iPhase).startOD(iCulture) = exp(robfit(1));
    
    endOD = exp( robfit(1) + (growthPhaseData(iPhase).sampleTime(length(growthPhaseData(iPhase).sampleTime))-growthPhaseData(iPhase).sampleTime(1))*robfit(2) );
    growthPhaseData(iPhase).endOD(iCulture) = endOD;
    
    fprintf('Growth Phase %d, Culture %d : final OD = %f.\n', iPhase, iCulture, endOD)
    
end

end