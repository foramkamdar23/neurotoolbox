function Valence = loadValenceScale(win, cfg, xc, yc)
valPath = fullfile(cfg.paths.scalesDir, cfg.files.valencePNG);
if ~exist(valPath,'file')
    error('Missing SAM scale: %s', valPath);
end

img  = imread(valPath);
info = imfinfo(valPath);

Valence.tex = Screen('MakeTexture', win, img);
w = info.Width  * cfg.scale.ratingscale;
h = info.Height * cfg.scale.ratingscale;

rect = [0 0 w h];
Valence.pos = CenterRectOnPoint(rect, xc, yc);
end
