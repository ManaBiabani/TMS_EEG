clear; close all; clc;

%##### plots of overlaid channels for each subject/each condition

pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

% define the re-referencing method
RefName = 'avref';

% Apply exception for the number of electrodes for refrencing to link mastoids
if strcmp(RefName, 'mastref')
    nbchan = 60;
else
    nbchan = 62;
end

load([pathOut, RefName,'Mean_TEPs.mat']);

for idx = 1:length(ID)
    figure; hold on
    
    for cond = 1:length(condition)
        subplot(1,length(condition),cond);hold on;
        
        for j = 1: nbchan
            set(gca,'xlim',[-100,300]);hold on
            plot(EEG{cond}.times',((MeanTrials{cond}(idx,:,j))),'b'); hold on
            xlabel('Time(ms)');hold on
            ylabel('Amp(uV)'); hold on
        end
        
        C3 = plot(EEG{cond}.times',((MeanTrials{cond}(idx,:,5))),'r');hold on
        C3.LineWidth = 2; hold on
        title([condition{cond} ,' subject ', ID{idx}]); hold on
        %saveas(F,fullfile(pathOut,'/myplots/',[RefName,'overlaid_TEPs_', condition{cond}, '_subject' ID{idx}]));
    end
   
end