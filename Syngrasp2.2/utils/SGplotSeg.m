function SGplotSeg(seg)
X = [seg.p0(1),seg.p1(1)];
Y = [seg.p0(2),seg.p1(2)];
Z = [seg.p0(3),seg.p1(3)];
line(X,Y,Z)
end