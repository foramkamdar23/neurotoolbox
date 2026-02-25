function drawFixation(win, centerXY, color, cfg)
baseArm = 40; baseThick = 4;
arm   = baseArm   * cfg.scale.fixation;
thick = baseThick * cfg.scale.fixation;
coords = [[-arm arm 0 0]; [0 0 -arm arm]];
Screen('DrawLines', win, coords, thick, color, centerXY);
end

