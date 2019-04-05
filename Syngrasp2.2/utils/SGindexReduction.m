%index remapping function: (FOR FUNCTION SGintSegCube ONLY!!!)
%i = 1  2  3  4  |5  6  7  8  |9  10 11 12 |13 14 15 16 |17 18 19 20 |21 22 23 24
%j = 1  1  1  1  |2  2  2  2  |3  3  3  3  |4  4  4  4  |5  5  5  5  |6  6  6  6

function j = SGindexReduction(i)
j = 1 + floor((i-1) ./ 4);
end