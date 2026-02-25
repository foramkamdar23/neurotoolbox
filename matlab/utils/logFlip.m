function Results = logFlip(Results, trial, phase, sensorOn, vbl)
k = numel(Results.FlipLog) + 1;
Results.FlipLog(k).trial    = trial;
Results.FlipLog(k).phase    = phase;
Results.FlipLog(k).sensorOn = sensorOn;
Results.FlipLog(k).vbl      = vbl;
end

