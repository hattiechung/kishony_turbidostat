% Experiment Script for 09/27/2012
% Selection with 3N and 6N in M9 and LB, respectively
% Selection occurring immediately after MAGE Cycle 4

clear all; close all; 

% Parameters
thresholdOD = 0.3;  
dilTargetRatio = (3/4); 

M9 = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\M9_calibration_032612.mat');
data1 = M9.data;
realod1 = M9.realod; 
LBLennox = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\LB_lennox_calibration_032612.mat');
data2 = LBLennox.data;
realod2 = LBLennox.realod; 

tubes1 = 1:5; % M9
tubes2 = 6:10; % LB Lennox
datefolder = 'test';
datadest = ['data' filesep datefolder];

% assert that datadest exists
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end
% assert(exist(datadest, 'dir') == 7, 'You forgot to create the data destination folder!'); 

% get parameters
parameters = define_parameters(thresholdOD, dilTargetRatio, data1, realod1, data2, realod2, datadest, tubes1, tubes2); 

% run experiment
turbidostat_UI(parameters);
