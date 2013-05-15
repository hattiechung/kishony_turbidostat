% Experiment Script for 012/19/2012
% Selection with 3N infA, whole gene, in M9 and LB
% Selection occurring immediately after MAGE Cycle 4

clear all; close all; 

% Parameters
thresholdOD = 0.3;  
dilTargetRatio = (3/4); 

M9 = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\dataandod_20121219_calibration_M9.mat');
data1 = M9.data;
realod1 = M9.realod; 
LBLennox = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\calibration_data_LBLennox_2012_12_14.mat');
data2 = LBLennox.data;
realod2 = LBLennox.realod; 

tubes1 = 1:4; % M9 
tubes2 = 5:8; % LB Lennox
datefolder = 'eric-hattie-trial_20130103';
datadest = ['data' filesep datefolder];

% assert that datadest exists
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% get parameters
parameters = define_parameters(thresholdOD, dilTargetRatio, data1, realod1, data2, realod2, datadest, tubes1, tubes2); 

% run experiment
ODmeter_radio_UI(parameters);
