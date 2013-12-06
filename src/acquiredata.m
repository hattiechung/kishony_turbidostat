function [sample_data, relative_sample_time, state_change] = acquiredata(ai, params, experimentStartTime, handles)

acquisitionTime = params.growthPhaseDuration; 
calibration = params.calibration; 

sampleRate = get(ai, 'SampleRate');
set(ai, 'SamplesPerTrigger', sampleRate*0.85);
waitTime = 1.5;
acquisitionStartTime = datenum(clock);
state_change = 0; 

%Pre-allocate output matrices
sample_data = zeros(ceil(acquisitionTime)*2, 15);
sample_time = zeros(ceil(acquisitionTime)*2, 1);
relative_sample_time = zeros(ceil(acquisitionTime)*2, 1);

iMeasurement = 1;
while 3600*24*(datenum(clock)-acquisitionStartTime) < acquisitionTime
    % Check UI state 
    drawnow; 
    % (12/19/2012 HC: check only start date for compatibility with
    % turbidostat and ODmeter mode, instead of all 3 radio buttons) 
    sState = get(handles.start, 'Value'); 

    
    if eq(sState, 0) % not in start mode 
        % return last measured OD and time 
        sample_data = sample_data(1:iMeasurement-1, 1:15); 
        relative_sample_time = relative_sample_time(1:iMeasurement-1, 1);
        state_change = 1; 
        return 
    else % in start mode
        start(ai)
        wait(ai, waitTime);
        
        [rawdata,reltime,abstime,events] = getdata(ai);
        
        %Get median of rawdata and apply calibration) 
        sample_data(iMeasurement,1:15) = median(rawdata).*calibration.linear + calibration.constant;

        %Obtain measurement time relative to start of experiment
        relative_sample_time(iMeasurement, 1) = 3600*24*(datenum(abstime)-experimentStartTime);   
        
        %Increment
        iMeasurement = iMeasurement + 1;
    end

sample_data = sample_data(1:iMeasurement-1, 1:15);
relative_sample_time = relative_sample_time(1:iMeasurement-1, 1);


end
