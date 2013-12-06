% Experiment Script for GC3 peaks 
path('../../src', path);

clear all; close all; 

% Parameters
thresholdOD = 0.285;  
dilTargetRatio = (3/4); 
growthPhase = 60; 

% Calibration Data
MC4100 = load('N:\KISHONY LAB\_Equipment\Morbidostat\scripts\calibration_data\laura_cut_calibration_LB_MC4100.mat');
MC4100t17 = load('N:\KISHONY LAB\_Equipment\Morbidostat\scripts\calibration_data\laura_raw_calibration_LB_MC4100t17.mat'); 
StaphMedia = load('N:\KISHONY LAB\_Equipment\Morbidostat\scripts\calibration_data\joy_cut_staphAureus_TSB_20131119.mat'); 

allCalibration = { MC4100, MC4100t17, StaphMedia }; 

% Tube Assignments
MC4100_tubes = 4:9; % ATC = 4:6; noATC = 7:9;
MC4100t17_tubes = 10:15; % ATC = 10:12; noATC = 13:15;
StaphMedia_tubes = [1 2]; 
tubeAssignments = { MC4100_tubes, MC4100t17_tubes, StaphMedia_tubes }; 

% Data Saving 
datefolder = '20131122_ODmeter_growthrate';
datadest = ['data' filesep datefolder];
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% Make parameters
parameters = define_parameters( thresholdOD, dilTargetRatio, allCalibration, tubeAssignments, datadest, growthPhase); 

% run experiment
ODmeter_radio_UI(parameters);
