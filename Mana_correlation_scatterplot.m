clear; close all; clc; 
%## Scatterplots for TEP/MEP data and r values

% Make the scatter plot of all individuals TEP/MEP values for each channel/ISI/conditioin ( all ISIs in one figure) and save the plots

 load ('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/Correlations_MEPs_TEPs_allchannels')

% Pick one channel to examine or uncomment the for loop for all channels
 chanNum = 5;

% for chanNum = 1:numofchannels
 for int = 1:length(cond)
     f(chanNum) = figure;
     suptitle(num2str(cond{int}));hold on
     
            for  isi = 1:length(ISIs)
                 subplot(2,4,isi);hold on,
                 scatter(all_TEPs{int}(chanNum,isi,:),all_MEPs{int}(isi,:)'); hold on,
                 xlabel('TEPs');
                 ylabel('MEPs');
                 title(ISIs(isi));hold on,
                 saveas(f(chanNum),fullfile('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/myplots/',['scatterplot_MEPs_TEPs_' cond{int} '_channel' num2str(chanNum) ]));
            
            end
          
 end
%     end



% For each channel/condition make the scatter plot of r values at different ISIs with a reference line
 % at zero and save the plots      
    

% for chanNum = 1:numofchannels
 for int = 1:length(cond)
     h(chanNum) = figure;hold on
     
          for isi = 1:length(ISIs) 
              if Pval(chanNum,isi,int) <= 0.05
              scatter(ISIs(isi),correlation_results_allchannels(chanNum,isi,int),'b','filled');hold on,
              else
              scatter(ISIs (isi),correlation_results_allchannels(chanNum,isi,int), 'b');hold on,
              end
              refLine = refline([0 0]);hold on,
              refLine.Color = 'r';hold on
              xlabel('Time(ms)'); hold on
              ylabel('TEPs-MEPs correlation');hold on
              title(num2str(cond{int}))
              saveas(h(chanNum),fullfile('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/myplots/',['refLine_Correlations_MEPs_TEPs_' (cond{int}) '_channel' num2str(chanNum)]));
        end
end
%  end
   