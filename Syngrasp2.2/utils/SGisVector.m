function isv = SGisVector( input )

isv = (strcmp(class(input),'double') && (length(size(input)) == 2) && ...
    (size(input,1) == 1 || size(input,2) == 1) && ~isscalar(input));

end

