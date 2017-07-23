clear; close all; clc;

%##### STEP 5: RUN FASTICA ROUND 2 #####

% IDs of participants to analyse
%  ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'018';'019';'020';'021';'022';'022';'023';'024';'025';'026';'026';'027';'028';'029';'030'};
ID = {'002';'004';'005';'006';'007';'008';'009';'010';'011'};



pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

eeglab;

for idx = 1:size(ID,1)
            
            
            %Load data
            EEG = pop_loadset('filepath',[pathOut,ID{idx,1},'/'],'filename', [ID{idx,1} '_all_blocks_ds_reject_ICA1_clean.set']);
            
            %Run FastICA (round 1)
            EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
            
            %Save point
            EEG = pop_saveset( EEG, 'filename', [ID{idx,1} '_all_blocks_ds_reject_ICA1_clean_ICA2'], 'filepath', [pathOut ID{idx,1}]);
            
end        