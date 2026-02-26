addpath('C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\matlab\startup');
add_toolbox_paths;

cfg = cfg_emoreg_defaults();

% ===== SELECT TRIGGER SYSTEM =====
cfg.trig.system = 'brainproducts';   % 'biosemi' OR 'brainproducts'
cfg.trig.port = 'COM4';        % Confirm in Device Manager
cfg.trig.baud = 2000000;           % REQUIRED for TriggerBox Plus
cfg.trig.useTriggers = true;
cfg.trig.allowDummy  = false;
cfg.trig.pulseWidth = 0.005;    % 5 ms pulse

% ===== PATHS =====
cfg.paths.imagesDir  = 'C:\Users\cns-co-admin\Desktop\fk\emotion_regulation_task\Images';
cfg.paths.scalesDir  = 'C:\Users\cns-co-admin\Desktop\fk\emotion_regulation_task\SAM-Scales';
cfg.paths.resultsDir = 'C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\outputs';
cfg.paths.assetsDir  = 'C:\Users\cns-co-admin\Desktop\fk\neurotoolbox\assets';


% ===== EYELINK =====
cfg.el.useEyelink = false;

% ===== SCREEN =====
cfg.screen.screenNumber = 2;

Results = task_emoreg_run(cfg);

% 
% %%
% Trig = trigger_init(cfg);
% 
% codes = [1 11 30 40 99];
% 
% fprintf('\n=== BRAINPRODUCTS SMOKE TEST ===\n');
% 
% for i = 1:length(codes)
%     fprintf('Sending trigger %d\n', codes(i));
%     sendTrigger(Trig, codes(i), cfg.trig.pulseWidthSec);
%     WaitSecs(1);
% end
% 
% trigger_close(Trig);
% 
% 
% 
% %%
% 
% Trig = trigger_init(cfg);
% sendTrigger(Trig, 30, 0.005);
% trigger_close(Trig);