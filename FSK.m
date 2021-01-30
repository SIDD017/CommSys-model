function FSK
global inputBits encodedData codedSignal uncodedSignal k nsamp ebnoVec demodcodedSignal demoduncodedSignal freqsep Fs M coded uncoded;

M = 16;         % Modulation order
k = log2(M);   % Bits per symbol
Fs = 340;       % Sample rate (Hz)
nsamp = 128;     % Number of samples per symbol
freqsep = 20;  % Frequency separation (Hz)
ebnoVec = 1:16;

fskMod = comm.FSKModulator(M,freqsep,'BitInput',true);
fskMod.FrequencySeparation = freqsep;  
fskMod.SamplesPerSymbol = nsamp;    
fskMod.SymbolRate = Fs; 
fskDemod = comm.FSKDemodulator(M,freqsep,'BitOutput',true);
fskDemod.FrequencySeparation = freqsep;  
fskDemod.SamplesPerSymbol = nsamp;  
fskDemod.SymbolRate = Fs; 

awgnChannel = comm.AWGNChannel('BitsPerSymbol',log2(16));
errorRate = comm.ErrorRate;

ber1 = zeros(size(ebnoVec));
ber2 = zeros(size(ebnoVec));

data1 = encodedData;
if mod(length(data1),4) ~= 0
   for a = 3:-1:mod(length(data1),4)
      data1 = [data1,0];
   end
end
%Modulation is performed on column vector
data1 = data1';

data2 = inputBits;
if mod(length(data2),4) ~= 0
   for a = 3:-1:mod(length(data2),4)
      data2 = [data2,0] ;
   end
end
%Modulation is performed on column vector
data2 = data2';

release(fskMod);
modData1 = fskMod(data1);
release(fskMod);
modData2 = fskMod(data2);

ebnoVec = 1:16;

for z = 1:length(ebnoVec)
     % Reset the error counter for each Eb/No value
    reset(errorRate)
    % Reset the array used to collect the error statistics
    errVec1 = [0 0 0];
    % Set the channel Eb/No
    awgnChannel.EbNo = ebnoVec(z);
    
     % Pass the modulated data through the AWGN channel
        rxSig1 = awgnChannel(modData1);
        rxSig2 = awgnChannel(modData2);
        if z==16
            tempConst = rxSig1;
        end
        
         % Demodulate the received signal
         release(fskDemod);
    demodcodedSignal = fskDemod(rxSig1);
    release(fskDemod);
    demoduncodedSignal = fskDemod(rxSig2);
    
    % Collect the error statistics
        errVec1 = errorRate(data1,demodcodedSignal);
        errVec2 = errorRate(data2,demoduncodedSignal);
        
         % Save the BER data
    ber1(z) = errVec1(1);
    ber2(z) = errVec2(1);
    
    disp(errVec1);
    
end

%Plot PSD of modulated signal
Fs = 10000;
t = 0:1/Fs:1-1/Fs;
x = modData1;
figure(1)
plot(psd(spectrum.periodogram,x,'Fs',Fs,'NFFT',length(x)));
awgnChannel = comm.AWGNChannel('BitsPerSymbol',log2(16));

%Plot Time Domain graph
t1=0:length(x)-1;
figure(2)
plot(t1,real(x));
title('Time domain plot');

%Calculate theoretical BER 
berTheory = berawgn(ebnoVec,'fsk',16,'nondiff');

figure
semilogy(ebnoVec,[ber1; ber2; berTheory])
xlabel('Eb/No (dB)')
ylabel('BER')
grid
legend('Simulation-Coded message','Simulation-Uncoded message','Theoretical','location','ne')



