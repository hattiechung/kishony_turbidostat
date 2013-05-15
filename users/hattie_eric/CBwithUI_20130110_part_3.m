% Experiment Script for 1/10/2013 part 3
% Selection with infA 3N library, whole gene
% ACTUAL RUN 

clear all; close all; 

% Parameters
thresholdOD = 0.25;  
dilTargetRatio = (3/4); 

MOPSMinimal = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\MOPS_Minimal_2013_01_07.mat');
data1 = MOPSMinimal.data;
realod1 = MOPSMinimal.realod; 

MOPSRich = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\MOPS_Rich_2013_01_08.mat');
data2 = MOPSRich.data;
realod2 = MOPSRich.realod; 


% MOPS Minimal = 1:4
% MOPS Rich = 5:9 - skip tube 8

tubes1 = 1:4; % MOPS Minimal
tubes2 = [5:7 9]; % MOPS Rich 

datefolder = 'test_20130110_part3';
datadest = ['data' filesep datefolder];

% assert that datadest exists
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% get parameters
parameters = define_parameters(thresholdOD, dilTargetRatio, data1, realod1, data2, realod2, datadest, tubes1, tubes2); 

% run experiment
ODmeter_radio_UI(parameters);
