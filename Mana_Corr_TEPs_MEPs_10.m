clear all; close all; clc;

%##calculates both spearman and pearson correlations between MEPs evoked by ppTMS with 8 different ISIs and different stimulation conditions (high and low) and TEPs evoked by spTMS with the two level of intensities at the 8 timepoints corresponding to the ppTMS ISIs #####
% also calculates corelation between control and high/low TMS as a control measurement

% find and load analyzed MEP and TEP data in the specific time points
load('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/ppTMS_MEPs.mat');
pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

%RefName = 'Laplac';
%RefName = 'Mastref';
RefName = 'avref';

% Number of channels
if strcmp(RefName, 'mastref')
    nbchan = 60;
else
    nbchan = 62;
end

%Load TEPs
load([pathOut, RefName '_TEPs.mat'])

% define conditions
cond = {'high';'low'};

% for each channel calculate both spearman and pearson correlations between MEPs and TEPs at each ISI for the  different conditions
for int = 1:length(cond)
    Condition = cell2mat(all_timepoints (int));
    ControlCondition = cell2mat(all_timepoints (3));
    MEP = cell2mat(all_MEPs(int));
    
    for j = 1:nbchan
        
        for  isi = 1 :length(ISIs)
            [CorrSpearman{int}(j,isi), PvalSpearman{int}(j,isi)] = corr(Condition(j,:,isi)',(MEP(:,isi)),'type','Spearman');
            [CorrPearson{int}(j,isi), PvalPearson{int}(j,isi)] = corr(Condition(j,:,isi)',(MEP(:,isi)));
            %for control
            [CorrSpearmanControl{int}(j,isi), PvalSpearmanControl{int}(j,isi)] = corr(ControlCondition(j,:,isi)',(MEP(:,isi)),'type','Spearman');
            [CorrPearsonControl{int}(j,isi), PvalPearsonControl{int}(j,isi)] = corr(ControlCondition(j,:,isi)',(MEP(:,isi)));
        end
        
    end
end

%Save
save ([pathOut, RefName '_Correlations_MEPs_TEPs']);