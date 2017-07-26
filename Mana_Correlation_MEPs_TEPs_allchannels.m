clear; close all; clc; 

%### Correlations between TEPs and MEPs in different ISIs and stimulus conditions


%find and load analyzed MEP and TEP data in the specific time points
cd '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed'
load('spTEPs.mat');
load('ppTMS_MEPs.mat');

% the number of EEG channels
numofchannels = 62;

% the number of conditions
cond = {'high';'low'};


% correlations_MEPs_TEPs_ISIs=cell(2,62);

% put all MEPs in one cell to be used in the loop
all_MEPs = cell(2,1);
all_MEPs{1} = MEPs_high'; 
all_MEPs{2} = MEPs_low';

% put all TEPs in one cell to be used in the loop
all_TEPs = cell(2,1);
all_TEPs{1} = EEG_high_timepoints;
all_TEPs{2} = EEG_low_timepoints;

% create an empty cell for the final correlation results for all channels
correlation_results_allchannels = zeros(numofchannels,length(ISIs),length(all_MEPs));
Pval = zeros(numofchannels,length(ISIs),length(all_MEPs));

% calculate the correlations between MEPs and TEPs at each ISI for the different conditions and channels 
for chanNum = 1:numofchannels
    
    for int = 1:length(cond)
            for  isi = 1:length(ISIs)
                
                [correlation_results_allchannels(chanNum,isi,int),Pval(chanNum,isi,int)] = (corr(squeeze(all_TEPs{int}(chanNum,isi,:)),all_MEPs{int}(isi,:)')); 
 
            end
    end
end
save ('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Correlations_MEPs_TEPs_allchannels')


