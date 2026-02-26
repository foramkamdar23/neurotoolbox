function add_toolbox_paths()
% ADD_TOOLBOX_PATHS
% Adds entire neurotoolbox to MATLAB path (excluding .git)

thisFile = mfilename('fullpath');
startupDir = fileparts(thisFile);
matlabDir = fileparts(startupDir);
toolboxRoot = fileparts(matlabDir);

addpath(genpath(toolboxRoot));

fprintf('Neurotoolbox paths added from: %s\n', toolboxRoot);

end