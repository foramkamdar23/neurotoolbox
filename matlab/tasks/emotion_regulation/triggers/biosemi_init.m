function Trig = biosemi_init(trigCfg)
% BIOSEMI_INIT
% - If useTriggers=false: Trig.enabled=false, Trig.dummy=false (no triggers by design)
% - If COM init fails:
%     * allowDummy=false -> ERROR (stop task)
%     * allowDummy=true  -> Trig.dummy=true + DummyReason, continue without triggers

Trig = struct();
Trig.enabled      = false;
Trig.dummy        = false;
Trig.dummyReason  = '';
Trig.sp           = [];
Trig.useLegacy    = false;

Trig.pulseWidthSec = trigCfg.pulseWidthSec;
Trig.lowVal        = trigCfg.lowVal;
Trig.codes         = trigCfg.codes;

if ~trigCfg.useTriggers
    fprintf('[BioSemi] Triggers disabled by cfg.trig.useTriggers=false.\n');
    return;
end

try
    [Trig.sp, Trig.useLegacy] = initBiosemiSerial( ...
        trigCfg.portName, trigCfg.baudRate, trigCfg.dataBits, trigCfg.stopBits, trigCfg.parity, trigCfg.lowVal);
    Trig.enabled = true;
    fprintf('[BioSemi] ENABLED on %s\n', trigCfg.portName);

catch ME
    Trig.enabled = false;
    Trig.dummy   = trigCfg.allowDummy;

    Trig.dummyReason = sprintf('COM init failed on %s: %s', trigCfg.portName, ME.message);

    if Trig.dummy
        warning('[BioSemi] %s -> continuing in DUMMY trigger mode.', Trig.dummyReason);
    else
        error('[BioSemi] %s -> aborting because cfg.trig.allowDummy=false.', Trig.dummyReason);
    end
end
end
