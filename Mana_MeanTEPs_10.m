clear; close all; clc;

%##### Calculate the average of trials for each electrode/each subject/each condition and each electrode/ MEAN subjects/each condition

pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

% define the re-referencing method
RefName = 'avref';

% Apply exception for the number of electrodes for refrencing to link mastoids
if strcmp(RefName, 'mastref')
    nbchan = 60;
else
    nbchan = 62;
end

load([pathOut, RefName,'_TEPs.mat'])


for cond = 1:length (condition)
    
    for j = 1:nbchan
        
        for idx = 1:length(ID)
            % Make a matirix containing EEG data for each particiant/ each channel/each condition
            MeanTrials{cond}(idx,:,j) = cell2mat(all_meantrials{cond}(j,idx));
        end
        
        % Make a matirix containing the average EEG data across particpants for each channel/each condition
        MeanSubMeanTrial{cond,j} = mean(MeanTrials{cond}(:,:,j));
    end
       
end
save([pathOut, RefName,'Mean_TEPs.mat']);