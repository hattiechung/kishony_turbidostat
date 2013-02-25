function [pumpsToActivate, dilutionTargets] = choosepumpstoactivate(growthPhaseData, iPhase, parameters)
    %This specifies the dilution targets
    dilutionTargets = ones(1,15);

    %This preallocates the output
    pumpsToActivate = zeros(1,48);
    pumpsToActivate(48) = 1;
    cultureBeingDiluted = ones(1,15);
    %Check if this was below threshold recently
%     if iPhase < 6
%         cultureBeingDiluted = ones(1,15);
%     else
%         cultureBeingDiluted = zeros(1,15);
%         for jPhase = max(1,iPhase-5):max(iPhase)
%             cultureBeingDiluted = cultureBeingDiluted | growthPhaseData(jPhase).endOD < parameters.dilutionThreshold;
%         end
%     end


    if iPhase > 1
        prevCycleNotFinishedDiluting = find((growthPhaseData(iPhase-1).endOD > parameters.dilutionThreshold) & ...
            (growthPhaseData(iPhase).endOD > parameters.dilutionTargets));
    else % first cycle
        prevCycleNotFinishedDiluting = [];
    end
    
    currentCycleReadyToDilute = find(growthPhaseData(iPhase).endOD > parameters.dilutionThreshold);
    
    for iCulture=intersect(find(cultureBeingDiluted), union(prevCycleNotFinishedDiluting, currentCycleReadyToDilute))
           %This is the first pump corresponding to that culture
           culturePumps = (iCulture-1)*3 + (1:3);

           for iPump = culturePumps       
                %Record that pump must be activated
                pumpsToActivate(iPump) = 1;
           end       
           dilutionTargets(iCulture) = parameters.dilutionTargets(iCulture);  
    end
end