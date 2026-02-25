function Results = task_emoreg_run(cfg, P)
% TASK_EMOREG_RUN
% Reusable Emotion Regulation task entry point.
% Usage:
%   cfg = cfg_emoreg_defaults();
%   cfg.paths.imagesDir = '/path/to/images';
%   cfg.paths.scalesDir = '/path/to/scales';
%   cfg.paths.resultsDir = '/path/to/results';
%   cfg.paths.assetsDir = '/path/to/neuro_toolbox/assets';
%   Results = task_emoreg_run(cfg);

if nargin < 1 || isempty(cfg)
    cfg = cfg_emoreg_defaults();
end

cfg = validate_cfg(cfg);

% Participant dialog if not provided
if nargin < 2 || isempty(P)
    EA_inputs   = {'Participant ID','Session Number','StimCondition'};
    EA_defaults = {'1','1','1'};
    EA_response = inputdlg(EA_inputs, 'Participant Data', 1, EA_defaults);
    if isempty(EA_response), error('User cancelled Participant Data dialog.'); end

    P = struct();
    P.subj  = strtrim(EA_response{1});
    P.sess  = str2double(EA_response{2});
    P.cond  = str2double(EA_response{3});

    if isempty(P.subj)
        error('Participant ID cannot be empty. Use e.g., k01, f01, s23.');
    end
    if isnan(P.sess) || isnan(P.cond)
        error('Session Number and StimCondition must be numbers.');
    end
end

P.date  = date;
P.stamp = datestr(now,'yyyy-mm-dd_HHMMSS');

P.datasetHash = dataset_hash(cfg.task.image_dataset_id);
P.blockNum    = extract_block_number(cfg.task.image_dataset_id);

P.edf = makeEdfName(P.subj, P.sess, P.cond, P.blockNum, P.datasetHash, cfg.paths.resultsDir);
cfg.el.edfFile = P.edf;

safeSubj = regexprep(upper(P.subj), '[^A-Z0-9]', '');
if isempty(safeSubj), safeSubj = 'SUBJ'; end
resultsBase = sprintf('Results_%s_S%d', safeSubj, P.sess);
finalFile   = fullfile(cfg.paths.resultsDir, sprintf('%s_%s.mat', resultsBase, P.date));
abortFile   = fullfile(cfg.paths.resultsDir, sprintf('%s_%s_ABORT_%s.mat', resultsBase, P.date, P.stamp));

abortFlag = false;

% ---- Open PTB window + Screen state ----
Screen('Preference', 'SkipSyncTests', cfg.screen.skipSync);
Screen('Preference', 'VisualDebugLevel', 0);

screens = Screen('Screens');
if cfg.screen.screenNumber > max(screens)
    error('screenNumber=%d not available. Available screens: %s', cfg.screen.screenNumber, mat2str(screens));
end

[S.win, S.rect] = Screen('OpenWindow', cfg.screen.screenNumber, cfg.col.bg);
cleanupObj = onCleanup(@() hardCleanup()); %#ok<NASGU>

[S.xc, S.yc] = RectCenter(S.rect);
Screen('TextSize', S.win, cfg.screen.textSize);
[S.width, S.height] = Screen('WindowSize', S.win);

cfg.photo.rect = [ ...
    S.rect(3) - cfg.photo.marginPx - cfg.photo.sizePx, ...
    S.rect(4) - cfg.photo.marginPx - cfg.photo.sizePx, ...
    S.rect(3) - cfg.photo.marginPx, ...
    S.rect(4) - cfg.photo.marginPx ];

S.drawPhotoOn  = @(w) Screen('FillRect', w, cfg.photo.onCol,  cfg.photo.rect);
S.drawPhotoOff = @(w) Screen('FillRect', w, cfg.photo.offCol, cfg.photo.rect);

% ---- Keys ----
KbName('UnifyKeyNames');
escKey = KbName(cfg.keys.esc);

rowKeys = [KbName('1!') KbName('2@') KbName('3#') KbName('4$') KbName('5%') ...
           KbName('6^') KbName('7&') KbName('8*') KbName('9(')];
numpadKeys = [];
if cfg.keys.useNumpad
    try
        numpadKeys = [KbName('KP_1') KbName('KP_2') KbName('KP_3') KbName('KP_4') KbName('KP_5') ...
                      KbName('KP_6') KbName('KP_7') KbName('KP_8') KbName('KP_9')];
    catch
        numpadKeys = [];
    end
