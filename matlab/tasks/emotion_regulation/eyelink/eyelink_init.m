function EL = eyelink_init(S, cfg, P)
% EYELINK_INIT
% Adds:
%   - TASK_START, DATASET, BLOCK, DATASET_HASH messages
%   - Uses cfg.el.edfFile (already unique from makeEdfName)

EL = struct('enabled',false,'dummymode',1,'edfFile',cfg.el.edfFile, ...
            'el',[],'pahandle',[],'pamaster',[]);

if ~cfg.el.useEyelink
    fprintf('[EyeLink] Disabled by flag.\n');
    return;
end

try
    EL.dummymode = cfg.el.dummymode;
    EyelinkInit(EL.dummymode);

    if Eyelink('IsConnected') < 1
        EL.dummymode = 1;
        fprintf('[EyeLink] Not connected -> DUMMY mode.\n');
    end

    if EL.dummymode == 0
        failOpen = Eyelink('OpenFile', EL.edfFile);
        if failOpen ~= 0
            error('Cannot create EDF file. failOpen=%d (edf=%s)', failOpen, EL.edfFile);
        end
        fprintf('[EyeLink] EDF opened on Host: %s\n', EL.edfFile);
    end

    ELsoftwareVersion = 0;
    [~, versionstring] = Eyelink('GetTrackerVersion');
    if EL.dummymode == 0
        [~, vnumcell] = regexp(versionstring,'.*?(\d)\.\d*?','Match','Tokens');
        ELsoftwareVersion = str2double(vnumcell{1}{1});
    end

    Eyelink('Command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
    Eyelink('Command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,BUTTON,FIXUPDATE,INPUT');

    if ELsoftwareVersion > 3
        Eyelink('Command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,RAW,AREA,HTARGET,GAZERES,BUTTON,STATUS,INPUT');
        Eyelink('Command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,HTARGET,STATUS,INPUT');
    else
        Eyelink('Command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,RAW,AREA,GAZERES,BUTTON,STATUS,INPUT');
        Eyelink('Command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');
    end

    EL.el = EyelinkInitDefaults(S.win);
    EL.el.calibrationtargetsize   = 3;
    EL.el.calibrationtargetwidth  = 0.7;
    EL.el.backgroundcolour        = repmat(GrayIndex(S.win),1,3);
    EL.el.calibrationtargetcolour = repmat(BlackIndex(S.win),1,3);
    EL.el.msgfontcolour           = repmat(BlackIndex(S.win),1,3);

    EL.el.calTargetType          = 'image';
    if isfield(cfg,'paths') && isfield(cfg.paths,'assetsDir')
        EL.el.calImageTargetFilename = fullfile(cfg.paths.assetsDir, 'fixation', cfg.el.calTargetImage);
    else
        EL.el.calImageTargetFilename = cfg.el.calTargetImage;
    end
    EL.el.targetbeep   = 1;
    EL.el.feedbackbeep = 1;

    InitializePsychSound();
    EL.pamaster = PsychPortAudio('Open', [], 8+1);
    PsychPortAudio('Start', EL.pamaster);
    EL.pahandle = PsychPortAudio('OpenSlave', EL.pamaster, 1);
    EL.el.ppa_pahandle = EL.pahandle;

    EyelinkUpdateDefaults(EL.el);

    Eyelink('Command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, S.width-1, S.height-1);
    Eyelink('Message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, S.width-1, S.height-1);

    Eyelink('Command', sprintf('calibration_type = %s', cfg.el.calType));
    Eyelink('Command', 'button_function 5 "accept_target_fixation"');
    Eyelink('Command', 'clear_screen 0');

    fprintf('[EyeLink] Calibration starting...\n');
    EyelinkDoTrackerSetup(EL.el);
    fprintf('[EyeLink] Calibration done.\n');

    Eyelink('SetOfflineMode'); WaitSecs(0.05);
    Eyelink('StartRecording');
    Eyelink('WaitForModeReady', 500);
    WaitSecs(0.05);

    EL.enabled = (EL.dummymode == 0);

    % High-level messages (include block + dataset hash)
    eyelinkMsg(EL, 'TASK_START');
    eyelinkMsg(EL, 'DATASET %s', cfg.task.image_dataset_id);
    eyelinkMsg(EL, 'BLOCK %d', P.blockNum);
    eyelinkMsg(EL, 'DATASET_HASH %s', P.datasetHash);

catch ME
    warning('Task:EyeLinkInit', '%s', ME.message);
    EL.enabled = false;
    try, Eyelink('Shutdown'); catch, end
end
end
