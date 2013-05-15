% Experiment Script for 1/3/2013
% Testing M9 media + LB

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


% M9 (new) = 1:2
% M9 + 2x glucose = 3:4
% M9 + 10x biotin (H2O) = 5:6
% M9 + 10x biotin (EtOH) = 7:8
% M9 + 10x thiamine = 9:10
% M9 old = 11:12
% LB Lennox = 13:14
tubes1 = 1:12; % M9 
tubes2 = 13:14; % LB Lennox
% !!! Change hard-coded # subplots in ODmeter_radio_UI.m !!! %

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
