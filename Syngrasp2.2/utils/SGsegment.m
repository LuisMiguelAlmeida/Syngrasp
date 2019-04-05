function struct = SGsegment(p0,p1)
if (size(p0,1) == 1)
    p0 = p0';
end
if (size(p1,1) == 1)
    p1 = p1';
end

struct.type = 'seg';
struct.p0 = p0;
struct.p1 = p1;

end