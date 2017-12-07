clear; close all; clc;

ID = {'001';'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'019';'020';'021'};

% ISIs points
ISIs=[1016 1031 1046 1056 1101 1121 1181 1221];

%for IHI
%ISIs=[ 1011 1021 1031 1041 1051 1101 1151 1201];

pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

% create a loop to find the analyzed TEP values (mean of multiple trials) of all subjects across all conditions/all ISIs/ all channels and store them in a cell with one component for each condition

% define the re-referencing method

% RefName = 'laplac'
% RefName = 'mastref'
RefName = 'avref';

% Apply exception for the number of electrodes for refrencing to average mastoids
if strcmp(RefName, 'Mastref')
    nbchan = 60;
else
    nbchan = 62;
end

% Define conditions
condition = {'high';'low'; 'control'};
%for IHI
%condition = {'spEEG'; 'control'};

% Calculate the mean trials for each subject/each electrode and put all the results in one big structure (NOT for the laplacian filtered data since it is already the average of trials)

for idx = 1:length(ID)
    filePath = [pathOut,ID{idx,1},'/'];
    
    for cond = 1 : length(condition)
        EEG{cond} = pop_loadset([filePath, ID{idx,1}, '_FINAL_',condition{cond}, '_',RefName,'.set']);
        
        for j = 1:nbchan
            onesubj_meantrials{cond} = mean(EEG{cond}.data(j,:,:),3);
            all_meantrials{cond}(j,idx) = {mean(EEG{cond}.data(j,:,:),3)};
            
            % calculate mean values of TEPs for each channel at each ISI/condition for each participants
            for i = 1:length(ISIs)
                C = ISIs(i);
                D = onesubj_meantrials{cond}(C);
                all_timepoints{cond}(j,idx,i) = D; 
                % Average each channel's timepoint-TEPs across participants
                timepoints_meansubjects{cond}(j,i) = mean(all_timepoints{cond}(j,:,i));
                
            end
        end
        
    end
end


% save the workspace
if strcmp(RefName, 'mastref')
    save([pathOut,'mastref_TEPs.mat']);
elseif strcmp(RefName, 'laplac')
    save([pathOut,'laplac_TEPs.mat']);
elseif strcmp(RefName, 'avref')
  save([pathOut,'avref_TEPs.mat']);
end
