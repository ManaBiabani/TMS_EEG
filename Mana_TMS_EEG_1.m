clear; close all; clc; 

% ###### STEP 1: CONVERT, EPOCH, REMOVE TMS ARTIFACT, DOWNSAMPLE #####

%eeglab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% IDs of participants to analyse
%  ID = {'002';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017';'018';'019';'020';'021';'022';'022';'023';'024';'025';'026';'026';'027';'028';'029';'030'};
ID = {'011'}


% Filename identifiers
suf1 = '_SP_EEG_';
suf2 = '_Data.cnt';


% suffix for filePathlog
suf3 = '_trigger.mat';

%The number of blocks
blockNum = {'1'};

% File path where data is stored

%myPath = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Raw/';
pathIn = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Raw/';
pathOut = '/Volumes/BACKUP_HD/MANA_TMS_EEG/Analyzed/';

 [ALLEEG, EEG,blockIndex]=eeglab;  
 
for     idx = 1:size(ID,1)
    
        %clear EEG
        EEG = {};
        
        %Clear ALLEEG
        ALLEEG = [];
        
        %Include exceptions to the above settings 
        
        if    strcmp(ID{idx,1},'002');
              blockNum = {'1';'2';'3'};
              else blockNum = {'1';'2';'3';'4'};
        end

       for     block = 1:size(blockNum,1)
     
        % File path where data is stored
          filePath = [pathIn,ID{idx,1},'/',ID{idx,1},'_EEG/converted_data/'];

        % File path where log files are stored
          filePathLog =[pathIn,ID{idx,1},'/',ID{idx,1},'_EEG'];

        % Makes a subject folder
          if ~isequal(exist([pathOut,ID{idx,1}], 'dir'),7)
                mkdir(pathOut,ID{idx,1});
          end
            
        % Loads cnt files   
          fileName = [filePath, ID{idx,1}, suf1,blockNum{block,1},suf2]; 
          EEG = pop_loadcnt(fileName, 'dataformat', 'auto', 'memmapfile', '');
        
        % Load channel locations
         EEG=pop_chanedit(EEG, 'lookup','/Users/manabiabanimoghadam/Desktop/Functions/eeglab14_1_0b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');

        % Find TMS pulse
         EEG = pop_tesa_findpulse( EEG, 'CZ', 'refract', 10, 'rate', 10000, 'tmsLabel', 'TMS', 'plots', 'on');
        
        % load mat files 
        fileLogName = [filePathLog,'/',ID{idx,1},suf1,blockNum{block,1},suf3];
        load(fileLogName);
        
        % Compute cross correlation between EEG events latency and TMS intervals;
      
        A = ([EEG.event.latency]).';
        B = (cfg.isi);
        r = xcorr(A,B);
        [r,lag] = xcorr(A,B);
        [~,I] = max(abs(r));
        
        % find the shift from the maximum correlation
        timeDiff = lag(I);
        
        %correct the shift
        
        if   timeDiff~=1 
           
            EEG.event = circshift(EEG.event,(-timeDiff));
%             EEG.event = EEG.event(1:end-(abs(timeDiff)));
           
        end
         
       % remove extra events
        while length(EEG.event)>length(cfg.amp)
            EEG.event(end) = []
        end

      % Epoch the data
        EEG = pop_epoch( EEG, {  'TMS'  }, [-1  1], 'newname', 'ep', 'epochinfo', 'yes');

      % Remove baseline
        EEG = pop_rmbase( EEG, [-500  -10]);

      % Remove unused channels
        EEG = pop_select( EEG,'nochannel',{'31' '32' 'Trigger'});
        
     % Save the original EEG locations for use in interpolation later
        EEG.allchan = EEG.chanlocs;

     % Remove TMS artifact
        EEG = pop_tesa_removedata( EEG, [-1 10] );

     % Interpolate missing data 
        EEG = pop_tesa_interpdata( EEG, 'cubic', [1 1] );

    % Downsample data
        EEG = pop_resample( EEG, 1000);
        
      
            
    % label the mplitude as 'low' for 80% rMT and 'high' for 120%rmt  
    
         minamp = min(cfg.amp);
         maxamp = max(cfg.amp);
         
         for i = 1:EEG.trials
              if cfg.amp(i) == minamp
                EEG.event(i).type = 'low';
              else EEG.event(i).type = 'high';
              end;
          end;
             
    % save EEG for each block for each participant
       [ALLEEG, EEG,blockIndex] = eeg_store(ALLEEG,EEG,block);
       

    end;
                 
    % merge data sets
        EEG = pop_mergeset( ALLEEG, 1:size(blockNum,1), 0);
     
    % save data
     EEG = pop_saveset( EEG, 'filepath',[pathOut,ID{idx,1},'/'],'filename', [ID{idx,1} '_' 'all_blocks' '_' 'ds']);
    
end;
