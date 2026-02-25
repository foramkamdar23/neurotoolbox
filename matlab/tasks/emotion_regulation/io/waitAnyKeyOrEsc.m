function escPressed = waitAnyKeyOrEsc(escKey)
escPressed = false;
while true
    [down, ~, kc] = KbCheck;
    if down
        if kc(escKey), escPressed = true; end
        KbReleaseWait;
        return;
    end
end
end

