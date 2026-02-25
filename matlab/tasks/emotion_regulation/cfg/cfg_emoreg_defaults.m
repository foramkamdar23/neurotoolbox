function cfg = cfg_emoreg_defaults()
% CFG_EMOREG_DEFAULTS
% Returns a config struct with safe defaults and no machine-specific paths.

cfg = struct();

% --- Paths (set these in your study repo) ---
cfg.paths = struct();
cfg.paths.imagesDir  = '';
cfg.paths.scalesDir  = '';
cfg.paths.resultsDir = '';
cfg.paths.assetsDir  = '';

% --- Task settings ---
cfg.task.n_Trials         = 24;
cfg.task.image_dataset_id = 'block5';
cfg.task.Stimulus_size_x  = 750;

cfg.timing.fixBase    = 0.5;
cfg.timing.cue_time   = 2.0;
cfg.timing.image_time = 3.0;
cfg.timing.rating_max = 15;

% --- Visual scaling ---
cfg.scale.fixation    = 2.0;
cfg.scale.cue         = 2.0;
cfg.scale.ratingscale = 2.0;
cfg.scale.image       = 2.0;

% --- Colors ---
cfg.col.bg    = 0;
cfg.col.grey  = [170 170 170];
cfg.col.white = [255 255 255];

% --- Screen ---
cfg.screen.screenNumber = 2;
cfg.screen.textSize     = 100;
cfg.screen.skipSync     = 1;

% --- Photodiode ---
cfg.photo.sizePx      = 120;
cfg.photo.marginPx    = 20;
cfg.photo.onCol       = cfg.col.white;
cfg.photo.offCol      = 0;
cfg.photo.pulseFrames = 2;

% --- Keys ---
cfg.keys.useNumpad = true;
cfg.keys.esc       = 'ESCAPE';

% --- BioSemi triggers ---
cfg.trig.useTriggers   = true;
cfg.trig.allowDummy    = false;
cfg.trig.portName      = 'COM7';
cfg.trig.baudRate      = 115200;
cfg.trig.dataBits      = 8;
cfg.trig.stopBits      = 1;
cfg.trig.parity        = 'none';
cfg.trig.lowVal        = uint8(0);
cfg.trig.pulseWidthSec = 0.010;

cfg.trig.codes.intro1           = 1;
cfg.trig.codes.intro2           = 2;
cfg.trig.codes.fix1             = 11;
cfg.trig.codes.cue              = 20;
cfg.trig.codes.fix2             = 12;
cfg.trig.codes.image            = 30;
cfg.trig.codes.fix3             = 13;
cfg.trig.codes.valence_onset    = 40;
cfg.trig.codes.valence_respBase = 50;
cfg.trig.codes.end_screen       = 99;

% --- EyeLink ---
cfg.el.useEyelink     = true;
cfg.el.dummymode      = 0;
cfg.el.calType        = 'HV9';
cfg.el.calTargetImage = 'fixTarget.jpg';

% --- Stimuli files ---
cfg.files.valencePNG = '9 scale sam.jpg';

% --- Cue options ---
cfg.cue.options = {'Feel freely', 'Tone down'};
end
