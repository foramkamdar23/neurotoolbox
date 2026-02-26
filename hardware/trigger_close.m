function trigger_close(Trig)
%TRIGGER_CLOSE Cleanly close trigger resources.

if isempty(Trig) || ~isfield(Trig, 'system')
    return;
end

switch lower(Trig.system)
    % case 'brainproducts'
    %     if isfield(Trig, 'handle') && ~isempty(Trig.handle)
    %         IOPort('Close', Trig.handle);
    %     end
    % 
    % case 'biosemi'
    %     if Trig.useLegacy
    %     fwrite(Trig.sp, Trig.lowVal);
    %     fclose(Trig.sp);
    %     delete(Trig.sp);
    %     else
    %     write(Trig.sp, Trig.lowVal, 'uint8');
    %     end
    
    case {'brainproducts','biosemi'}
    if isfield(Trig,'handle') && ~isempty(Trig.handle)
        try, IOPort('Close', Trig.handle); catch, end
    end
    case 'none'
        % No-op.

    otherwise
        error('trigger_close:InvalidSystem', 'Unknown trigger system: %s', Trig.system);
end
end
