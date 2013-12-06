function Fig = FigCreate(Names,SecType,tmp_0,Fig)
%VERSION 10.23
% Names is a vector, SecType picks the name for the secondary graph/
% Creates 'main' and 'sec' plots for each culture. 
%'main' plots OD vs time, 'sec' plots [drug] vs time.

for j=1:5
    Fig.Main{j} = subplot(6,5,j);%%row 1 is culture 1,2,3,4 OD vs time
     Fig.Sec{j} = subplot(6,5,5+j);%%row 2 is culture 1,2,3,4 [drug] vs time
end
for j=6:10
    Fig.Main{j} = subplot(6,5,5+j);%%row 1 is culture 1,2,3,4 OD vs time
     Fig.Sec{j} = subplot(6,5,10+j);%%row 2 is culture 1,2,3,4 [drug] vs time
end
for j=11:15
    Fig.Main{j} = subplot(6,5,10+j);%%row 1 is culture 1,2,3,4 OD vs time
     Fig.Sec{j} = subplot(6,5,15+j);%%row 2 is culture 1,2,3,4 [drug] vs time
end

% Adds in labels and initial data points
for j=1:15
    plot(Fig.Main{j},0,tmp_0(1,j));
    ylabel(Fig.Main{j},['culture ',num2str(j),' (OD)']);
    xlabel(Fig.Main{j},'time (hours)');
    grid(Fig.Main{j},'on');
    
    yl = Names{SecType(j)};
    xl = 'time (hours)';

    plot(Fig.Sec{j},0,0);
    ylabel(Fig.Sec{j},yl);
    xlabel(Fig.Sec{j},xl);
    grid(Fig.Sec{j},'on');

end

end

