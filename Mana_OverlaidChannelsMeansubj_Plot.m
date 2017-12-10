clear; close all; clc;

%##### plots of overlaid channels for MEAN subjects/each condition

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

% overlaid channels plot for mean participant/ each condition (show all plots in one figure)
for cond = 1:length(condition)
    subplot(length(ID),length(condition),k+cond);hold on;
    
    for j = 1: nbchan
        set(gca,'xlim',[-100,300]);hold on
        plot(EEG{cond}.times',((MeanSubMeanTrials{cond}(:,j))),'b'); hold on
        xlabel('Time(ms)');hold on
        ylabel('Amp(uV)'); hold on
    end
    
    C3 = plot(EEG{cond}.times',((MeanSubMeanTrials{cond}(:,5))),'r');hold on
    C3.LineWidth = 2; hold on
    title([condition{cond} ,' average across all subjects ']); hold on
    %saveas(F,fullfile(pathOut,'/myplots/',[RefName,'overlaid_TEPs_', condition{cond}, '_meansubjects']));
end
