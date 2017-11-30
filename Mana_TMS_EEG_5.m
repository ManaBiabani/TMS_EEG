clear; close all; clc;

%##### STEP 5: Run FASTICA round 2 #####

% IDs of participants to analyse
ID = {'001';'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'019';'020';'021'};

pathOut = '/Volumes/BACKUP_HD/MANA_IHI/Analyzed/';

eeglab;

for idx = 1:length(ID)
    
    %Load data
    EEG = pop_loadset('filepath',[pathOut,ID{idx,1},'/'],'filename', [ID{idx,1} '_all_blocks_ds_reject_ICA1_clean.set']);
    
    % exclude control data
    %EEG = pop_selectevent( EEG, 'type',{'high','low'},'deleteevents','on','deleteepochs','on','invertepochs','off');
    
    %Run FastICA (round 2)
    EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
    
    %Save point
    EEG = pop_saveset( EEG, 'filename', [ID{idx,1} '_all_blocks_ds_reject_ICA1_clean_ICA2'], 'filepath', [pathOut ID{idx,1}]);
    
end