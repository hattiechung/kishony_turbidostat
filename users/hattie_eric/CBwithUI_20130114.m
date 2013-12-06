% Experiment Script for 1/14/2013 
% Selection with infA 3N library, whole gene
% ACTUAL RUN 

path('../../src', path); 

clear all; close all; 

% Parameters
thresholdOD = 0.289;  
dilTargetRatio = (3/4); 

MOPSMinimal = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\MOPS_Minimal_2013_01_07.mat');
data1 = MOPSMinimal.data;
realod1 = MOPSMinimal.realod; 

MOPSRich = load('N:\KISHONY LAB\adrian\turbidostat-hattie-eric\MOPS_Rich_2013_01_08.mat');
data2 = MOPSRich.data;
realod2 = MOPSRich.realod; 


% MOPS Minimal = 1:4
% MOPS Rich = 5:9 - skip tube 8

tubes1 = 1:5; % MOPS Minimal
% 1-4: selection bins 1-4
% 5: WT in MOPS Minimal
tubes2 = [6:7 9:11]; % MOPS Rich 
% 6, 7, 9, 10: selection bins 1-4
% 11: WT in MOPS Rich 

datefolder = 'testing';
datadest = ['data' filesep datefolder];

% assert that datadest exists
if exist(datadest, 'dir') ~= 7
    mkdir( 'data/', datefolder );
end

% get parameters
parameters = define_parameters(thresholdOD, dilTargetRatio, data1, realod1, data2, realod2, datadest, tubes1, tubes2); 

% run experiment
ODmeter_radio_UI(parameters);
