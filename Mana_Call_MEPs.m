clear; close all; clc; 

%ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'018';'019';'020';'021';'022';'022';'023';'024';'025';'026';'026';'027';'028';'029';'030'};
ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011'};


% ISIs
ISIs = [15,30,45,55,100,120,180,220];
IDNum = cellfun(@(x)str2double(x), ID);

MEPs_low = zeros(size(ID,1),length(ISIs));
MEPs_high = zeros(size(ID,1),length(ISIs));

% read analyzed MEP data from the specified worksheet and range.
addpath('/Volumes/BACKUP_HD/MANA_TMS_EEG');
MEPs_low = xlsread('MEP_analysis','MAT', 'N12:U21');
MEPs_high = xlsread('MEP_analysis','MAT', 'N24:U33');

save('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/ppTMS_MEPs.mat');
