% Yoni test run 2013/02/25

clear all; close all; 

% Parameters
thresholdOD = 1;  
dilTargetRatio = (1/2); 

SC = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\calibration_SC_F4.mat');
data1 = SC.data;
realod1 = SC.realod; 
data2 = SC.data;
realod2 = SC.realod; 


tubes1 = [1:2 4:13]; % SC Check for 15 (the cable is loose; check for 3 the pump is broken/fired)
tubes2 = []; % no 2nd media

datefolder = 'yoni_20130506';
datadest = ['data' filesep datefolder];

% assert that datadest exists
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% get parameters
parameters = define_parameters(thresholdOD, dilTargetRatio, data1, realod1, data2, realod2, datadest, tubes1, tubes2); 

% run experiment
turbidostat_UI(parameters); 