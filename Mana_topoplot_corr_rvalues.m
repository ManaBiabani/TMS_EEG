clear; close all; clc;

%## 

% Make the scatter plot of all individuals TEP/MEP values for each channel/ISI/conditioin ( all ISIs in one figure) and save the plots
 load ('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Correlations_MEPs_TEPs_allchannels');


for         int = 1:length(cond)
    

            for  isi = 1:length(ISIs)
                 topo =  figure;
                 A = topoplot(correlation_results_allchannels(:,isi,int),EEG_high.chanlocs,'dipcolor', 'b') ;hold on
                 
                 if int == 1
                 title([ num2str(ISIs(isi)),'(high)']);
                 else
                 title([num2str(ISIs(isi)),'(Low)']);
                 end
                 saveas(topo,fullfile('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/myplots/topoplots/',['topo_r_' cond{int}, '_' num2str(isi) ]));
           
            end
          
 end
