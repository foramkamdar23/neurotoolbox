function [Results, Trig] = presentOnset(win, cfg, Results, Trig, EL, trial, phase, drawStimFn, trigCode, drawPhotoOn, drawPhotoOff)
vbl_on = multiFramePulse(win, drawStimFn, drawPhotoOn, drawPhotoOff, cfg.photo.pulseFrames);

Results = logFlip(Results, trial, phase, 1, vbl_on);
Results = logPhoto(Results, trial, phase, vbl_on, cfg.photo);

if ~isempty(trigCode) && ~isnan(trigCode)
    Trig = sendTrigger(Trig, trigCode);
    Results = logTrigger(Results, trial, phase, trigCode);
end

eyelinkMsg(EL, 'PHASE_%s', upper(phase));
end
