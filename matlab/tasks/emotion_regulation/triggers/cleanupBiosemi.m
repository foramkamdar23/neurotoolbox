function cleanupBiosemi(Trig)
if ~isfield(Trig,'enabled') || ~Trig.enabled
    return;
end
try
    if Trig.useLegacy
        fwrite(Trig.sp, Trig.lowVal);
        fclose(Trig.sp);
        delete(Trig.sp);
    else
        write(Trig.sp, Trig.lowVal, 'uint8');
    end
catch
end
end