%{
%% OLD CODE TO REVERT TO---------------------------------------------------
%{
M = 16;% Modulation order
k = log2(M);
freqsep = 20;  % Frequency separation (Hz)
nsamp = 128;    % Number of samples per symbol
Fs = 340;      % Sample rate (Hz)

%}

% Set the simulation parameters.
M = 16;         % Modulation order
k = log2(M);   % Bits per symbol
 EbNo = 5;      % Eb/No (dB)
Fs = 340;       % Sample rate (Hz)
nsamp = 128;     % Number of samples per symbol
freqsep = 20;  % Frequency separation (Hz)
ebnoVec = 1:16;
BER1 = zeros(size(ebnoVec));
BER2 = zeros(size(ebnoVec));

% Apply FSK modulation.
codedSignal = fskmod(encodedData,M,freqsep,nsamp,Fs);
uncodedSignal = fskmod(inputBits,M,freqsep,nsamp,Fs);

Fs = 1000;
t = 0:1/Fs:1-1/Fs;
x = codedSignal;
figure(1)
plot(psd(spectrum.periodogram,x,'Fs',Fs,'NFFT',length(x)));
    
    
t1=0:length(codedSignal)-1;
figure(2)
plot(t1,codedSignal);
title('Time domain plot');
% Pass the signal through an AWGN channel
for i = 1:length(ebnoVec)
    rxSig1  = awgn(codedSignal,ebnoVec(i)+10*log10(k)-10*log10(nsamp),'measured',[],'dB');
    rxSig2  = awgn(uncodedSignal,ebnoVec(i)+10*log10(k)-10*log10(nsamp),'measured',[],'dB');
    demodcodedSignal = fskdemod(rxSig1,M,freqsep,nsamp,Fs);
    demoduncodedSignal = fskdemod(rxSig2,M,freqsep,nsamp,Fs);
    [num1(i),BER1(i)] = biterr(encodedData,demodcodedSignal);
    [num2(i),BER2(i)] = biterr(inputBits,demoduncodedSignal);
    BER_theory(i) = berawgn(ebnoVec(i),'fsk',M,'noncoherent');
%y1(z1:(z1+length(rxSig1)-1)) = rxSig1;
%y2(z2:(z2+length(rxSig2)-1)) = rxSig2;
% BER_theory(i) = berawgn(ebnoVec(i),'fsk',M,'noncoherent');
% [num1(i),BER1(i)] = biterr(data1,rxsig1);
% [num2(i),BER2(i)] = biterr(data2,rxsig2);
end

disp(BER1);
%{
% Demodulate the received signal.
demodcodedSignal = fskdemod(rxSig1,M,freqsep,nsamp,Fs);
demoduncodedSignal = fskdemod(rxSig2,M,freqsep,nsamp,Fs);


% Calculate the bit error rate.
for i = 1:length(ebnoVec)
    [num1(i),BER1(i)] = biterr(encodedData,demodcodedSignal);
    [num2(i),BER2(i)] = biterr(inputBits,demoduncodedSignal);
    BER_theory(i) = berawgn(ebnoVec(i),'fsk',M,'noncoherent');
end
%}
% Determine the theoretical BER and compare it to the estimated BER.
% BER_theory = berawgn(EbNo,'fsk',M,'noncoherent');


% figure
%  semilogy(ebnoVec,[BER1;  BER_theory])
%  xlabel('Eb/No (dB)')
%  ylabel('BER')
%  grid
%  legend('Simulation-Coded message','Theory','location','ne')

%  semilogy(SNRdB,BER_th,'k');              %Plot BER
%  hold on
%  semilogy(SNRdB,BER_sim,'k*');
%  legend('Theoretical','Simulation',3);
%  axis([min(SNRdB) max(SNRdB) 10^(-5) 1]);
%  hold off
ebnoVec = 1:16;
%  figure
%   semilogy(ebnoVec,BER_theory);
%   hold on
%     semilogy(ebnoVec,BER1);
%   %  semilogy(ebnoVec,BER2);
%     legend('Theoretical','Simulation-Coded',3);
%   hold off
figure
semilogy(ebnoVec,[BER1; BER2; BER_theory])
xlabel('Eb/No (dB)')
ylabel('BER')
grid
legend('Coded Signal','Uncoded Signal','Theoretical','location','ne')

%  xlabel('Eb/No (dB)')
%  ylabel('BER')
%  grid
%  legend('Simulation-Coded message','Theory','location','ne')
%handles.dem1 = demodcodedSignal;
%handles.dem2 = demoduncodedSignal;
%}