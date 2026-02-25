function eyelinkMsg(EL, fmt, varargin)
% Safe wrapper: only sends if EyeLink is actually enabled (not dummy)
try
    if isfield(EL,'enabled') && EL.enabled
        Eyelink('Message', sprintf(fmt, varargin{:}));
    end
catch
end
end
