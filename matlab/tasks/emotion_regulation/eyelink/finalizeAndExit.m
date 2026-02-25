function finalizeAndExit(cfg, Trig, EL)

% ---------- EyeLink cleanup (ONLY if enabled + connected) ----------
try
    eyelinkShouldRun = isfield(cfg,'el') && isfield(cfg.el,'useEyelink') && cfg.el.useEyelink;
    eyelinkConnected = false;

    if eyelinkShouldRun
        try
            eyelinkConnected = (Eyelink('IsConnected') == 1);
        catch
            eyelinkConnected = false;
        end
    end

    if eyelinkShouldRun && eyelinkConnected
        % If not dummy:
        if isfield(EL,'dummymode') && EL.dummymode == 0
            try, Eyelink('StopRecording'); catch, end
            try, Eyelink('SetOfflineMode'); WaitSecs(0.05); catch, end
            try, Eyelink('Command','clear_screen 0'); WaitSecs(0.05); catch, end
            try, Eyelink('CloseFile'); WaitSecs(0.2); catch, end

            % Receive EDF
            try
                if ~exist(cfg.paths.resultsDir,'dir'), mkdir(cfg.paths.resultsDir); end
                status = Eyelink('ReceiveFile', EL.edfFile, cfg.paths.resultsDir, 1);
                if status > 0
                    fprintf('[EyeLink] EDF received: %s (%.1f KB)\n', ...
                        fullfile(cfg.paths.resultsDir,[EL.edfFile '.edf']), status/1024);
                else
                    fprintf('[EyeLink] EDF receive status: %d\n', status);
                end
            catch MErecv
                fprintf('[EyeLink] ReceiveFile error: %s\n', MErecv.message);
            end
        end

        try, Eyelink('Shutdown'); catch, end
    end
catch MEel
    fprintf('[EyeLink] Cleanup error: %s\n', MEel.message);
end

% ---------- BioSemi cleanup ----------
cleanupBiosemi(Trig);

% ---------- Audio cleanup ----------
try
    if isfield(EL,'pahandle') && ~isempty(EL.pahandle), PsychPortAudio('Close', EL.pahandle); end
    if isfield(EL,'pamaster') && ~isempty(EL.pamaster), PsychPortAudio('Close', EL.pamaster); end
catch
end

% ---------- Screen cleanup ----------
try, Screen('CloseAll'); catch, end

end
