function sp_dp = dephase_fun(sp_ft,phc0,phc1)
% function sp_dp = dephase_fun(sp_ft,phc0,phc1)
% written by Chen Li
% input:   sp_ft - complex data after fourier transform
%         phc0  - the zero order phase correction
%         phc1  - the first order phase correction
% output:  sp_dp - spectral data after phase correction
for xxx=0:0.0001:10000;
    xxxx=1;
end
global k
x1=0:1:k-1;
rp=-93.9;
lp=-81.3;
phc0=-93.9;
phc1=-81.3;
th=(phc0+x1.*phc1/k)*pi/180;
spr=real(sp_ft).*cos(th)-imag(sp_ft).*sin(th);
spi=real(sp_ft).*sin(th)+imag(sp_ft).*cos(th);
sp_dp=spr+j*spi;

