clear; close all; clc;

% ###### STEP 8 : Call analyzed MEPs from the specified excel file and range#####

pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

% Define ISIs
ISIs = [15,30,45,55,100,120,180,220];

% Define path where the file is stored
addpath('/Volumes/BACKUP_HD/MANA_TMS_EEG');

% Specify worksheet and range
MEPs_low = xlsread('MEP_analysis','MAT', 'B2:I21');
MEPs_high = xlsread('MEP_analysis','MAT', 'L2:S21');

%store all MEPs in one cell
all_MEPs = { MEPs_high ; MEPs_low};

%save 
save([pathOut 'ppTMS_MEPs.mat']);