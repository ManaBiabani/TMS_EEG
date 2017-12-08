clear; close all; clc;
% ## Makes subplots of topographic map of r-values of the pearson and spearman correlations between MEPs and TEPs across different ISIs/conditions

pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

%Name of the re-referencing method to get the data from
RefName = 'avref';

% Number of channels
if strcmp(RefName, 'mastref')
    nbchan = 60;
else
    nbchan = 62;
end

% Load TEPs
load([pathOut, RefName '_Correlations_MEPs_TEPs.mat'])

% choose the name of the matrix that contains the Correlation results
% for high/low conditions choose CorrPearson/ CorrSpearman
% for control-high/control-low conditions choose CorrPearsonControl/CorrSpearmanControl
CorrFileCond = CorrSpearman;
CorrType = 'Spearman Correlation';
CorrFileControl = CorrSpearmanControl;


% Subplots of topographic distribution of TEPs-MEPs Pearson r values
P = figure; hold on
suptitle (['TEPs-MEPs ', CorrType]); hold on

% Choose the ppTMS ISIs
ISIs = [15; 30; 45; 55; 100; 120; 180; 220];

for int = 1:length(cond)
    
    for  isi = 1:length(ISIs)
        
        if int == 1
            subplot(4,8,isi);
            A = topoplot(CorrFileCond{int}(:,isi),EEG{int}.chanlocs);hold on
            title([ num2str(ISIs(isi)), ' High']); hold on;
            subplot(4,8,(length(ISIs)+isi));
            A = topoplot(CorrFileControl{int}(:,isi),EEG{int}.chanlocs);hold on
            title([ num2str(ISIs(isi)), ' control-High']); hold on;
        elseif int == 2
            subplot(4,8,(2*length(ISIs)+isi))
            A = topoplot(CorrFileCond{int}(:,isi),EEG{int}.chanlocs);hold on
            title([ num2str(ISIs(isi)), ' low']); hold on
            subplot(4,8,(3*length(ISIs)+isi));
            A = topoplot(CorrFileControl{int}(:,isi),EEG{int}.chanlocs);hold on
            title([ num2str(ISIs(isi)), ' control-low']); hold on;
        end
        
    end
end

%reposition the title and colorbar
fig = get(subplot(4,8,32),'Position');
colorbar('Position', [fig(1)+0.1  fig(2)+0.008  0.008 fig(4)]);hold on
caxis ([-1 1]);
set(gcf,'color','w')

%saveas(P,fullfile([pathOut, 'myplots/TEPs_MEPs_',CorrType,'_topoplots']));
