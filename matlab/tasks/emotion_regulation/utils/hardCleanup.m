function hardCleanup()
try, sca; catch, end
try, ListenChar(0); catch, end
try, Eyelink('Shutdown'); catch, end
end
