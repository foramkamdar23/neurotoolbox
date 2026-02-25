function PicDB = loadImagesAsTextures(win, cfg, xc, yc)
n = cfg.task.n_Trials;
PicDB = struct();

scaledX = cfg.task.Stimulus_size_x * cfg.scale.image;
halfX   = scaledX/2;

for ii = 1:n
    imgPath = fullfile(cfg.paths.imagesDir, cfg.task.image_dataset_id, sprintf('%d.jpg', ii));
    if ~exist(imgPath,'file')
        error('Missing image: %s', imgPath);
    end

    im = imread(imgPath);
    sz = size(im);
    imW = sz(2); imH = sz(1);
    ratio_xy = imW / imH;

    fittedH = scaledX / ratio_xy;
    halfH   = round(fittedH/2);

    PicDB(ii).tex = Screen('MakeTexture', win, im);
    PicDB(ii).pos = [xc-halfX, yc-halfH, xc+halfX, yc+halfH];
end
end
