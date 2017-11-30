clear; close all; clc;

% ###### STEP 8 : Call analyzed MEPs from the excel file #####

pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

% ISIs
ISIs = [15,30,45,55,100,120,180,220];

% Read analyzed MEPs data from the specified worksheet and range
addpath('/Volumes/BACKUP_HD/MANA_TMS_EEG');
MEPs_low = xlsread('MEP_analysis','MAT', 'B2:I21');
MEPs_high = xlsread('MEP_analysis','MAT', 'L2:S21');
all_MEPs = { MEPs_high ; MEPs_low};
save([pathOut 'ppTMS_MEPs.mat']);