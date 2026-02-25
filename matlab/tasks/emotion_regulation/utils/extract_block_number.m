function b = extract_block_number(datasetId)
% Extracts digits from e.g. "block1" -> 1, "fk_subset2" -> 2, else 0
tok = regexp(datasetId, '(\d+)', 'tokens', 'once');
if isempty(tok)
    b = 0;
else
    b = str2double(tok{1});
end
end
