# neuro_toolbox

Reusable MATLAB-first toolbox for neuro/psych tasks, device IO (triggers, EyeLink, photodiode), and common helpers. This repo is meant to be used as a local toolbox and imported into study-specific projects.

## Add paths (MATLAB)
```
add_toolbox_paths
```
This adds `neuro_toolbox/matlab` and all subfolders to the MATLAB path.

## Emotion Regulation task
Minimal example:
```
cfg = cfg_emoreg_defaults();

% Required paths (set these in your study repo)
cfg.paths.imagesDir  = '/path/to/stimuli/images';
cfg.paths.scalesDir  = '/path/to/sam_scales';
cfg.paths.resultsDir = '/path/to/results';
cfg.paths.assetsDir  = '/path/to/neuro_toolbox/assets';

Results = task_emoreg_run(cfg);
```

## Triggers (BrainProducts / BioSemi / none)
Trigger behavior is config-driven via `cfg.trig` and implemented in `hardware/`.

### Required fields
```
cfg.trig.system = 'brainproducts'; % 'biosemi' | 'none'
cfg.trig.port = 'COM22';
cfg.trig.baud = 2000000;
cfg.trig.pulseWidth = 0.005;
```

### Initialization and usage
```
cfg = config_triggers(cfg);
Trig = trigger_init(cfg);

[vbl] = Screen('Flip', win);
sendTrigger(Trig, code, cfg.trig.pulseWidth);

trigger_close(Trig);
```

### BrainProducts TriggerBox Plus
Uses `IOPort` with `BaudRate=2000000`, writes `uint8` codes (0-255), and resets to 0 after each pulse.

### BioSemi
Uses `io64` with the configured parallel port address and resets to 0 after each pulse.

### Stimuli location
The task expects image stimuli under:
- `cfg.paths.imagesDir/<image_dataset_id>/1.jpg ... N.jpg`

SAM scale images should be placed under:
- `cfg.paths.scalesDir` (default file name: `9 scale sam.jpg`)

### Outputs
Results and EDF files are written to `cfg.paths.resultsDir`.
The local `outputs/` folder is ignored by `.gitignore`. Raw data should never be committed to version control.
