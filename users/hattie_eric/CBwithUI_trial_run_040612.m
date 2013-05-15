% Experiment Script for 04/23/2012 
% Run with new UI

clear all; close all; 

% Parameters
thresholdOD = 0.2;  

M9 = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\LB_lennox_calibration_032612.mat');
data1 = M9.data;
realod1 = M9.realod; 
LBLennox = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\LB_lennox_calibration_032612.mat');
data2 = LBLennox.data;
realod2 = LBLennox.realod; 

tubes1 = 1:5; % M9
tubes2 = 6:10; % LB Lennox
datadest = ['data' filesep 'eric-hattie-trial_042312'];

% assert that datadest exists
assert(exist(datadest, 'dir') == 7, 'You forgot to create the data destination folder!'); 

% get parameters
parameters = define_parameters(thresholdOD, data1, realod1, data2, realod2, datadest, tubes1, tubes2); 

% run experiment
turbidostat_UI(parameters);
