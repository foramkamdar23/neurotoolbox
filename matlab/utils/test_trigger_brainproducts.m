cfg = struct();
cfg.trig.system = 'brainproducts';
cfg.trig.port = 'COM22';
cfg.trig.baud = 2000000;
cfg.trig.pulseWidth = 0.005;

Trig = trigger_init(cfg);

for i = 1:5
    sendTrigger(Trig, i, 0.005);
    WaitSecs(1);
end

trigger_close(Trig);
