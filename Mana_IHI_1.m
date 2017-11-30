clear; close all; clc;

% ###### STEP 1:  EPOCH, REMOVE TMS ARTIFACT, DOWNSAMPLE #####

% IDs of participants to analyse
ID = {'001';'003';'004';'005';'006';'007';'008';'009';'010';'011';'012';'013';'014';'015';'016';'017'};

% Filename identifiers
sufix = {'BS';'ES'};

% suffix for filePathlog
suf3 = '_trigger.mat';

% File path where data is stored
pathIn = '/Volumes/BACKUP_HD/MANA_IHI/Raw/';
pathOut = '/Volumes/BACKUP_HD/MANA_IHI/Analyzed/';

% EEGLAB
[ALLEEG, EEG, CURRENTSET, ALLCOM, blockIndex] = eeglab;

for idx = 1:length(ID)
    
    % Makes a subject folder
    if ~isequal(exist([pathOut,ID{idx,1}], 'dir'),7)
        mkdir(pathOut,ID{idx,1});
    end
    
    %clear EEG
    EEG = {};
    
    %Clear ALLEEG
    ALLEEG = [];
    
    
    for suf = 1:length(sufix)
        
        %Include exceptions to blockNum
        if   strcmp(sufix{suf},'ES') && strcmp(ID{idx,1},'009')
            blockNum = {'1'};
        elseif strcmp(sufix{suf},'BS') && strcmp(ID{idx,1},'008')
            blockNum = {'2'};
        elseif strcmp(sufix{suf},'BS') && strcmp(ID{idx,1},'002')
            blockNum = {'1';'3'};
        else
            blockNum = {'1';'2'};
        end
        
        
        for block = 1:length(blockNum)
            
            % File path where data is stored
            filePath = [pathIn,ID{idx,1},'/',ID{idx,1},'_EEG/'];
            
            % File path where log files are stored
            filePathLog =[pathIn,ID{idx,1},'/',ID{idx,1},'_EEG'];
            
            % Loads Curry files
            EEG = loadcurry( [pathIn,ID{idx,1}, '/',ID{idx,1}, '_EEG/', ID{idx,1}, '_', sufix{suf,1},'_', blockNum{block}, '.dap'],'CurryLocations', 'False');
            
            % Load channel locations
            EEG=pop_chanedit(EEG, 'lookup','/Users/manabiabanimoghadam/Desktop/Functions/eeglab14_1_0b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
            
            %Include exceptions to TMS pulse detection
            if ID{idx} == '011'
                EEG = pop_tesa_findpulse( EEG, 'C4', 'refract', 10, 'rate', 10000, 'tmsLabel', 'TMS', 'plots', 'on');
            elseif ID{idx} == '008'
                EEG = pop_tesa_findpulse( EEG, 'C4', 'refract', 10, 'rate', 10000, 'tmsLabel', 'TMS', 'plots', 'on');
            elseif ID{idx} == '015'
                EEG = pop_tesa_findpulse( EEG, 'C4', 'refract', 10, 'rate', 10000, 'tmsLabel', 'TMS', 'plots', 'on');
            else
                EEG = pop_tesa_findpulse( EEG, 'C3', 'refract', 10, 'rate', 10000, 'tmsLabel', 'TMS', 'plots', 'on');
            end
            
            % load mat files
            fileLogName = [filePathLog,'/', sufix{suf}, '_' ,blockNum{block},'_',ID{idx,1},suf3];
            load(fileLogName);
            
            % Align EEG events with the corresponding TMS pulses and remove extra events
            % Compute cross correlation between EEG events latency and TMS intervals;
            A = ([EEG.event.latency]).';
            B = ([states.frameinfo.start]).';
            r = xcorr(A,B);
            [r,lag] = xcorr(A,B);
            [~,I] = max(abs(r));
            
            %Find the shift from the maximum correlation
            timeDiff = lag(I);
            
            %Correct the shift
            if  timeDiff~=1
                EEG.event = circshift(EEG.event,(-timeDiff));
            end
            
            %Remove extra events
            while length(EEG.event)>states.frames
                EEG.event(end) = [];
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
            
            % label the mplitude as 'control' and 'spEEG'
            for i = 1:EEG.trials
                if   strcmp(sufix{suf},'ES')
                    EEG.event(i).type = 'control';
                elseif strcmp(sufix{suf},'BS')
                    EEG.event(i).type = 'spEEG';
                end;
            end
            
            % Save EEG for each block type for each participant
            [ALLEEG, EEG,blockIndex] = eeg_store(ALLEEG,EEG,block);
            
        end;
        
        ALL{suf} = ALLEEG;
        % Merge the same blocks ('BS' or 'ES') for each subject
        storeEEG {suf,1} = pop_mergeset(  ALL{suf}, 1:size(blockNum,1), 0);
               
    end;
    
    % Merge all blocks for each subject
    EEG = pop_mergeset( storeEEG{1}, storeEEG{2},0);
    
    % save data
    EEG = pop_saveset( EEG, 'filepath',[pathOut,ID{idx,1},'/'],'filename', [ID{idx,1} '_' 'all_blocks' '_' 'ds']);
end

