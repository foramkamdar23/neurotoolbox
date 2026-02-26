function cfg = config_triggers(cfg)
%CONFIG_TRIGGERS Populate cfg.trig defaults and validate required fields.

if nargin < 1 || isempty(cfg)
    cfg = struct();
end
if ~isfield(cfg, 'trig') || isempty(cfg.trig)
    cfg.trig = struct();
end

if ~isfield(cfg.trig, 'system') || isempty(cfg.trig.system)
    cfg.trig.system = 'none';
end
if ~isfield(cfg.trig, 'baud') || isempty(cfg.trig.baud)
    cfg.trig.baud = 2000000;
end
if ~isfield(cfg.trig, 'pulseWidth') || isempty(cfg.trig.pulseWidth)
    cfg.trig.pulseWidth = 0.005;
end

switch lower(cfg.trig.system)
    case 'brainproducts'
        if ~isfield(cfg.trig, 'port') || isempty(cfg.trig.port)
            error('config_triggers:MissingPort', 'cfg.trig.port is required for BrainProducts.');
        end

    case 'biosemi'
        if ~isfield(cfg.trig, 'address') || isempty(cfg.trig.address)
            error('config_triggers:MissingAddress', 'cfg.trig.address is required for BioSemi.');
        end

    case 'none'
        % No additional requirements.

    otherwise
        error('config_triggers:InvalidSystem', 'Unknown trigger system: %s', cfg.trig.system);
end
end
