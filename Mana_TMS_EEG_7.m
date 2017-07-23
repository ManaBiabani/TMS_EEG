clear; close all; clc;

%##### STEP 7: FILTER, INTERPOLATE CHANNELS, SPLIT INTENSITIES, AVERAGE REFERENCE #####

% IDs of participants to analyse
%  ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'018';'019';'020';'021';'022';'022';'023';'024';'025';'026';'026';'027';'028';'029';'030'};
ID = {'002';'004';'005';'006';'007';'008';'009';'010';'011'};



pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

eeglab;



for idx = 1:size(ID,1)
            
            %Load data
            EEG = pop_loadset('filepath',[pathOut,ID{idx,1},'/'],'filename', [ID{idx,1} '_all_blocks_ds_reject_ICA1_clean_ICA2_clean.set']);

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
end
 