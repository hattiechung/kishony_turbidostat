function [pumpsToActivate, giveDrug, giveDrugB] = choosepumpstoactivate_morbidostat(growthPhaseData, iPhase, parameters)
    % pumpsToActive: is a 1x48 logical matrix. 

    %This preallocates the output
    pumpsToActivate = zeros(1,48);
    
    if iPhase > 1
        giveDrug = intersect(find(growthPhaseData(iPhase).endOD > growthPhaseData(iPhase-1).endOD),...
            find(growthPhaseData(iPhase).endOD > parameters.thresholdOD)) ;
        %Identifies cultures where the growth rate is higher than the dilution
        %rate and the end OD is higher than the threshold OD.
        
        giveDrugB = union(intersect(giveDrug,growthPhaseData(iPhase-1).giveDrug), ...
            intersect(giveDrug,growthPhaseData(iPhase-2).giveDrug)) ;
        %If you have added drug in the last 2 iPhases, then it is time to move
        %to drugB (the high (usually 5x of drugA) concentraton of drug).
        giveDrugB = union(growthPhaseData(iPhase-1).giveDrugB , giveDrugB) ;
        %Adds the new giveDrugB tubes to the running tally of which tubes
        %should be killed with drugB.
        
    else
        giveDrug = [] ;
    end
    
    for iCulture = parameters.activeCultures
        if ismember(iCulture,giveDrug) && ismember(iCulture,giveDrugB)
            pumpsToActivate((iCulture-1)*3 + parameters.assignPumps.drugB) = 1 ;
        elseif ismember(iCulture,giveDrug)
            pumpsToActivate((iCulture-1)*3 + parameters.assignPumps.drugA) = 1 ;
        else
            pumpsToActivate((iCulture-1)*3 + parameters.assignPumps.media) = 1 ;
        end
        % Remember: Culture tube 1 corresponds to pumps 1-3, culture tube 2 corresponds to
        % pumps 4-6, etc.
    end

%     pumpsToActivate = logical(pumpsToActivate) ; %necessary? LKS
    
end