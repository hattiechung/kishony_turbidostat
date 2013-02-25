% Chemostat run for 11/05/2012

clear all; 
close all;

number_of_tubes = 9; 
addLiquidTime = 15; 
waitTime = 60; 
parameters = struct('numTubes', number_of_tubes, ...
                    'addLiquidTime', addLiquidTime, ...
                    'waitTime', waitTime);
                
% call UI 
chemostat_UI(parameters); 