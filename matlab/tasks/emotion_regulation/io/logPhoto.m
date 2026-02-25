
function Results = logPhoto(Results, trial, phase, vbl_on, photo)
j = numel(Results.PhotoLog) + 1;
Results.PhotoLog(j).trial       = trial;
Results.PhotoLog(j).phase       = phase;
Results.PhotoLog(j).vbl_on      = vbl_on;
Results.PhotoLog(j).pulseFrames = photo.pulseFrames;
Results.PhotoLog(j).rect        = photo.rect;
Results.PhotoLog(j).onRGB       = photo.onCol;
if isscalar(photo.offCol), offRGB = [photo.offCol photo.offCol photo.offCol];
else, offRGB = photo.offCol; end
Results.PhotoLog(j).offRGB      = offRGB;
end
