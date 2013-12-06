function output = calibration_curve(data, realod, plotall, piecewise)
    [numpoints numtubes] = size(data); 
    
    if (nargin<3)
        plotall = 0; 
    end
    if (nargin<4)
        piecewise = 0 ; 
    end 
    
    % switch cases for which type of calibration to perform
    switch piecewise
        % piecewise calculation 
        case 1
            num_calibration_points = numel(data); 
            % initialize
            slopes = zeros(num_calibration_points-1, numtubes); 
            intercepts = zeros(num_calibration_points-1, numtubes); 
            % sort data
            [data_sorted, indices] = sort(data,1); 
            realod_sorted = realod(indices(:,1));
            % piecewise calculation
            figure; 
            for t = 1:numtubes
                subplot(3,5,t)
                slopes(:,t) = diff(realod_sorted)'./diff(data_sorted(:,t)); 
                intercepts(:,t) = (realod_sorted(2:end))' - slope(:,t).*data(2:end,t); 
                plot(data_sorted(:,t), realod_sorted, 'b*');
            end
            output = {slopes, intercepts}; 

        % calculate slope and intercept for each tube 
        case 0
            % initialize
            output = zeros(2, numtubes); 
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
end
