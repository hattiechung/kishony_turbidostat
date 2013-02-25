% Experiment Script for 1/4/2013
% Testing #2 with M9 media + LB

clear all; close all; 

% Parameters
thresholdOD = 0.3;  
dilTargetRatio = (3/4); 

% M9 = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\dataandod_20121219_calibration_M9.mat');
MOPSMinimal = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\MOPS_Minimal_2013_01_07.mat');
data1 = MOPSMinimal.data;
realod1 = MOPSMinimal.realod; 

LBLennox = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\calibration_data_LBLennox_2012_12_14.mat');
data2 = LBLennox.data;
realod2 = LBLennox.realod; 


% M9 (new) = 1:2
% M9 (new) @ pH 7.25 = 3:4
% M9 (old) = 5:6
% MOPS Minimal = 7:8
% MOPS Rich = 9:10
% LB Lennox = 11:12
tubes1 = [1:10, 13:15]; % M9 
tubes2 = 11:12; % LB Lennox

% Note: left M9 (2), M9 + 2x glucose (4), and M9 + 10x biotin (EtOH) (8),
% in pos 13, 14, 15

datefolder = 'eric-hattie-trial_20130104';
datadest = ['data' filesep datefolder];

% assert that datadest exists
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% get parameters
parameters = define_parameters(thresholdOD, dilTargetRatio, data1, realod1, data2, realod2, datadest, tubes1, tubes2); 

% run experiment
ODmeter_radio_UI(parameters);
