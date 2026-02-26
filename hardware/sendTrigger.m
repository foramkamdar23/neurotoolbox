function sendTrigger(Trig, code, pulseWidth)
%SENDTRIGGER Send a trigger code with a fixed pulse width.

if nargin < 2
    error('sendTrigger:MissingCode', 'Trigger code is required.');
end
if nargin < 3 || isempty(pulseWidth)
    if isfield(Trig, 'pulseWidth')
        pulseWidth = Trig.pulseWidth;
    else
        error('sendTrigger:MissingPulseWidth', 'pulseWidth is required.');
    end
end

switch lower(Trig.system)
    case {'brainproducts','biosemi'}
        low = uint8(0);
        if isfield(Trig,'lowVal') && ~isempty(Trig.lowVal)
            low = uint8(Trig.lowVal);
        end
        IOPort('Write', Trig.handle, uint8(code));
        WaitSecs(pulseWidth);
        IOPort('Write', Trig.handle, low);

    case 'none'
        % No-op.

    otherwise
        error('sendTrigger:InvalidSystem', 'Unknown trigger system: %s', Trig.system);
end
end
