% Yoni test run 2013/02/25
path('../../src', path); 

clear all; close all; 

% Parameters
thresholdOD = 0.13;  
dilTargetRatio = 0.07/0.13;

% Calibration Data 
SC = load('calibration_data_LBLennox_2012_12_14.mat');
allCalibration = {SC}; 

% OD measurement resolution
gr = 60; % seconds; also determines maxDilutionLength under 'define_parameters.m' 

% Tube Assignments 
tubeAssignments = {[1:2 4:14]}; % SC Check for 15 (the cable is loose; check for 3 the pump is broken/fired)

% Data Saving 
datefolder = 'test2013';
datadest = ['data' filesep datefolder];
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% get parameters
parameters = define_parameters_chemostat(thresholdOD, dilTargetRatio, allCalibration, tubeAssignments, datadest, gr); 

% run experiment
chemostat_UI(parameters); 
