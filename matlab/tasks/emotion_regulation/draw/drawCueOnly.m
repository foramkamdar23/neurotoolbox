function drawCueOnly(win, cueText, color, cfg)
baseSize = 60;
cueSize  = round(baseSize * cfg.scale.cue);
oldSize  = Screen('TextSize',  win, cueSize);
oldStyle = Screen('TextStyle', win, 1);
DrawFormattedText(win, cueText, 'center', 'center', color);
Screen('TextSize',  win, oldSize);
Screen('TextStyle', win, oldStyle);
end

