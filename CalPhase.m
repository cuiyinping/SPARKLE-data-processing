function [signals,p] = CalPhase(signal)
if nargin == 0
    error('No data...')
else
end
count = 0;
phasesave = [];
for phase = -2*pi:0.005:2*pi
    count = count + 1;
    s2 = signal*exp(i*phase);
    signalfft = fftshift(fft(s2));
    phasesave(1,count) = phase;
    phasesave(2,count) = min(real(signalfft));
end
p = phasesave(1, find(phasesave(2,:) == max(phasesave(2,:))));
signals = signal*exp(i*p);
end