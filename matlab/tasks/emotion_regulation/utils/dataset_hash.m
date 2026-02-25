function h = dataset_hash(datasetId)
% DATASET_HASH
% Short stable hash (6 hex chars) for messages/EDF naming.

md = java.security.MessageDigest.getInstance('MD5');
md.update(uint8(datasetId));
raw = typecast(md.digest(),'uint8');
hex = lower(reshape(dec2hex(raw,2).',1,[]));
h = hex(1:6);
end
