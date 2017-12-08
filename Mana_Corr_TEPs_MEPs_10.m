clear all; close all; clc;

%##calculates both spearman and pearson correlations between MEPs evoked by ppTMS with 8 different ISIs and different stimulation conditions (high and low) and TEPs evoked by spTMS with the two level of intensities at the 8 timepoints corresponding to the ppTMS ISIs #####
% also calculates corelation between control and high/low TMS as a control measurement

% find and load analyzed MEP and TEP data in the specific time points
load('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/ppTMS_MEPs.mat');
pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

%RefName = 'Laplac.set'
%RefName = 'Mastref.set'
RefName = 'avref.set'

% Number of channels
if strcmp(RefName, 'mastref.set')
    nbchan = 60
else
    nbchan = 62
end

%Load TEPs
if strcmp(RefName, 'mastref.set')
    load([pathOut 'mastref_TEPs.mat'])
elseif strcmp(RefName, 'laplac.set')
    load([pathOut 'laplac_TEPs.mat'])
elseif strcmp(RefName, 'avref.set')
    load ([pathOut 'avref_TEPs.mat'])
end

% define conditions
cond = {'high';'low'};

% for each channel calculate both spearman and pearson correlations between MEPs and TEPs at each ISI for the  different conditions

for int = 1:length(cond)
    condition = cell2mat(all_timepoints (int));
    MEP = cell2mat(all_MEPs(int));
       
    for j = 1:nbchan
        
        for  isi = 1 :length(ISIs)
            [CorrSpearman{int}(j,isi), PvalSpearman{int}(j,isi)] = corr(condition(j,:,isi)',(MEP(:,isi)),'type','Spearman');
            [CorrPearson{int}(j,isi), PvalPearson{int}(j,isi)] = corr(condition(j,:,isi)',(MEP(:,isi)));
            %for control
            [CorrSpearmanControl{int}(j,isi), PvalSpearmanControl{int}(j,isi)] = corr(condition(j,:,isi)',(MEP(:,isi)),'type','Spearman');
            [CorrSpearmanControl{int}(j,isi), PvalPearsonControl{int}(j,isi)] = corr(condition(j,:,isi)',(MEP(:,isi)));
        end
        
    end
end

%Save
if strcmp(RefName, 'mastref.set')
    save ([pathOut, 'mastref_Correlations_MEPs_TEPs']);   
elseif strcmp(RefName, 'laplac.set')
    save([pathOut 'laplac_Correlations_MEPs_TEPs']);
elseif strcmp(RefName, 'avref.set')
    save ([pathOut, 'avref_Correlations_MEPs_TEPs']);
end

