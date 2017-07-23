clear; close all; clc; 

%###### Correlations between MEPs evoked by ppTMS with 8 different ISIs and suprathreshold (high) and subthreshold (low) conditioning stimulus intensities 
% and TEPs evoked by spTMS with the two level of intensities at the 8 timepoints corresponding to the ppTMS ISIs #####

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

% calculate the correlations between MEPs and TEPs at each ISI for the different conditions and channels 
for chanNum = 1:numofchannels
    
    for int = 1:length(cond)
            for  isi = 1:length(ISIs)
             correlation_results_allchannels(chanNum,isi,int) = (corr(squeeze(all_TEPs{int}(chanNum,isi,:)),all_MEPs{int}(isi,:)'));          
            end
    end
end
save ('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Correlations_MEPs_TEPs_allchannels')


% make the scatter plot of r values for all channel (for each channel put all plots of different ISIs for each conditioin in one figure) and save the plots

for chanNum = 5
    for int = 1:length(cond)
        f(chanNum) = figure;
            for  isi = 1:length(ISIs)
            subplot(2,4,isi);
            scatter(all_TEPs{int}(chanNum,isi,:),all_MEPs{int}(isi,:)'); hold on,
            xlabel('TEPs');
            ylabel('MEPs');
            title(ISIs(isi));
            savefig(f(chanNum),['Correlations_MEPs_TEPs_' cond{int} '_channel' num2str(chanNum)]);
            end
            
     % for each channel make the scatter plot of R values of all ISIs for different conditions with a reference line
     % at zero and save the plots      
     h(chanNum) = figure;
     scatter(ISIs,correlation_results_allchannels(chanNum,:,int));hold on,
     refLine=refline([0 0]);hold on,
     refLine.Color = 'r'
     xlabel('Time(ms)');
     ylabel('TEPs-MEPs correlation');
     savefig(h(chanNum),['refLine_Correlations_MEPs_TEPs_' (cond{int}) '_channel' num2str(chanNum)]);
    end

end
save ('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Correlations_MEPs_TEPs_allchannels');