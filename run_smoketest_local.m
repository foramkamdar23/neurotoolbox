addpath('C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\matlab\startup');
add_toolbox_paths;

cfg = cfg_emoreg_defaults();

cfg.paths.imagesDir  = 'C:\Users\cns-co-admin\Desktop\fk\emotion_regulation_task\Images';
cfg.paths.scalesDir  = 'C:\Users\cns-co-admin\Desktop\fk\emotion_regulation_task\SAM-Scales';
cfg.paths.resultsDir = 'C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\outputs';
cfg.paths.assetsDir  = 'C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\assets';

cfg.trig.useTriggers = false;
cfg.el.useEyelink    = true;
%cfg.el.dummymode     = 1; 

Results = task_emoreg_run(cfg);