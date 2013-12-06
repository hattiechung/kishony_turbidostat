%version 4.11.a
function Feed = DataAnalysis(t,time,tcycle,cycle,i,dumpdata,dilfactor,dilthr,thr,Feed)
% CHANGE LOG ------------------------------
%28 Sept - LINEAR FIT CHANGE : Now applied to linearized expononentials.
%growth(1) is log(1+r)
%11th April - Added in "dilution threshold" if-loop
%7th April - Went back to polyfit
% 1st April - Added nlinfit instead of polyfit
% -----------------------------------------

%DataAnalysis if provided with results 't','cycle','dumpdata', experimental
%settings 'dilfactor','w','threshold' and a specified tube to analyse.
%Returns a struct with fields :
% finalOD : the final concentration during the cycle, as calculated by the
% data fit of the ODs during the cycle
% targetOD : the OD to be reacheFinale tube during the cycle
%coeff0 = [0.003 dumpdata(t-tcycle(i)+1,i)];
%i is the culture ID (1:8)

growth = polyfit((dumpdata(t+30-tcycle(i)+1:t,16)-dumpdata(t+30-tcycle(i)+1,16))/3600,log(abs(dumpdata(t+30-tcycle(i)+1:t,i))),1);%%we fit a line to estimate the growth rate, remember it is not accurate since the fit is linear.

loglastOD = growth(1)*(dumpdata(t,16)-dumpdata(t-tcycle(i)+1,16))/3600 + growth(2);%%calculates the final OD at the end of cycle using the fit values
lastOD = exp(loglastOD);
if lastOD < dilthr(1,i)
	targetOD = lastOD;
	%if the OD is under the dilution threshold, the dilution target is set to the ending target, so that there is no dilution that can happen under the dilution threshold.
elseif lastOD >= dilthr(1,i)
	%OD is higher the dilthr, then dilution happens according the specified dilution factor.
	targetOD = dilfactor(1,i)*lastOD;
end

Feed(i).endTime(cycle(i)) = time;%returns the value for the end of the cycle
Feed(i).finalOD(cycle(i)) = lastOD;%%returns the value for the finalOD
Feed(i).targetOD(cycle(i)+1) = 0.15;%%returns the value for the targetOD
Feed(i).gRate(cycle(i)) = growth(1);%%returns the value for the growth rate, log(1+r) is given (28th sept 09)
Feed(i).gCons(cycle(i))  = growth(2);%%%returns the value for the constant term, this is not used anywhere
%three comparative boolean values are returned after the cycle values are
%computed.

% boolValue : returns '1' if the final OD in the cycle was above the
% specified OD threshold for drug injection
% boolGrowth : returns '1' if there was net growth in the last cycle
% boolDGrowth : returns '1' if was the growth rate increased with regards to
% the previous cycle


if Feed(i).finalOD(cycle(i)) >= thr(i)
    Feed(i).boolValue(cycle(i)) = 1;
elseif Feed(i).finalOD(cycle(i)) < thr(i)
    Feed(i).boolValue(cycle(i)) = 0;
end

if Feed(i).gRate(cycle(i)) > 0
    Feed(i).boolGrowth(cycle(i)) = 1;
elseif Feed(i).gRate(cycle(i)) <= 0 
    Feed(i).boolGrowth(cycle(i)) = 0;    
end

if cycle(i) ~= 1
    if Feed(i).gRate(cycle(i)) > Feed(i).gRate(cycle(i)-1)
        Feed(i).boolDGrowth(cycle(i)) = 1;
    elseif Feed(i).gRate(cycle(i)) <= Feed(i).gRate(cycle(i)-1)
        Feed(i).boolDGrowth(cycle(i)) = 0;
    end
elseif cycle(i) == 1
    Feed(i).boolDGrowth(cycle(i)) = 0;
end

end