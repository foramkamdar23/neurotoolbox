function add_toolbox_paths()
% ADD_TOOLBOX_PATHS
% Adds neuro_toolbox/matlab and subfolders to the MATLAB path.

thisFile = mfilename('fullpath');
startupDir = fileparts(thisFile);
matlabDir = fileparts(startupDir);
toolboxRoot = fileparts(matlabDir);

addpath(genpath(fullfile(toolboxRoot, 'matlab')));
end
