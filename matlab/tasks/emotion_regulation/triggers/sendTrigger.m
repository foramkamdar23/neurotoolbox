function Trig = sendTrigger(Trig, code)
% SENDTRIGGER
% No-op if triggers disabled OR in dummy mode.

if ~isfield(Trig,'enabled') || ~Trig.enabled
    return;
end
if isfield(Trig,'dummy') && Trig.dummy
    return;
end

try
    val = uint8(code);
    if Trig.useLegacy
        fwrite(Trig.sp, val);
        pause(Trig.pulseWidthSec);
        fwrite(Trig.sp, Trig.lowVal);
    else
        write(Trig.sp, val, 'uint8');
        pause(Trig.pulseWidthSec);
        write(Trig.sp, Trig.lowVal, 'uint8');
    end
catch ME
    warning('Task:BioSemiSendTrigger', ...
        'Error sending trigger %d: %s. Disabling triggers.', code, ME.message);
    Trig.enabled = false;
end
end
