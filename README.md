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

### Stimuli location
The task expects image stimuli under:
- `cfg.paths.imagesDir/<image_dataset_id>/1.jpg ... N.jpg`

SAM scale images should be placed under:
- `cfg.paths.scalesDir` (default file name: `9 scale sam.jpg`)

### Outputs
Results and EDF files are written to `cfg.paths.resultsDir`.
The local `outputs/` folder is ignored by `.gitignore`. Raw data should never be committed to version control.
