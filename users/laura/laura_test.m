% Laura test 

clear all; close all; 
path('../../src/', path);

% Parameters
thresholdOD = 0.1;  
dilTargetRatio = (2/3); 
growthPhase = 60; %number of seconds between OD measurements

% Claibration Data
SC = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\calibration_SC_F4.mat');
calibData = { SC }; 

% Tube Assignments
tubes1 = 1:2; 
tubes2 = 4:13; 
tubeAssigns = { tubes1 } ; 

% Data Saving
datefolder = 'laura_test';
datadest = ['data' filesep datefolder];
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% Make parameters
parameters = define_parameters(thresholdOD, dilTargetRatio, calibData, tubeAssigns, datadest, growthPhase); 

% Run experiment
turbidostat_UI(parameters); 
