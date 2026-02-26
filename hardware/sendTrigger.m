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
    case 'brainproducts'
        % Write code, wait, then reset to 0.
        IOPort('Write', Trig.handle, uint8(code));
        WaitSecs(pulseWidth);
        IOPort('Write', Trig.handle, uint8(0));

    case 'biosemi'
        io64(Trig.handle, Trig.address, code);
        WaitSecs(pulseWidth);
        io64(Trig.handle, Trig.address, 0);

    case 'none'
        % No-op.

    otherwise
        error('sendTrigger:InvalidSystem', 'Unknown trigger system: %s', Trig.system);
end
end
