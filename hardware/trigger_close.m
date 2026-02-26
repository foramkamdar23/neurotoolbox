function trigger_close(Trig)
%TRIGGER_CLOSE Cleanly close trigger resources.

if isempty(Trig) || ~isfield(Trig, 'system')
    return;
end

switch lower(Trig.system)
    case 'brainproducts'
        if isfield(Trig, 'handle') && ~isempty(Trig.handle)
            IOPort('Close', Trig.handle);
        end

    case 'biosemi'
        % No explicit shutdown required for io64.

    case 'none'
        % No-op.

    otherwise
        error('trigger_close:InvalidSystem', 'Unknown trigger system: %s', Trig.system);
end
end
