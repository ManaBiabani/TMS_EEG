
clear; close all; clc; 

% where analyzed (EMG/EEG) data is stored
cd '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed'
load('spTEPs.mat');
load('ppTMS_MEPs.mat');

%ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'018';'019';'020';'021';'022';'022';'023';'024';'025';'026';'026';'027';'028';'029';'030'};
ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011'};

% Number of EEG channels
numofchannels = 62;

% ISIs points (corresponding time of EEG recording)
ISIs = [1016 1031 1046 1056 1101 1121 1181 1221];

% Zero-center EEG and EMG signals
EMG_offset = 100;
EEG_offset = 0;


% mean EEG all subjects
A=zeros(length(ID),length(all_high_meantrials{1}));
B=zeros(length(ID),length(all_low_meantrials{1}));
high_meantrials_allsubjects = zeros (numofchannels,length(all_high_meantrials{1}));
low_meantrials_allsubjects = zeros (numofchannels,length(all_low_meantrials{1}));

for j = 1:numofchannels 
    
       for idx = 1:length(ID)
           A(idx,:)=cell2mat(all_high_meantrials(j,idx));
           B(idx,:)=cell2mat(all_low_meantrials(j,idx));
       end
       
    high_meantrials_allsubjects(j,:) = mean (A);
    low_meantrials_allsubjects(j,:) = mean (B); 
end


for j = 1:numofchannels
     
           ZC_EEG_high_meantrials = high_meantrials_allsubjects(j,:) - EEG_offset;
           ZC_EEG_low_meantrials = low_meantrials_allsubjects(j,:) - EEG_offset;
           
            for i = 1:length(ISIs)
                    C = ISIs(i);
                    D1 = ZC_EEG_high_meantrials(C);
                    D2 = ZC_EEG_low_meantrials(C);
                    EEG_vector_1(j,i) = D1; 
                    EEG_vector_2 (j,i) = D2; 
                    MEP_vector_high_allsubjects(i) = mean(MEPs_high(:,i)) - EMG_offset;
                    MEP_vector_low_allsubjects(i) = mean(MEPs_low(:,i)) - EMG_offset;
%                    
               
                 
                    
                end 
              
       end                



eta_opt_high_allsubjects = zeros(numofchannels,1);
eta_opt_low_allsubjects = zeros(numofchannels,1);
    
    for j = 1:numofchannels
        
        EEG_vector_high_allsubjects = EEG_vector_1(j,:);
        EEG_vector_low_allsubjects = EEG_vector_2(j,:);
        f_dist_high = @(eta) sum(abs( EEG_vector_high_allsubjects*eta-MEP_vector_high_allsubjects)); 
        f_dist_low = @(eta) sum(abs( EEG_vector_low_allsubjects*eta-MEP_vector_low_allsubjects));
        eta_opt_high_allsubjects(j) = fminsearch(f_dist_high, 0 );
        eta_opt_low_allsubjects(j) = fminsearch(f_dist_low, 0 );
        rho_high_allsubjects(j) = f_dist_high(eta_opt_high_allsubjects(j));
        rho_low_allsubjects(j) = f_dist_low(eta_opt_low_allsubjects(j));
        scaled_EEG_signal_high_allsubjects(j,:) = high_meantrials_allsubjects(j,:).* eta_opt_high_allsubjects(j);
        scaled_EEG_signal_low_allsubjects(j,:) = low_meantrials_allsubjects(j,:).* eta_opt_low_allsubjects(j);
    end
     


   save('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/fitting/scaled_allsubjects');
