%%BioSemi version
addpath('C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\matlab\startup');
add_toolbox_paths;

cfg = cfg_emoreg_defaults();

cfg.trig.system = 'biosemi';  % OR 'brainproducts'

cfg.paths.imagesDir  = 'C:\Users\cns-co-admin\Desktop\fk\emotion_regulation_task\Images';
cfg.paths.scalesDir  = 'C:\Users\cns-co-admin\Desktop\fk\emotion_regulation_task\SAM-Scales';
cfg.paths.resultsDir = 'C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\outputs';
cfg.paths.assetsDir  = 'C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\assets';

cfg.trig.portName = 'COM7';
cfg.trig.useTriggers = true;
cfg.trig.allowDummy  = false;
%cfg.trig.pulseWidthSec = 0.010;

cfg.el.useEyelink    = true;
cfg.screen.screenNumber = 0; 


%% BrainProducts version
addpath('C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\matlab\startup');
add_toolbox_paths;

cfg = cfg_emoreg_defaults();

% ===== SELECT TRIGGER SYSTEM =====
cfg.trig.system = 'brainproducts';   % 'biosemi' OR 'brainproducts'

% ===== PATHS =====
cfg.paths.imagesDir  = 'C:\Users\cns-co-admin\Desktop\fk\emotion_regulation_task\Images';
cfg.paths.scalesDir  = 'C:\Users\cns-co-admin\Desktop\fk\emotion_regulation_task\SAM-Scales';
cfg.paths.resultsDir = 'C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\outputs';
cfg.paths.assetsDir  = 'C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\assets';

% ===== TRIGGER SETTINGS =====
cfg.trig.portName = 'COM7';        % Confirm in Device Manager
cfg.trig.baud = 2000000;           % REQUIRED for TriggerBox Plus
cfg.trig.useTriggers = true;
cfg.trig.allowDummy  = false;
cfg.trig.pulseWidthSec = 0.005;    % 5 ms pulse

% ===== EYELINK =====
cfg.el.useEyelink = true;

% ===== SCREEN =====
cfg.screen.screenNumber = 0;