

function vbl_on = multiFramePulse(win, drawStimFn, drawPhotoOn, drawPhotoOff, pulseFrames)
vbl_on = NaN;
for f = 1:pulseFrames
    drawStimFn();
    drawPhotoOn(win);
    vbl = Screen('Flip', win);
    if f == 1, vbl_on = vbl; end
end
drawStimFn();
drawPhotoOff(win);
Screen('Flip', win);
end

