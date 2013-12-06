tubeNum = 15;

[r,c]=size(data);
od=transpose(realod);

factor=zeros(2,tubeNum);
odfit=zeros(r,tubeNum);

for i=1:tubeNum
    cal=robustfit(data(:,i),od);
    factor(1,i)=cal(1);
    factor(2,i)=cal(2);
    odfit(:,i)=factor(1,i)+factor(2,i)*data(:,i);
end

for i=1:tubeNum
    subplot(5,3,i)
    plot(data(:,i),od,'rs','LineWidth',2,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'MarkerSize',10)
    xlabel('volts','FontSize',8)
    ylabel('OD','FontSize',8)
    %xlim([0 1.2])
    %legend('num2str(factor(2,i))')
    
    hold on
    plot(data(:,i),odfit(:,i),'-r')
    grid on
    text(.6,0.6,['1 Volt = ',num2str(factor(2,i), 2),'  OD'],'FontSize',8);
    
end

listratio=0.001*floor(1000*factor(2,:));
