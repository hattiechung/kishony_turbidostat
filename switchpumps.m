function targetPumpStates = switchpumps(targetPumpStates, relayBoxes)

currentPumpStates = [];
for box = {'box1', 'box2'}
    currentPumpStates = [currentPumpStates getvalue(relayBoxes.(box{1}).Line(1:24))];
end
       

for iPump = find(targetPumpStates ~= currentPumpStates)
        
        if iPump<25
            putvalue(relayBoxes.box1.Line(iPump), targetPumpStates(iPump));
        else
            putvalue(relayBoxes.box2.Line(iPump-24), targetPumpStates(iPump));
        end    
end

    
end