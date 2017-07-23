clear; close all; clc; 
%ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'018';'019';'020';'021';'022';'022';'023';'024';'025';'026';'026';'027';'028';'029';'030'};
ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011'};
%number of channels
nbchan = 62;

% ISIs points
ISIs=[1016 1031 1046 1056 1101 1121 1181 1221];

%create a matrix to store all results of the selected ISIspoints
EEG_high = struct();
EEG_low = struct();
EEG_high_timepoints = zeros(nbchan,length(ISIs),size(ID,1));
EEG_low_timepoints = zeros(nbchan,length(ISIs),size(ID,1));

% create a matrix to store mean TEP values of each ISIs point (from all subjects)to compare with MEPs
 EEG_high_timepoints_allsubjects = zeros(nbchan,length(ISIs));
 EEG_low_timepoints_allsubjects = zeros(nbchan,length(ISIs));

% create a loop to find the analyzed TEP values (mean of multiple trials) of all subjects across all
% conditions/all ISIs/ all channels and store them in a cell
% with one component for each consdition

for idx = 1:size(ID,1);
    filePath = ['/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/',ID{idx,1},'/'];
    fileName = [filePath, ID{idx,1}, '_FINAL_low_avref.set'];
    EEG_high = pop_loadset([filePath, ID{idx,1}, '_FINAL_high_avref.set']);
    EEG_low = pop_loadset([filePath, ID{idx,1}, '_FINAL_low_avref.set']);
    
        for j = 1:nbchan
            EEG_high_meantrials = mean(EEG_high.data(j,:,:),3);
            EEG_low_meantrials = mean(EEG_low.data(j,:,:),3);
            all_high_meantrials(j,idx) = {mean(EEG_high.data(j,:,:),3)};
            all_low_meantrials(j,idx) = {mean(EEG_low.data(j,:,:),3)};
            
                for i = 1:length(ISIs)
                    C = ISIs(i);
                    D1 = EEG_high_meantrials(C);
                    D2 = EEG_low_meantrials(C);
                    EEG_high_timepoints(j,i,idx) = D1; 
                    EEG_low_timepoints(j,i,idx) = D2;
             
             
             % calculate mean values of TEPs for each channel at each
             % ISI/condition across participants
             EEG_high_timepoints_allsubjects(j,i) = mean(EEG_high_timepoints(j,i,:));
             EEG_low_timepoints_allsubjects(j,i) = mean(EEG_low_timepoints(j,i,:));
             
             
        end 
    end
end

save('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/spTEPs.mat');