end
keyList = unique([rowKeys numpadKeys]);
validKeys = [keyList(:) (1:9)'];

% ---- BioSemi init ----
Trig = biosemi_init(cfg.trig);

% ---- EyeLink init ----
EL = eyelink_init(S, cfg, P);

% ---- Load stimuli ----
PicDB = loadImagesAsTextures(S.win, cfg, S.xc, S.yc);
random_order = randperm(cfg.task.n_Trials);
PicDB = PicDB(random_order);
Valence = loadValenceScale(S.win, cfg, S.xc, S.yc);

% ---- Results init ----
Results = struct();
Results.ParticipantData = struct( ...
    'ParticipantID',  P.subj, ...
    'SessionNumber',  P.sess, ...
    'StimCondition',  P.cond, ...
    'Date',           P.date);

Results.Meta = struct();
Results.Meta.Script       = mfilename;
Results.Meta.SessionStamp = P.stamp;
Results.Meta.PhotoParams  = cfg.photo;

Results.Meta.Trigger = struct();
Results.Meta.Trigger.PortName    = cfg.trig.portName;
Results.Meta.Trigger.BaudRate    = cfg.trig.baudRate;
Results.Meta.Trigger.Enabled     = Trig.enabled;
Results.Meta.Trigger.Dummy       = Trig.dummy;
Results.Meta.Trigger.DummyReason = Trig.dummyReason;
Results.Meta.Trigger.Codes       = cfg.trig.codes;

Results.Meta.EyeLink = struct('Enabled',EL.enabled,'DummyMode',EL.dummymode,'EDFFile',EL.edfFile);
Results.Meta.Dataset = struct('Id',cfg.task.image_dataset_id,'Hash',P.datasetHash,'Block',P.blockNum);

Results.FlipLog    = struct('trial',{},'phase',{},'sensorOn',{},'vbl',{});
Results.PhotoLog   = struct('trial',{},'phase',{},'vbl_on',{},'pulseFrames',{},'rect',{},'onRGB',{},'offRGB',{});
Results.TriggerLog = struct('trial',{},'phase',{},'code',{},'tGetSecs',{});

Results.Trials = struct('ImageIndex',cell(1,cfg.task.n_Trials), ...
                        'CueText',   cell(1,cfg.task.n_Trials), ...
                        'Valence',   cell(1,cfg.task.n_Trials), ...
                        'RT_Valence',cell(1,cfg.task.n_Trials));

% ---- Instructions ----
[Results, Trig] = presentOnset(S.win, cfg, Results, Trig, EL, 0, 'intro1', ...
    @() DrawFormattedText(S.win,'The experiment begins now!','center','center',cfg.col.grey), ...
    cfg.trig.codes.intro1, S.drawPhotoOn, S.drawPhotoOff);

WaitSecs(4);

[Results, Trig] = presentOnset(S.win, cfg, Results, Trig, EL, 0, 'intro2', ...
    @() DrawFormattedText(S.win,'Press any key to begin (ESC to abort).','center','center',cfg.col.grey), ...
    cfg.trig.codes.intro2, S.drawPhotoOn, S.drawPhotoOff);

if waitAnyKeyOrEsc(escKey), abortFlag = true; end
if abortFlag
    Results.Meta.AbortedAt = P.stamp;
    save(abortFile,'Results','-v7.3');
    fprintf('Aborted at instructions. Saved:\n%s\n', abortFile);
    finalizeAndExit(cfg, Trig, EL);
    return;
end

Screen('FillRect', S.win, cfg.col.bg);
vbl = flipWithPhoto(S.win, S.drawPhotoOff);
Results = logFlip(Results, 0, 'clear_before_trials', 0, vbl);
WaitSecs(2);

% ---- Trial loop ----
try
for i = 1:cfg.task.n_Trials
    if abortFlag, break; end
    trial = i;

    eyelinkMsg(EL, 'TRIALID %d B%d H%s', trial, P.blockNum, P.datasetHash);
    eyelinkMsg(EL, 'TRIAL_START %d B%d H%s', trial, P.blockNum, P.datasetHash);

    [Results, Trig] = presentOnset(S.win, cfg, Results, Trig, EL, trial, 'fix1', ...
        @() drawFixation(S.win,[S.xc S.yc],cfg.col.white,cfg), ...
        cfg.trig.codes.fix1, S.drawPhotoOn, S.drawPhotoOff);
    WaitSecs(cfg.timing.fixBase + rand(1));

    cueIdx  = randi(2);
    cueText = cfg.cue.options{cueIdx};

    [Results, Trig] = presentOnset(S.win, cfg, Results, Trig, EL, trial, 'cue_onset', ...
        @() drawCueOnly(S.win,cueText,cfg.col.white,cfg), ...
        cfg.trig.codes.cue, S.drawPhotoOn, S.drawPhotoOff);

    if waitWithEsc(cfg.timing.cue_time, escKey), abortFlag = true; end
    if abortFlag, break; end

    [Results, Trig] = presentOnset(S.win, cfg, Results, Trig, EL, trial, 'fix2', ...
        @() drawFixation(S.win,[S.xc S.yc],cfg.col.white,cfg), ...
        cfg.trig.codes.fix2, S.drawPhotoOn, S.drawPhotoOff);
    WaitSecs(cfg.timing.fixBase + rand(1));

    [Results, Trig] = presentOnset(S.win, cfg, Results, Trig, EL, trial, 'image_onset', ...
        @() drawImageOnly(S.win,PicDB(trial)), ...
        cfg.trig.codes.image, S.drawPhotoOn, S.drawPhotoOff);

    if waitWithEsc(cfg.timing.image_time, escKey), abortFlag = true; end
    if abortFlag, break; end

    [Results, Trig] = presentOnset(S.win, cfg, Results, Trig, EL, trial, 'fix3', ...
        @() drawFixation(S.win,[S.xc S.yc],cfg.col.white,cfg), ...
        cfg.trig.codes.fix3, S.drawPhotoOn, S.drawPhotoOff);
    WaitSecs(cfg.timing.fixBase + rand(1));

    [Results, Trig] = presentOnset(S.win, cfg, Results, Trig, EL, trial, 'valence_onset', ...
        @() drawValenceOnly(S.win,Valence), ...
        cfg.trig.codes.valence_onset, S.drawPhotoOn, S.drawPhotoOff);

    t0 = GetSecs;
    [valence_rating, rt_val, aborted] = collect_rating(validKeys, t0, cfg.timing.rating_max, escKey);
    if aborted, abortFlag = true; end
    if abortFlag, break; end

    if ~isnan(valence_rating)
        codeResp = cfg.trig.codes.valence_respBase + valence_rating;
        Trig = sendTrigger(Trig, codeResp);
        Results = logTrigger(Results, trial, 'valence_response', codeResp);

        eyelinkMsg(EL, 'PHASE_VALENCE_RESPONSE B%d H%s', P.blockNum, P.datasetHash);
        eyelinkMsg(EL, 'VALENCE_RESP %d', valence_rating);
        eyelinkMsg(EL, 'VALENCE_CODE %d', codeResp);
    end

    Results.Trials(trial).ImageIndex = random_order(trial);
    Results.Trials(trial).CueText    = cueText;
    Results.Trials(trial).Valence    = valence_rating;
    Results.Trials(trial).RT_Valence = rt_val;

    eyelinkMsg(EL, 'TRIAL_END %d', trial);
    eyelinkMsg(EL, 'TRIAL_RESULT 0');

    Screen('FillRect', S.win, cfg.col.bg);
    vbl = flipWithPhoto(S.win, S.drawPhotoOff);
    Results = logFlip(Results, trial, 'intertrial_blank', 0, vbl);
    WaitSecs(0.1);
end

WaitSecs(0.1);
if cfg.el.useEyelink && isfield(EL,'enabled') && EL.enabled && Eyelink('IsConnected')
    try
        Eyelink('StopRecording');
    catch MEel
        fprintf('[EyeLink] StopRecording failed: %s\n', MEel.message);
    end
end

if abortFlag
    Results.Meta.AbortedAt = P.stamp;
    save(abortFile,'Results','-v7.3');
    fprintf('Task aborted. Saved:\n%s\n', abortFile);
    finalizeAndExit(cfg, Trig, EL);
    return;
else
    [Results, Trig] = presentOnset(S.win, cfg, Results, Trig, EL, cfg.task.n_Trials+1, 'end_screen', ...
        @() DrawFormattedText(S.win, ['Experiment complete.' sprintf('\n\n') 'Thank you!'], 'center','center',cfg.col.grey), ...
        cfg.trig.codes.end_screen, S.drawPhotoOn, S.drawPhotoOff);

    KbStrokeWait;
    Results.Meta.CompletedAt = P.stamp;
    save(finalFile,'Results','-v7.3');
    fprintf('Results saved:\n%s\n', finalFile);

    finalizeAndExit(cfg, Trig, EL);
    return;
end

catch ME
    Results.Meta.Error.message = ME.message;
    Results.Meta.Error.stack   = ME.stack;
    Results.Meta.Error.when    = P.stamp;
    save(abortFile,'Results','ME','-v7.3');
    fprintf('ERROR -> saved abort:\n%s\n', abortFile);

    finalizeAndExit(cfg, Trig, EL);
    rethrow(ME);
end
end

function cfg = validate_cfg(cfg)
requiredFields = {'imagesDir','scalesDir','resultsDir'};
for i = 1:numel(requiredFields)
    f = requiredFields{i};
    if ~isfield(cfg,'paths') || ~isfield(cfg.paths,f) || isempty(cfg.paths.(f))
        error('cfg.paths.%s must be set to a valid folder path.', f);
    end
    if exist(cfg.paths.(f), 'dir') ~= 7
        error('cfg.paths.%s does not exist: %s', f, cfg.paths.(f));
    end
end

if isfield(cfg,'el') && isfield(cfg.el,'useEyelink') && cfg.el.useEyelink
    if ~isfield(cfg.paths,'assetsDir') || isempty(cfg.paths.assetsDir)
        error('cfg.paths.assetsDir must be set when EyeLink is enabled.');
    end
    if exist(cfg.paths.assetsDir, 'dir') ~= 7
        error('cfg.paths.assetsDir does not exist: %s', cfg.paths.assetsDir);
    end
end

ensure_dir(cfg.paths.resultsDir);
end
