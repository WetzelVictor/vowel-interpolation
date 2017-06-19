% [A, K, Res] = analysis(sig, Fe, p, win, over)
%   Auto-regressive analysis with Yule-Walkers' method (LPC)
% 
% INPUT:
%   - sig: signal to be analysed 
%   - Fe: samplerate
%   - p : number of pole to perform analysis with (default: 1 + floor(Fe/1000))
%   - win: window (default: 512 hamming window)
%   - over: overlap (default: 50%)
%
% OUTPUT:
%   - A: poles for each frame
%   - K: reflective coefficients
%   - Res: residual signal


function [A, K, Res] = analysis(sig, Fe, p, win, over)

%% Default value
if nargin < 3
  % window
  Nwin = 512;
  win = hamming(Nwin, 'periodic');
  %overlapp
  over = 0.5;
  %poles
  p = 1 + floor(Fe/1000); % number of LPC poles 
elseif nargin < 4
  % window
  Nwin = 512;
  win = hamming(Nwin, 'periodic');
  %overlapp
  over = 0.5;
elseif nargin < 5
  %overlapp
  over = 0.5;
  Nwin = length(win);
end

%% PRE-TREATMENT 
sig = 0.9*sig/max(abs(sig)); % normalize

% Preemphasis filter
preemph = [1 0.63];
sigf = filter(1,preemph,sig);

%% GLOBAL VARIABLES
N = length(sigf);
Nover = floor(over *Nwin);

%% POLE ANALYSIS
[A, E, K, F, Nframes] = lpcAnalysis(sigf, p, win, Fe);

%% RESIDUAL
Res = myFilter(sigf, A, 1, win, over);

end
