function pen=SGdrawPen(H,h,rad,res)

pen = SGpen(H,h,rad,res);

hold on
grid on

surf(pen.Xc,pen.Yc,pen.Zc)
surf(pen.Xt,pen.Yt,pen.Zt)
end