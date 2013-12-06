% Version 8.31.a
% DilFactor is now dynamically taken from the ratio of "targetOD" and "finalOD" of the precedent cycle, it is thus directly controlled by DataAnalysis

function CData = UpdConc(J,cycle,constants,dilfactor,Logic,CData)


dil = dilfactor(J);

% if cycle(J) == 1
%     CData(J).drugA(cycle(J)) = Logic(J).DrugA*constants.stockA*(1 - dil);
%     CData(J).drugB(cycle(J)) = Logic(J).DrugB*constants.stockB*(1 - dil);
% else
    CData(J).DrugA(cycle(J)) = CData(J).DrugA(cycle(J)-1)*dil + Logic(J).DrugA*constants.stockA(1,J)*(1 - dil) + Logic(J).DrugB*constants.stockB(1,J)*(1 - dil);
    CData(J).DrugB(cycle(J)) = CData(J).DrugB(cycle(J)-1)*dil + Logic(J).DrugA*constants.stockA(2,J)*(1 - dil) + Logic(J).DrugB*constants.stockB(2,J)*(1 - dil); %Comment out to go back to 4.11.a
    
%     CData(J).DrugB(cycle(J)) = CData(J).DrugB(cycle(J)-1)*dil +Logic(J).DrugB*constants.stockB(2,i)*(1 - dil); 
%     CData(J).DrugB(cycle(J)) = CData(J).DrugB(cycle(J)-1)*dil +Logic(J).DrugB*constants.stockB(2,i)*(1 - dil); 
% end
