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


for idx = 1:length(ID)
    
       for j = 1:numofchannels 
           ZC_EEG_high_meantrials= cell2mat(all_high_meantrials(j,idx)) - EEG_offset;
           ZC_EEG_low_meantrials= cell2mat(all_low_meantrials(j,idx)) - EEG_offset;
                for i=1:length(ISIs)
                    C=ISIs(i);
                    D1 =  ZC_EEG_high_meantrials(C);
                    D2 =  ZC_EEG_low_meantrials(C);
                    EEG_vector_1(j,i,idx)=D1; 
                    EEG_vector_2(j,i,idx)=D2; 
                    
                end 
                
       end                
end


eta_opt_high = zeros(numofchannels,length(ID));
eta_opt_low = zeros(numofchannels,length(ID));
scaled_EEG_signal_high = {zeros(numofchannels ,length(ID))}
scaled_EEG_signal_low = {zeros(numofchannels ,length(ID))}

for idx = 1:length(ID)
    
    for j = 1:numofchannels   
        MEP_vector_high = MEPs_high(idx,:) - EMG_offset;
        MEP_vector_low = MEPs_low(idx,:) - EMG_offset;
        EEG_vector_high = double(EEG_vector_1(j,:,idx));
        EEG_vector_low = double(EEG_vector_2(j,:,idx));
        f_dist_high = @(eta) sum(abs( EEG_vector_high*eta-MEP_vector_high)); 
        f_dist_low = @(eta) sum(abs( EEG_vector_low*eta-MEP_vector_low));
        eta_opt_high(j,idx) = fminsearch(f_dist_high, 0 );
        eta_opt_low(j,idx) = fminsearch(f_dist_low, 0 );
        rho_high (j,idx) = f_dist_high(eta_opt_high(j,idx));
        rho_low (j,idx) = f_dist_low(eta_opt_low(j,idx));
        scaled_EEG_signal_high(j,idx) = {cell2mat(all_high_meantrials(j,idx)).* eta_opt_high(j,idx)};
        scaled_EEG_signal_low(j,idx) = {cell2mat(all_low_meantrials(j,idx)).* eta_opt_low(j,idx)};
    end
     
end


   save('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/fitting/scaled');