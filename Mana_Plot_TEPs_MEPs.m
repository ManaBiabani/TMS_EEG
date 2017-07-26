clear; close all; clc; 
%### Plot MEPs vs EEG continuous recording
cd '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed'
load('spTEPs.mat');
load('ppTMS_MEPs.mat');
EEG1 = pop_loadset('filename','003_FINAL_high_avref.set','filepath','/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/003/');
EEG2 = pop_loadset('filename','003_FINAL_low_avref.set','filepath','/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/003/');

%define the ISIs and conditions
timepoints = [15;30;45;55;100;120;180;220];
cond = {'low';'high'};

% to make the error bar according to MEPs
error_high = sqrt(mean(MEPs_high(:,:,:)));
error_low = sqrt(mean(MEPs_high(:,:,:)));

%High intensity TEPs MEPs for one subject(003)
figure; 
x = plot(EEG1.times,mean(EEG1.data(5,:,:),3),'b'); hold on;
yyaxis left      
set(gca,'xlim',[-100,300]);
y = errorbar(timepoints,mean(MEPs_high(:,:,:)),error_high,'s');hold on;
xlabel('Time(ms)');
ylabel('Amp(uV)')

%low intensity TEPs MEPs for one subject(003)
figure; 
x = plot(EEG2.times,mean(EEG2.data(5,:,:),3),'b'); hold on;
yyaxis left      
set(gca,'xlim',[-100,300]);
y = errorbar(timepoints,mean(MEPs_low(:,:,:)),error_low,'s');hold on;
xlabel('Time(ms)');
ylabel('Amp(uV)')