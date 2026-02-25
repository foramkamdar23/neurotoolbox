function edf = makeEdfName(subjId, sess, cond, blockNum, datasetHash, resultsDir)
% makeEdfName
% Build an EyeLink-safe EDF name (<= 8 chars, starts with a letter),
% using:
%   - subjId like 'k01' or 'f01'
%   - session (0-9)
%   - block number (0-9)
%   - datasetHash (string) -> used only for suffix seed if needed
% Collision avoidance:
%   - checks local resultsDir for existing .edf
%   - never overwrites: appends suffix A..Z..0..9

    if nargin < 6 || isempty(resultsDir)
        resultsDir = pwd;
    end

    % ---- sanitize subject id: keep only A-Z0-9, uppercase
    subj = upper(char(subjId));
    subj = regexprep(subj, '[^A-Z0-9]', '');

    % EDF should start with a LETTER; if user starts with digit, prefix 'S'
    if isempty(subj)
        subj = 'S00';
    elseif ~isletter(subj(1))
        subj = ['S' subj];
    end

    % Keep at most 3 chars for subject chunk (e.g., K01)
    subj = padOrTrim(subj, 3);

    % Session + Block (1 digit each)
    s1 = oneDigit(sess);
    b1 = oneDigit(blockNum);

    % Base EDF without suffix: 3 + 1 + 1 = 5 chars
    base = [subj 'S' s1 'B' b1];  % -> e.g., K01S1B1 (7 chars)
    % Actually: subj(3) + 'S'(1) + s1(1) + 'B'(1) + b1(1) = 7 chars

    % We have 1 char left for collision suffix (8th char)
    suffixes = ['A':'Z' '0':'9'];  % 36 options

    % Optional: choose a starting point based on hash so different datasets spread out
    startIdx = 1;
    if nargin >= 5 && ~isempty(datasetHash)
        startIdx = 1 + mod(simpleHash(datasetHash), numel(suffixes));
    end

    % Try base+suffixes in rotated order
    for k = 0:numel(suffixes)-1
        idx = 1 + mod((startIdx-1) + k, numel(suffixes));
        cand = [base suffixes(idx)]; %#ok<AGROW>

        % local collision check (case-insensitive on Windows anyway)
        if ~existsEdfLocal(resultsDir, cand)
            edf = cand;
            return;
        end
    end

    error('Could not find a unique EDF name after trying %d suffixes.', numel(suffixes));
end

% ----------------- helpers -----------------

function out = padOrTrim(str, n)
    if numel(str) >= n
        out = str(1:n);
    else
        out = [str repmat('0', 1, n-numel(str))];
    end
end

function d = oneDigit(x)
    if isnan(x), x = 0; end
    x = round(x);
    x = mod(x, 10);
    d = char('0' + x);
end

function tf = existsEdfLocal(resultsDir, edfBase)
    tf = false;
    if ~exist(resultsDir, 'dir'), return; end
    % check both with and without extension
    f1 = fullfile(resultsDir, [edfBase '.edf']);
    f2 = fullfile(resultsDir, [edfBase '.EDF']);
    tf = exist(f1,'file') == 2 || exist(f2,'file') == 2;
end

function h = simpleHash(s)
    s = char(s);
    s = double(s(:));
    h = 0;
    for i = 1:numel(s)
        h = mod(h*131 + s(i), 2^31-1);
    end
end
