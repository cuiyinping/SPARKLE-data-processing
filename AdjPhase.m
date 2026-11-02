function [signals] = AdjPhase(signal, phase)
if nargin == 0
    error('No data...')
else
end
signals = signal * exp(i * phase);
end
