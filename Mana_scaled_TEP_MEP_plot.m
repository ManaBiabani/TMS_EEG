clear; close all; clc; 

% where analyzed (EMG/EEG) data is stored
cd '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed'
load('spTEPs.mat');
load('ppTMS_MEPs.mat');
load('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/fitting/scaled_allsubjects');


% Match data points to take just the time points from EMG for EEG
for j = 1:numofchannels
    sh = scaled_EEG_signal_high_allsubjects(j,:);
    sl = scaled_EEG_signal_low_allsubjects(j,:);
    
        for i = 1:length(ISIs)
            C = ISIs(i);
            D1 = sh(C);
            D2 = sl(C);
            scaled_EEG_timepoints_high_allsubjects (j,i) = D1;
            scaled_EEG_timepoints_low_allsubjects (j,i) = D2;
        end
end


% plot scaled TEPs vs MEPs for allsubjects for each channel and each
% condition and save the plots 

for j = 1:numofchannels
    
    h = figure;
    plot(scaled_EEG_timepoints_high_allsubjects(j,:),'r');hold on,
    plot(MEP_vector_high_allsubjects,'b');hold on,
    title (['scaled high channel', (num2str(j))]);hold on,
    set(gca,'Xtick', [1 2 3 4 5 6 7 8], 'XTickLabel',[15 30 45 55 100 120 180 220]); hold on,
    xlabel('Time');
    ylabel('Amplitude');
    legend ('TEP', 'MEP');
    saveas (h,fullfile('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/fitting/plots',['scaled_high_channel_' (num2str(j))]));
    
    l = figure;
    plot(scaled_EEG_timepoints_low_allsubjects(j,:),'r');hold on,
    plot(MEP_vector_low_allsubjects,'b');hold on,
    title (['scaled low channel', (num2str(j))]);hold on,
    set(gca,'Xtick', [1 2 3 4 5 6 7 8], 'XTickLabel',[15 30 45 55 100 120 180 220]); hold on,
    xlabel('Time');hold on,
    ylabel('Amplitude');
    legend ('TEP', 'MEP');
    saveas (l,fullfile('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/fitting/plots',['scaled_low_channel_' (num2str(j))])); 
    
end
    
 
