function Prov = LogicDecision(catalog,J,cycle,constants,CData,Prov,ttotal)
% VERSION 9.28.a
% CASE 40 added.
% Introduced safe guard so that no two drug injections immediately follow
% each other.
%  : included option to start with which drug.

DrugA = 0;
DrugB = 0;
Media = 0;

switch catalog
    %'catalog', provided when LogicDecision is invoked, reprents the choice
    %of the algorithm.
    %The possible choices are :
    %'11','12' -> Basic 1-drug killostat with drug A,B respectively
    %'21' -> 2-drug with patern A.B.
    %'22' -> 2-drug with A.A.B.B.
    %'23' -> 2-drug with A.A.A.B.B.B.
    case 400 %uses PID algorithm
        if CData(J).PID(cycle(J)-1) > 0
            %Injection conditions are met.||CData(J).drugUsed(cycle(J)-1)
            %== 0&& (sum(abs(CData(J).drugUsed(cycle(1):cycle(J)-1))) >=0)
            
            if CData(J).DrugA(cycle(J)-1) < 1*constants.stockA(1,J) %assuming the stock in first bottle is 10
                DrugA = 1;
                DrugB = 0;
                Media = 0;
                
            elseif CData(J).DrugA(cycle(J)-1) >= 1*constants.stockA(1,J)
                DrugA = 0;
                DrugB = 1;
                Media = 0;
            end
        else
            
            %Injection conditions are not met
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
    
    case 401 %uses PID algorithm
        if CData(J).PID(cycle(J)-1) > 0
            %Injection conditions are met.||CData(J).drugUsed(cycle(J)-1)
            %== 0&& (sum(abs(CData(J).drugUsed(cycle(1):cycle(J)-1))) >=0)
                       
                DrugA = 1;
                DrugB = 1;
                Media = 1;
     
        else            
            %Injection conditions are not met
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
    case 402 %uses PID algorithm, runs as a turbidostat if you set the dilution rate very high
        if CData(J).PID(cycle(J)-1) > 0
            %Injection conditions are met.||CData(J).drugUsed(cycle(J)-1)
            %== 0&& (sum(abs(CData(J).drugUsed(cycle(1):cycle(J)-1))) >=0)
            
            DrugA = 0;
            DrugB = 0;
            Media = 1;
            
        else
            %Injection conditions are not met
            DrugA = 0;
            DrugB = 0;
            Media = 0;
        end
    case 10 %%turbidostat no drugs, it will dilute the culture with x% if the OD is >= threshold
        
        if CData(J).boolValue(cycle(J)-1) == 1 %&& CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %Injection conditions are met.
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        else
            %Injection conditions are not met
            DrugA = 0;
            DrugB = 0;
            Media = 0;
        end
    case 100 %%chemostat no drugs, it will dilute the culture with x% at the end of every cycle
        
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %Injection conditions are met.
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        else
            %Injection conditions are not met
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
        
    case 40 %Injection rules : If (log(1+r)>0.40 && OD>thr) OR (log(1+r)>0 && thr>0.25). First two injections must be distinct.
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && (CData(J).gRate(cycle(J)-1) >= 0.40 || CData(J).finalOD(cycle(J)-1) >= 0.25) 
            %Injection conditions are met.||CData(J).drugUsed(cycle(J)-1)
            %== 0&& (sum(abs(CData(J).drugUsed(cycle(1):cycle(J)-1))) >=0)
            
            if CData(J).DrugA < 6
                DrugA = 1;
                DrugB = 0;
                Media = 0;
               
            elseif CData(J).DrugA >= 6
                DrugA = 0;
                DrugB = 1;
                Media = 0;
               
            end
        else
           
            %Injection conditions are not met
            DrugA = 0;
            DrugB = 0;
            Media = 1;
            
        end
        
    case 11 %%Basic one drug killostat with drug A
        
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %Injection conditions are met.
            DrugA = 1;
            DrugB = 0;
            Media = 0;
        else
            %Injection conditions are not met
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
        
    case 12 %%Basic one drug killostat with drug B
        
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %Injection Conditions are met.
            DrugA = 0;
            DrugB = 1;
            Media = 0;
        else
            %Injection Conditions not met.
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
       
    case 21
        
        % A.B       Basic Two Drug algorithm
        
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %The conditions for drug injection have been met.
            lastDrug = sum(CData(J).drugUsed(find(CData(J).drugUsed,1,'last')));
            %Check for the last drug used. Returns '1' if A, '-1' if B, '0' if this is the first injection.
            
            if lastDrug == 1
                DrugA = 0;
                DrugB = 1;
                Media = 0;
            elseif lastDrug == -1
                DrugA = 1;
                DrugB = 0;
                Media = 0;
            elseif lastDrug == 0
                %First Injection
                DrugA = 1;
                DrugB = 0;
                Media = 0;
            end
            
        else
            %The conditions for drug injection have not been met.
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
    case 208
        % A.B       Basic Two Drug algorithm, switch between drugs every 8 hours
        
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %The conditions for drug injection have been met.
            if mod(floor(ttotal/28800),2) == 0
                DrugA = 1;
                DrugB = 0;
                Media = 0;
            elseif mod(floor(ttotal/28800),2) == 1
                DrugA = 0;
                DrugB = 1;
                Media = 0;
            end
            
        else
            %The conditions for drug injection have not been met.
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
        
    case 212
        % A.B       Basic Two Drug algorithm, switch between drugs every 12 hours
        
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %The conditions for drug injection have been met.
            if mod(floor(ttotal/43200),2) == 0
                DrugA = 1;
                DrugB = 0;
                Media = 0;
            elseif mod(floor(ttotal/43200),2) == 1
                DrugA = 0;
                DrugB = 1;
                Media = 0;
            end
            
        else
            %The conditions for drug injection have not been met.
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
        
    case 218
        % A.B       Basic Two Drug algorithm, switch between drugs every 24 hours
        
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %The conditions for drug injection have been met.
            if mod(floor(ttotal/64800),2) == 0
                DrugA = 1;
                DrugB = 0;
                Media = 0;
            elseif mod(floor(ttotal/64800),2) == 1
                DrugA = 0;
                DrugB = 1;
                Media = 0;
            end
            
        else
            %The conditions for drug injection have not been met.
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
        
        
        
    case 224
        % A.B       Basic Two Drug algorithm, switch between drugs every 24 hours
        
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %The conditions for drug injection have been met.
            if mod(floor(ttotal/86400),2) == 0
                DrugA = 1;
                DrugB = 0;
                Media = 0;
            elseif mod(floor(ttotal/86400),2) == 1
                DrugA = 0;
                DrugB = 1;
                Media = 0;
            end
            
        else
            %The conditions for drug injection have not been met.
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
        
        
    case 22
        % A.A.B.B   Basic Two Drug
        
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %Drug injection conditions are met.
            
            lastDrug = sum(CData(J).drugUsed(find(CData(J).drugUsed,1,'last')));
            %Checks for the last drug used. Returns '1' if A, '-1' if B, '0'
            %if this is the first injection.
            
            last2Drugs = abs(sum(CData(J).drugUsed(find(CData(J).drugUsed,2,'last'))));
            %Checks for last pair of drug used. Returns '2' if the same
            %drug, '0' if otherwise or first injection.
            
            if last2Drugs == 2
                %The drug type must be switched.
                if lastDrug == 1
                    DrugA = 0;
                    DrugB = 1;
                    Media = 0;
                elseif lastDrug == -1
                    DrugA = 1;
                    DrugB = 0;
                    Media = 0;
                end
                
            else
                %The drug type must remain the same, or first injection
                if lastDrug == 1
                    DrugA = 1;
                    DrugB = 0;
                    Media = 0;
                elseif lastDrug == -1
                    DrugA = 0;
                    DrugB = 1;
                    Media = 0;
                elseif lastDrug == 0
                    %First injection
                    DrugA = 1;
                    DrugB = 0;
                    Media = 0;
                end
            end
            
        else
            %The conditions for drug injection are not met.
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
        
        
    case 23
        % A.A.A.B.B.B   Basic Two Drug
        
        if CData(J).boolValue(cycle(J)-1) == 1 && CData(J).boolGrowth(cycle(J)-1) == 1 && CData(J).drugUsed(cycle(J)-1) == 0
            %Drug injection conditions are met.
            
            lastDrug = sum(CData(J).drugUsed(find(CData(J).drugUsed,1,'last')));
            %Checks for the last drug used. Returns '1' if A, '-1' if B, '0'
            %if this is the first injection.
            
            last3Drugs = abs(sum(CData(J).drugUsed(find(CData(J).drugUsed,3,'last'))));
            %Checks for last pair of drug used. Returns '3' if the same
            %drug.
            
            if last3Drugs == 3
                %Drug type must be switched
                if lastDrug == 1
                    DrugA = 0;
                    DrugB = 1;
                    Media = 0;
                elseif lastDrug == -1
                    DrugA = 1;
                    DrugB = 0;
                    Media = 0;
                end
                
            else
                if lastDrug == 1
                    DrugA = 1;
                    DrugB = 0;
                    Media = 0;
                elseif lastDrug == -1
                    DrugA = 0;
                    DrugB = 1;
                    Media = 0;
                elseif lastDrug == 0;
                    %First injection
                    DrugA = 1;
                    DrugB = 0;
                    Media = 0;
                end
            end
            
        else
            %Injection conditions not met.
            DrugA = 0;
            DrugB = 0;
            Media = 1;
        end
end

Prov(J).DrugA = DrugA;
Prov(J).DrugB = DrugB;
Prov(J).Media = Media;
Prov(J).Summary = (DrugA*1 + DrugB*(-1));
%Feeds the algorithm results into the struc 'PROV', to which LogicDeciison
%was called to.


end
