clear; close all; clc; 

%###### Correlations between MEPs evoked by ppTMS with 8 different ISIs and suprathreshold (high) and subthreshold (low) conditioning stimulus intensities 
% and TEPs evoked by spTMS with the two level of intensities at the 8 timepoints corresponding to the ppTMS ISIs #####

% find and load analyzed MEP and TEP data in the specific time points
cd '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed'
load('spTMS_EEG_timepoints.mat');
load('ppTMS_MEPs_ISIs.mat');

% define the EEG channel to be examined
chanNum = 5;
% define conditions
cond = {'high';'low'};

% creat an empty cell for the final correlation results for the selected
% channel
correlation_results_onechannel=zeros(length(cond),length(ISIs));

% put all MEPs in one cell to be used in the loop
all_MEPs = cell(length(cond),1);
all_MEPs{1} = MEPs_high; 
all_MEPs{2} = MEPs_low;

% put all TEPs in one cell to be used in the loop
all_TEPs = cell(length(cond),1);
all_TEPs{1} = squeeze(results_high(chanNum,:,:))';
all_TEPs{2} = squeeze(results_low(chanNum,:,:))';


% calculate the correlations between MEPs and TEPs at each ISI for the different conditions and creat
% the scatter plot for each ISI and save all the plots of each condition in one figure with their specific names
 for  int = 1:length(cond)
      f = figure;
            for  isi = 1:length(ISIs)
            correlation_results_onechannel(int,isi) = corr(all_TEPs{int}(:,isi),all_MEPs{int}(:,isi));
            subplot(2,4,isi);
            scatter(all_TEPs{int}(:,isi),all_MEPs{int}(:,isi)); hold on,
            xlabel('TEPs');
            ylabel('MEPs');
            title(ISIs(isi));
            savefig(f,['Correlations_MEPs_TEPs_' (cond{int}) '_' num2str(chanNum)])
            end
     % make the scatter plot for R values of all ISIs with a reference line
     % at zero and save the plots of different conditions with their
     % specific names
     h = figure;
     scatter(ISIs,correlation_results_onechannel(int,:));hold on,
     refLine = refline([0 0]);hold on,
     refLine.Color = 'r'
     xlabel('Time(ms)');
     ylabel('TEPs-MEPs correlation');
     savefig(h,['refLine_Correlations_MEPs_TEPs_' (cond{int}) '_' num2str(chanNum)])
  
 end
    
save (['/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Correlations_MEPs_TEPs_channel_' num2str(chanNum)]);