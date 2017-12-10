%  Averge of the residuals across subjects after regressing out the control data from each subject

clear; close all; clc;

pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

% define the re-referencing method
RefName = 'avref';

load([pathOut, RefName,'_RegressedOut_EachSub.mat']);

ResidConds = {[ResidHigh], [ResidLow]};

for cond = 1:length (ResidConds)
    
    for j = 1:nbchan
        % Make a matirix containing the average EEG data across particpants for each channel/each condition
        MeanResid_RegressedOut_EachSub{cond}(:,j) = mean(ResidConds{cond}(j,:,:),3);
    end
    
end
save([pathOut, RefName,'_MeanSubResids_RegressOut_EachSub.mat']);

% make overlaid plots of different conditions' residuals for each channel (choose one channel)
j = 5;
chanLabel = {EEG{1}.chanlocs.labels};
f = figure;
x1 = plot(EEG{1}.times', MeanResid_RegressedOut_EachSub{1}(:,j),'b'); hold on;
set(gca,'xlim',[-100,300]); hold on;
x2 = plot(EEG{2}.times',MeanResid_RegressedOut_EachSub{2}(:,j),'r'); hold on;
set(gca,'xlim',[-100,300]); hold on;
title (['MeanSub Regressed-Out EachSub ', chanLabel(j) ]);
legend('high','low')
xlabel('Time(ms)');hold on
ylabel('Amp(uV)'); hold on
%saveas(f,fullfile([pathOut, 'myplots/',RefName,'MeanSub_RegressedOut_EachSub_', chanLabel{j}]));

