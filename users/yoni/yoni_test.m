% Yoni test run 2013/02/25
path('../../src', path); 

clear all; close all; 

% Parameters
thresholdOD = 0.13;  
dilTargetRatio = 0.07/0.13;

% Calibration Data 
SC = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\calibration_SC_F5_May_2013_full_low.mat');
allCalibration = {SC}; 

% OD measurement resolution
gr = 60; % seconds; also determines maxDilutionLength under 'define_parameters.m' 

% Tube Assignments 
tubeAssignments = {[1:2 4:14]}; % SC Check for 15 (the cable is loose; check for 3 the pump is broken/fired)

% Data Saving 
datefolder = '7JUN2013';
datadest = ['data' filesep datefolder];
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% get parameters
parameters = define_parameters(thresholdOD, dilTargetRatio, allCalibration, tubeAssignments, datadest, gr); 

% run experiment
turbidostat_UI(parameters); 
