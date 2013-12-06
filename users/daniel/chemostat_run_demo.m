% Chemostat test

clear all; close all; 

path('N:\KISHONY LAB\_Equipment\Morbidostat\scripts\src', path)

% Rate Control (seconds)
flowInTime = 30; 
waitTime = 200; 

% OD Measuring Resolution (seconds)
% Assert gr <= waitTime 
gr = 70;  

% Calibration Data
LBLennox = load('calibration_data_LBLennox_2012_12_14.mat');
allCalibration = {LBLennox}; 

% Tube Assignments 
tubes_media1 = 1:3; 
tubes_media2 = []; 
tubeAssignments = { tubes_media1, tubes_media2 }; 

% Data Saving
datefolder = 'test';
datadest = ['data' filesep datefolder];
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% Create Parameters
parameters = define_parameters_chemostat( allCalibration, tubeAssignments, datadest, flowInTime, waitTime, gr);  

% Run Experiment + UI 
chemostat_UI(parameters);

