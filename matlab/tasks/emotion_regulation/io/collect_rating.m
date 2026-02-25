function [rating, rt, aborted] = collect_rating(valid_map, t0, max_t, escKey)
rating = NaN; rt = NaN; aborted = false;
while GetSecs - t0 <= max_t
    [keyIsDown, tKey, KeyCode] = KbCheck;
    if keyIsDown
        if KeyCode(escKey), aborted = true; KbReleaseWait; return; end
        pressed = find(KeyCode);
        if ~isempty(pressed)
            k = pressed(1);
            idx = find(valid_map(:,1) == k, 1);
            if ~isempty(idx), rating = valid_map(idx,2); end
            rt = tKey - t0;
            KbReleaseWait;
            return;
        end
    end
end
end
