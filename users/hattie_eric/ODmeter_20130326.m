% Experiment Script for 3/26/2013 
% Selection with infA 6N library, pos 2+3, 3+4

clear all; close all; 

% Parameters
thresholdOD = 0.288;  
dilTargetRatio = (3/4); 

MOPSMinimal = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\MOPS_Minimal_2013_01_07.mat');
data1 = MOPSMinimal.data;
realod1 = MOPSMinimal.realod; 

MOPSRich = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\MOPS_Rich_2013_01_08.mat');
data2 = MOPSRich.data;
realod2 = MOPSRich.realod; 

tubes1 = [1 3]; % MOPS Minimal
tubes2 = [2 4]; % MOPS Rich 

datefolder = 'infA_20130326';
datadest = ['data' filesep datefolder];

% assert that datadest exists
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% get parameters
parameters = define_parameters(thresholdOD, dilTargetRatio, data1, realod1, data2, realod2, datadest, tubes1, tubes2); 

% run experiment
ODmeter_radio_UI(parameters);
