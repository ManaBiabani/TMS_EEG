%%%% plot continues EEG recordings for each subject / each channel 

cd '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed'

%ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'018';'019';'020';'021';'022';'022';'023';'024';'025';'026';'026';'027';'028';'029';'030'};
ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011'};

% IDNum = cellfun(@(x)str2double(x), ID);

% conditions
cond = {'low';'high'};

%number of channels
nbchan = 62;

% select a channel to examine or uncomment the for loop for all channels
j = 5;

for int = 1:size (cond,1)
    fTEPs = figure; hold on
 
        for idx = 1:size(ID,1)
         
%         for j = 1:nbchan
            EEG1 = pop_loadset('filename',[ID{idx,1} '_FINAL_' cond{int,1} '_avref.set'],'filepath',['/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/' ID{idx,1} '/']);
            subplot(5,2,idx);hold on
            plot(EEG1.times,mean(EEG1.data(j,:,:),3),'b'); hold on
            set(gca,'xlim',[-100,300]);hold on,
            xlabel('Time(ms)');
            ylabel('Amp(uV)');
            title ([ID(idx,1), num2str(cond{int})]);hold on,
%          end

        end
       
saveas(fTEPs,fullfile('/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/myplots/',['TEPs_' cond{int,1}]));
end
