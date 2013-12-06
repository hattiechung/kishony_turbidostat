% Experiment Script for GC3 peaks 

clear all; close all; 

% Parameters
thresholdOD = 0.285;  
dilTargetRatio = (3/4); 
growthPhase = 30; 

% Calibration Data
MOPSMinimal = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\MOPS_Minimal_2013_01_07.mat');
allCalibration = { MOPSMinimal }; 

% Tube Assignments 
tubes1 = 1:5; % MOPS Minimal: 
% 1) P1
% 2) T
% 3) P2
% 4) PP
% 5) 3N
tubeAssignments = { tubes1 }; 

% Data Saving 
datefolder = 'GC3_selection_20131020';
datadest = ['data' filesep datefolder];
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% Make parameters
parameters = define_parameters( thresholdOD, dilTargetRatio, allCalibration, tubeAssignments, datadest, growthPhase); 

% run experiment
ODmeter_radio_UI(parameters);
