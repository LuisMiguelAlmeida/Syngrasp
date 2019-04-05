% This function checks whether or not passed parameter is a hand

function iss = SGisSeg(seg)

iss = (isfield(seg,'p0') && isfield(seg,'p1') && ...
    isfield(seg,'type') && strcmp(seg.type,'seg'));

end