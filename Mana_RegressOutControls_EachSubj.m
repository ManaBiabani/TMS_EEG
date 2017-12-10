%  Regress out the control data from each condition/each subject and make overlaid plots of different conditions' residuals for each channel/each subject

clear; close all; clc;

pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

% define the re-referencing method
RefName = 'avref';

load([pathOut, RefName,'_Mean_TEPs.mat']);

for idx = 1:length(ID)
    
    for j = 1:nbchan
        fitLinehigh = fit(MeanTrials{1}(idx,:,j)',MeanTrials{3}(idx,:,j)','poly1');
        ResidHigh(j,:,idx) = MeanTrials{1}(idx,:,j)' - fitLinehigh(MeanTrials{3}(idx,:,j)');
        fitLineLow = fit(MeanTrials{2}(idx,:,j)',MeanTrials{3}(idx,:,j)','poly1');
        ResidLow(j,:,idx) = MeanTrials{2}(idx,:,j)' - fitLineLow(MeanTrials{3}(idx,:,j)');
    end
    
end
save([pathOut, RefName,'_RegressedOut_EachSub.mat']);


% make overlaid plots of different conditions' residuals for each channel/each subject (choose one channel)
j = 5;
chanLabel = {EEG{1}.chanlocs.labels};

for idx = 1:length(ID)
    
    f = figure;
    x1 = plot(EEG{1}.times',ResidHigh(j,:,idx),'b'); hold on;
    set(gca,'xlim',[-100,300]); hold on;
    x2 = plot(EEG{2}.times',ResidLow(j,:,idx),'r'); hold on;
    set(gca,'xlim',[-100,300]); hold on;
    title (['Regressed-Out Controls', ID{idx},chanLabel(j) ]);
    legend('high','low')
    xlabel('Time(ms)');hold on
    ylabel('Amp(uV)'); hold on
    %saveas(f,fullfile([pathOut, 'myplots/',RefName,'RegressOutControls_', ID{idx},'_', chanLabel{j}]));
    
end
