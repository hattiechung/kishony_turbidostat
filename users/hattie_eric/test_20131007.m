% Experiment Script for 10/18/2013 test 
% Selection with infA 6N library, pos 2+3, 3+4

clear all; close all; 

% Parameters
thresholdOD = 0.225;  
dilTargetRatio = (3/4); 
growthPhase = 30; 

% Calibration Data
MOPSMinimal = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\MOPS_Minimal_2013_01_07.mat');
MOPSRich = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\MOPS_Rich_2013_01_08.mat');
allCalibration = { MOPSMinimal, MOPSRich }; 

% Tube Assignments 
tubes1 = 1:6; % MOPS Minimal
tubeAssignments = { tubes1 }; 

% Data Saving 
datefolder = 'testing1';
datadest = ['data' filesep datefolder];
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% Make parameters
parameters = define_parameters( thresholdOD, dilTargetRatio, allCalibration, tubeAssignments, datadest, growthPhase); 

% run experiment
ODmeter_radio_UI(parameters);
