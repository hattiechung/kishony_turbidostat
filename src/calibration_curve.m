function output = calibration_curve(data, realod, plotall)
    [numpoints numtubes] = size(data); 
    
    if (nargin<3)
        plotall = 0; 
    end
    
    % initialize 
    output = zeros(2, numtubes); 
    % calculate slope and intercept for each tube 
    for i = 1:numtubes
        [params resids] = polyfit(data(:,i), realod',1); 
        % record slope
        output(1,i) = params(1); 
        % record intercept 
        output(2,i) = params(2); 
        y = data(:,i)*output(1,i)+output(2,i);
        
        if plotall == 1
            subplot(5,3,i)
            lin_y = [output(2,i), 2*output(1,i)+output(2,i)];
            lin_x = [0, 2]; 
            plot(lin_x, lin_y); 
            hold on
            plot(data(:,i), realod', 'or'); 
            title(i); 
            ylim([0 1]); 
        end
    end
end