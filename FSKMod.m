function FSKMod

global inputBits encodedData codedSignal uncodedSignal k nsamp ebnoVec freqsep Fs M coded uncoded;


M = 16;% Modulation order
k = log2(M);
freqsep = 20;  % Frequency separation (Hz)
nsamp = 128;    % Number of samples per symbol
Fs = 340;      % Sample rate (Hz)

x = encodedData;

%clear variables to free up memory
clear encodedData;

codedSignal = fskmod(x,M,freqsep,nsamp,Fs);
uncodedSignal = fskmod(inputBits,M,freqsep,nsamp,Fs);

%clear variables to free up memory
clear x;

%disp(codedSignal);
disp("FSK Modulation successful");


z = codedSignal;
%time domain plot
t=0:length(z)-1;
figure(1)
plot(t,real(z));
title('Time domain plot');
disp("Time Domain Graph plotted");

%PSD plot
Fs = 1000;
t = 0:1/Fs:1-1/Fs;
figure(2)
plot(psd(spectrum.periodogram,z,'Fs',Fs,'NFFT',length(z)));




%{
% Set the simulation parameters.
M = 16;         % Modulation order
k = log2(M);   % Bits per symbol
%EbNo = 5;      % Eb/No (dB)
Fs = 340;       % Sample rate (Hz)
nsamp = 128;     % Number of samples per symbol
freqsep = 20;  % Frequency separation (Hz)
ebnoVec = 1:16;

%There are 2 inputs being transmitted, one is the direct binary data from
%the source and the other is channel coded data with error correcting
%capabilities
uncoded = inputBits;
coded = encodedData;

uncodedSignal = fskmod(uncoded,M,freqsep,nsamp,Fs);
codedSignal = fskmod(coded,M,freqsep,nsamp,Fs);
disp("FSK Modulation successful");

Fs = 1000;
t = 0:1/Fs:1-1/Fs;
x = codedSignal;
figure(1)
plot(psd(spectrum.periodogram,x,'Fs',Fs,'NFFT',length(x)))
    
    
t1=0:length(codedSignal)-1;
disp("PSD Graph plotted");
figure(2)
plot(t1,codedSignal);
title('Time domain plot');
disp("Time Domain Graph plotted");

%{
%------------------------Reference Code------------------------------------
% --- Executes on button press in fsk_mod.
function fsk_mod_Callback(hObject, eventdata, handles)
% hObject    handle to fsk_mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fsk_mod
%% Set the simulation parameters.
M = 16;         % Modulation order
k = log2(M);   % Bits per symbol
 EbNo = 5;      % Eb/No (dB)
Fs = 340;       % Sample rate (Hz)
nsamp = 128;     % Number of samples per symbol
freqsep = 20;  % Frequency separation (Hz)
ebnoVec = 1:16;
%% Generate random data symbols.

data1 = handles.code;
data2 = handles.source;
%% Apply FSK modulation.
txsig1 = fskmod(data1,M,freqsep,nsamp,Fs);
txsig2 = fskmod(data2,M,freqsep,nsamp,Fs);

Fs = 1000;
t = 0:1/Fs:1-1/Fs;
x = txsig1;
figure(1)
plot(psd(spectrum.periodogram,x,'Fs',Fs,'NFFT',length(x)))
    
    
t1=0:length(txsig1)-1;
figure(2)
plot(t1,txsig1);
title('Time domain plot');
%% Pass the signal through an AWGN channel
z1=1;
z2=1;
for i = 1:length(ebnoVec)
rxSig1  = awgn(txsig1,ebnoVec(i)+10*log10(k)-10*log10(nsamp),'measured',[],'dB');
rxSig2  = awgn(txsig2,ebnoVec(i)+10*log10(k)-10*log10(nsamp),'measured',[],'dB');
y1(z1:(z1+length(rxSig1)-1)) = rxSig1;
y2(z2:(z2+length(rxSig2)-1)) = rxSig2;
% BER_theory(i) = berawgn(ebnoVec(i),'fsk',M,'noncoherent');
% [num1(i),BER1(i)] = biterr(data1,rxsig1);
% [num2(i),BER2(i)] = biterr(data2,rxsig2);
z1 = z1+length(rxSig1);
z2 = z2+length(rxSig2);

end
%}
%}
