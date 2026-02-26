function Trig = trigger_init(cfg)
%TRIGGER_INIT Initialize trigger system based on cfg.trig.

if ~isfield(cfg, 'trig')
    error('trigger_init:MissingConfig', 'cfg.trig is required.');
end
if ~isfield(cfg.trig, 'system')
    error('trigger_init:MissingSystem', 'cfg.trig.system is required.');
end

validSystems = {'brainproducts', 'biosemi', 'none'};
if ~ismember(lower(cfg.trig.system), validSystems)
    error('trigger_init:InvalidSystem', 'Invalid trigger system specified.');
end

Trig = struct();
Trig.system = lower(cfg.trig.system);
Trig.handle = [];

switch Trig.system
    case 'brainproducts'
        if ~isfield(cfg.trig, 'port') || isempty(cfg.trig.port)
            error('trigger_init:MissingPort', 'cfg.trig.port is required for BrainProducts.');
        end
        if ~isfield(cfg.trig, 'baud') || isempty(cfg.trig.baud)
            error('trigger_init:MissingBaud', 'cfg.trig.baud is required for BrainProducts.');
        end
        if ~isfield(cfg.trig, 'pulseWidth') || isempty(cfg.trig.pulseWidth)
            error('trigger_init:MissingPulseWidth', 'cfg.trig.pulseWidth is required.');
        end

        Trig.port = cfg.trig.port;
        Trig.baud = cfg.trig.baud;
        Trig.pulseWidth = cfg.trig.pulseWidth;

        try
            Trig.handle = IOPort('OpenSerialPort', Trig.port, sprintf('BaudRate=%d', Trig.baud));
            % Ensure port is low on init.
            IOPort('Write', Trig.handle, uint8(0));
        catch ME
            error('trigger_init:OpenSerialFailed', ...
                'Failed to open serial port %s for BrainProducts TriggerBox Plus: %s', ...
                Trig.port, ME.message);
        end

   case 'biosemi'
        % BioSemi triggers in your lab are serial/COM based (not io64/LPT).
        if ~isfield(cfg.trig,'port') || isempty(cfg.trig.port)
            error('trigger_init:MissingPort', 'cfg.trig.port is required for BioSemi (serial).');
        end
        if ~isfield(cfg.trig,'baud') || isempty(cfg.trig.baud)
            % Use what worked before in your old code (often 115200)
            cfg.trig.baud = 115200;
        end
        if ~isfield(cfg.trig,'pulseWidth') || isempty(cfg.trig.pulseWidth)
            error('trigger_init:MissingPulseWidth', 'cfg.trig.pulseWidth is required.');
        end
        if ~isfield(cfg.trig,'lowVal') || isempty(cfg.trig.lowVal)
            cfg.trig.lowVal = 0;
        end
    
        Trig.port      = cfg.trig.port;
        Trig.baud      = cfg.trig.baud;
        Trig.pulseWidth= cfg.trig.pulseWidth;
        Trig.lowVal    = uint8(cfg.trig.lowVal);
    
        try
            Trig.handle = IOPort('OpenSerialPort', Trig.port, sprintf('BaudRate=%d', Trig.baud));
            % Ensure low on init
            IOPort('Write', Trig.handle, uint8(Trig.lowVal));
        catch ME
            error('trigger_init:OpenSerialFailed', ...
                'Failed to open serial port %s for BioSemi (serial): %s', ...
                Trig.port, ME.message);
        end

    case 'none'
        % No hardware initialization required.

    otherwise
        error('trigger_init:InvalidSystem', 'Unknown trigger system: %s', cfg.trig.system);
end
end
