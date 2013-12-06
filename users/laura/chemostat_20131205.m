% Chemostat test
% flowInTime = 30 sec was too low, trying double that
% using same cultures as 20131205; refilling for 18 min; then starting script

clear all; close all; 

path('N:\KISHONY LAB\_Equipment\Morbidostat\scripts\src', path)

% Rate Control (seconds)
flowInTime = 60; 
% waitTime = 200; 
waitTime = 0 ;

% OD Measuring Resolution (seconds)
% Assert gr <= waitTime 
% gr = 70;  
gr = 12*60 - waitTime ; % seconds

% Calibration Data

% LBLennox = load('calibration_data_LBLennox_2012_12_14.mat');
% allCalibration = {LBLennox}; 
LBmc4100 = load('N:\KISHONY LAB\_Equipment\Morbidostat\scripts\calibration_data\laura_cut_calibration_LB_MC4100.mat') ;
allCalibration = {LBmc4100} ;

% Tube Assignments 
% tubes_media1 = 1:3; 
tubes_media1 = [1:10 12:14] ;
tubeAssignments = { tubes_media1}; 

% Data Saving
% datefolder = 'test';
% datadest = ['data' filesep datefolder];
% if exist(datadest, 'dir') ~= 7
%     mkdir( 'data/', datefolder );
% end
datadest = [pwd filesep 'data' filesep '2013.12.05_dilutionrate'] ;
mkdir(datadest)

% Create Parameters
parameters = define_parameters_chemostat_lks( allCalibration, tubeAssignments, datadest, flowInTime, waitTime, gr);  

% Run Experiment + UI 
disp('running chemostat')
chemostat_UI(parameters);