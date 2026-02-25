function escPressed = waitWithEsc(durationSec, escKey)
escPressed = false;
t0 = GetSecs;
while GetSecs - t0 < durationSec
    [down, ~, kc] = KbCheck;
    if down && kc(escKey)
        escPressed = true;
        KbReleaseWait;
        return;
    end
end
end

