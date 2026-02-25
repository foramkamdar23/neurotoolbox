function ensure_dir(dirPath)
if exist(dirPath,'dir')
    return;
end
[ok,msg] = mkdir(dirPath);
if ~ok
    error('Failed to create directory: %s (%s)', dirPath, msg);
end
end
