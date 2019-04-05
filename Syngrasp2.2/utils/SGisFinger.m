% This function checks whether or not passed parameter is a finger

function isf = SGisFinger(finger)

isf = (isfield(finger,'DHpars') && isfield(finger,'base') && ...
    isfield(finger,'q') && isfield(finger,'qin') && ...
    isfield(finger,'n'));

end