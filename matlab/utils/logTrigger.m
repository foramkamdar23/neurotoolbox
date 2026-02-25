
function Results = logTrigger(Results, trial, phase, code)
k = numel(Results.TriggerLog) + 1;
Results.TriggerLog(k).trial    = trial;
Results.TriggerLog(k).phase    = phase;
Results.TriggerLog(k).code     = code;
Results.TriggerLog(k).tGetSecs = GetSecs;
end
