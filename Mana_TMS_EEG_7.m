clear; close all; clc;

%##### STEP 7: FILTER, INTERPOLATE CHANNELS, SPLIT INTENSITIES, AVERAGE REFERENCE #####

% IDs of participants to analyse
%  ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'018';'019';'020';'021';'022';'022';'023';'024';'025';'026';'026';'027';'028';'029';'030'};
ID = {'001';'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'019';'020';'021'};
pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

if   strcmp (pathOut,'/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Sensory_removed/')|| strcmp (pathOut,'/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Threshold_test/')
    fileName = 'removed_sensory_components.set';  
elseif   strcmp (pathOut,'/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/')
    fileName = 'all_blocks_ds_reject_ICA1_clean_ICA2_clean.set';
elseif strcmp (pathOut,'/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Sensory_removed/Pure_sensory/')|| strcmp (pathOut,'/Volumes/Mana_HD/MANA_TMS_EEG/Analyzed/Threshold_test/Pure_sensory/')
    fileName = 'pure_sensory.set';
end

eeglab;

for         idx = 1:length(ID)
    % Makes a subject folder
    if ~isequal(exist([pathOut,ID{idx,1}], 'dir'),7)
        mkdir(pathOut,ID{idx,1});
    end
    
    %Load data
    if strcmp (pathOut,'/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Sensory_removed/Pure_sensory/')
    EEG = pop_loadset('filepath',['/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Sensory_removed/',ID{idx,1},'/'],'filename', [ID{idx,1},'_', fileName]);
    elseif strcmp (pathOut,'/Volumes/Mana_HD/MANA_TMS_EEG/Analyzed/Threshold_test/Pure_sensory/')
    EEG = pop_loadset('filepath',['/Volumes/Mana_HD/MANA_TMS_EEG/Analyzed/Threshold_test/',ID{idx,1},'/'],'filename', [ID{idx,1},'_', fileName]);
    else
    EEG = pop_loadset('filepath',[pathOut,ID{idx,1},'/'],'filename', [ID{idx,1},'_', fileName]);
    end
    %Interpolate missing channels
    EEG = pop_interp(EEG, EEG.allchan, 'spherical');
    
    %Extract high intensity stimulation (120%rMT)
    EEG1 = pop_selectevent( EEG, 'type',{'high'},'deleteevents','on','deleteepochs','on','invertepochs','off');
    EEG1 = pop_saveset( EEG1, 'filename', [ID{idx,1} '_FINAL_high'],'filepath', [pathOut ID{idx,1}]);
    
    %Reference to average
    EEG1av = pop_reref( EEG1, []);
    EEG1av = pop_saveset( EEG1av, 'filename', [ID{idx,1} '_FINAL_high_avref'],'filepath', [pathOut ID{idx,1}]);
    
    %Extract low intensity stimulation (120%rMT)
    EEG2 = pop_selectevent( EEG, 'type',{'low'},'deleteevents','on','deleteepochs','on','invertepochs','off');
    EEG2 = pop_saveset( EEG2, 'filename', [ID{idx,1} '_FINAL_low'],'filepath', [pathOut ID{idx,1}]);
    
    %Rereference to average
    EEG2av = pop_reref( EEG2, []);
    EEG2av = pop_saveset( EEG2av, 'filename', [ID{idx,1} '_FINAL_low_avref'],'filepath', [pathOut ID{idx,1}]);
    
    
    %Extract control Data
    EEG3 = pop_selectevent( EEG, 'type',{'control'},'deleteevents','on','deleteepochs','on','invertepochs','off');
    EEG3 = pop_saveset( EEG3, 'filename', [ID{idx,1} '_FINAL_control'],'filepath', [pathOut ID{idx,1}]);
    
    %Rereference to average
    EEG3av = pop_reref( EEG3, []);
    EEG3av = pop_saveset( EEG3av, 'filename', [ID{idx,1} '_FINAL_control_avref'],'filepath', [pathOut ID{idx,1}]);
end
