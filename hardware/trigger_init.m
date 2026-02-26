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
        if ~isfield(cfg.trig, 'address') || isempty(cfg.trig.address)
            error('trigger_init:MissingAddress', 'cfg.trig.address is required for BioSemi.');
        end
        if ~isfield(cfg.trig, 'pulseWidth') || isempty(cfg.trig.pulseWidth)
            error('trigger_init:MissingPulseWidth', 'cfg.trig.pulseWidth is required.');
        end

        Trig.address = cfg.trig.address;
        Trig.pulseWidth = cfg.trig.pulseWidth;

        Trig.handle = io64;
        status = io64(Trig.handle);
        if status ~= 0
            error('trigger_init:IO64InitFailed', 'io64 failed to initialize (status=%d).', status);
        end

    case 'none'
        % No hardware initialization required.

    otherwise
        error('trigger_init:InvalidSystem', 'Unknown trigger system: %s', cfg.trig.system);
end
end
