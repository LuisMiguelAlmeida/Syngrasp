% This function checks whether or not passed parameter is an object

function iso = SGisObject(obj)

iso = (isfield(obj,'cp') && isfield(obj,'center') && ...
    isfield(obj,'normals') && isfield(obj,'base') && ...
    isfield(obj,'Kc') && isfield(obj,'H') && ...
    isfield(obj,'G'));

end