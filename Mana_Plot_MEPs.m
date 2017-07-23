%%% ### disorganized_ The two for loops need to be combined into one##

%change the current folder to where the MEP results are and load the file
cd '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed'
load('meps_results.mat')

%define the ISIs and conditions
timepoints = [15;30;45;55;100;120;180;220];
cond = {'low';'high'};
A = {'MEPs_high';'MEPs_low'}

% to make the error bar according to MEPs
error_high = sqrt(mean(MEPs_high(:,:,:)));
error_low = sqrt(mean(MEPs_high(:,:,:)));

%make the scatter plot with error bars to show MEPs evoked by high and low intensity CS across different ISIs

 figure
        
         for idx = 1:size(ID,1)
         subplot(5,2,idx)
         errorbar(timepoints,MEPs_low(idx,:,:),error_high,'s')
         xlabel('Time(ms)');
         ylabel('Amp(uV)');
         title(ID(idx,1));
        
        
     end
  
 savefig(figure,'MEPs_low');
 
 
  figure
        
         for idx = 1:size(ID,1)
         subplot(5,2,idx)
         errorbar(timepoints,MEPs_high(idx,:,:),error_high,'s')
         xlabel('Time(ms)');
         ylabel('Amp(uV)');
         title(ID(idx,1));
        
        
     end
  
 savefig(figure,'MEPs_high');
 
 
   
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
legend(cond);
addpath('/Volumes/BACKUP_HD/MANA_TMS_EEG');
%%% ### plot MEPs ###

%change the current folder to where the MEP results are and load the file
cd '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed'
load('meps_results.mat')

%define the ISIs and conditions
timepoints = [15;30;45;55;100;120;180;220];
cond = {'high';'low'};

% to make the error bar according to MEPs
error_high = sqrt(mean(MEPs_high(:,:,:)));
error_low = sqrt(mean(MEPs_high(:,:,:)));

%make the scatter plot with error bars to show MEPs evoked by high and low intensity CS across different ISIs
figure; 
scatter(timepoints,mean(MEPs_high(:,:,:)))
errorbar(timepoints,mean(MEPs_high(:,:,:)),error_high,'s');hold on;
errorbar(timepoints,mean(MEPs_low(:,:,:)),error_low,'s');hold on;
xlabel('Time (ms)');
ylabel('Amplitude (\muV)');
legend(cond);
addpath('/Volumes/BACKUP_HD/MANA_TMS_EEG');

% save the figure in the current folder
savefig('MEPs_high_low')

