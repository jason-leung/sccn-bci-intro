function [S,T,w,b] = train_csp(EEG,Fs,mrk,wnd,f,nof,n)
% Train a CSP+LDA classifier
% [S,T,w,b] = train_csp(RawSignal, SampleRate, Markers, EpochWnd, SpectralFlt, FltNumber, FltLength)
%
% In:
%   RawSignal : raw data array [#samples x #channels]
%
%   SampleRate : sampling rate of the data, in Hz
%
%   Markers : marker channel (0 = no marker, 1 = first class, 2 = second class)
%
%   EpochWnd : time range of the epochs to extract relative to the marker
%              in seconds ([begin, end]), e.g. [0.5 3.5]
%
%   SpectralFlt : spectral filter specfication; this is a function of Frequency in Hz
%                 (e.g., f = @(x)x>7&x<30)
%
%   FltNumber : number of spatial filters pairs to compute (e.g., 3)
%
%   FltLength : length of the temporal filter, in samples (e.g., 200)
%
% Out:
%   S : spatial filter matrix [#channels x #filters]
%
%   T : temporal filter matrix [FltLength x FltLength]
%
%   w : linear classifier weights
%
%   b : linear classifier bias


% do frequency filtering using FFT
[t,c] = size(EEG); idx = reshape(1:t*c-mod(t*c,n),n,[]);
FLT = real(ifft(fft(EEG).*repmat(f(Fs*(0:t-1)/t)',1,c)));

% estimate temporal filter using least-squares
T = FLT(idx)/EEG(idx);

% extract data for all epochs of the first class concatenated (EPO{1}) and 
% all epochs of the second class concatenated (EPO{2})
% each array is [#samples x #channels]
wnd = round(Fs*wnd(1)) : round(Fs*wnd(2));
for k = 1:2
    EPO{k} = FLT(repmat(find(mrk==k),length(wnd),1) + repmat(wnd',1,nnz(mrk==k)),:);
end

% calculate the spatial filter matrix S using CSP (TODO: fill in)
cov1 = cov(EPO{1,1});
cov2 = cov(EPO{1,2});
[V,D] = eig(cov1, cov1+cov2);
S = V(:,[1:nof, end-nof+1:end]);

% log-variance feature extraction
for k = 1:2
    X{k} = squeeze(log(var(reshape(EPO{k}*S, length(wnd),[],2*nof))));
end

% train LDA classifier (preferably with gradual outputs) (TODO: fill in)
x_1 = X{1};
x_2 = X{2};
mu_1 = mean(x_1);
mu_2 = mean(x_2);
sigma_1 = cov(x_1 - mu_1);
sigma_2 = cov(x_2 - mu_2);

w = (sigma_1 + sigma_2)\(mu_2 - mu_1)';
w = w / norm(w);
b = -w' * (mu_1 + mu_2)' / 2;

