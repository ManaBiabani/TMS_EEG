clear all; close all; clc;

% scatter plots of correlation results : make the scatter plot for r values of all ISIs with a reference line at zero 
pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

%Name of the re-referencing method to get the data from
RefName = 'avref';

% Number of channels
if strcmp(RefName, 'mastref')
    nbchan = 60;
else
    nbchan = 62;
end

%Load TEPs
load([pathOut, RefName '_Correlations_MEPs_TEPs.mat'])

%conditions
cond = {'high';'low'};

% choose the name of the matrix that contains the Correlation results
% for high/low conditions choose CorrPearson/ CorrSpearman 
% for control-high/control-low conditions choose CorrPearsonControl/CorrSpearmanControl
CorrFile = CorrSpearman; 
CorrFileName = 'CorrSpearman';
PvalFile = PvalSpearman; 
PvalFileName = 'PvalSpearman';

h = figure; hold on
suptitle (CorrFileName); hold on

%for j = 1:nbchan 
j = 5;

for  int = 1:length(cond)
    subplot(1,2,int)
    
    for isi = 1:length(ISIs)
        
        if PvalFile{int}(j,isi) <= 0.05
            scatter(ISIs(isi),CorrFile{int}(j,isi),'b','filled');hold on,
        else
            scatter(ISIs(isi),CorrFile{int}(j,isi),'b');hold on,
        end
        
        refLine = refline([0 0] );hold on,
        refLine.Color = 'r';hold on
        refLine.LineWidth = 2;hold on
        xlabel('Time(ms)');hold on
        ylabel('TEPs-MEPs correlation'); hold on
        title([cond{int} '-channel', num2str(j)]);
    end
    
end

hold on;
%end
