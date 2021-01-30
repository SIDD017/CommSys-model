function QAM32

global inputBits encodedData codedSignal uncodedSignal k nsamp ebnoVec demodcodedSignal demoduncodedSignal freqsep Fs M coded uncoded;

M = 32; % Modulation order (alphabet size or number of points in signal constellation)
k = log2(M); % Number of bits per symbol
sps = 1; % Number of samples per symbol (oversampling factor)

data1 = encodedData;
if mod(length(data1),5) ~= 0
   for a = 4:-1:mod(length(data1),5)
      data1 = [data1,0];
   end
end
%Modulation is performed on column vector
data1 = data1';

data2 = inputBits;
if mod(length(data2),5) ~= 0
   for a = 4:-1:mod(length(data2),5)
      data2 = [data2,0] ;
   end
end
%Modulation is performed on column vector
data2 = data2';

dataInMatrix1 = reshape(data1,[],k);
dataSymbolsIn1 = bi2de(dataInMatrix1);
dataInMatrix2 = reshape(data2,[],k);
dataSymbolsIn2 = bi2de(dataInMatrix2);

dataMod1 = qammod(dataSymbolsIn1,M,'bin'); % Binary coding with phase offset of zero
dataMod2 = qammod(dataSymbolsIn2,M,'bin'); % Binary coding with phase offset of zero
dataModG1 = qammod(dataSymbolsIn1,M); % Gray coding with phase offset of zero
dataModG2 = qammod(dataSymbolsIn2,M); % Gray coding with phase offset of zero

errorRate = comm.ErrorRate;
ebnoVec = 1:16;
ber1 = zeros(size(ebnoVec));
ber2 = zeros(size(ebnoVec));

for z = 1:length(ebnoVec)
    
    % Reset the error counter for each Eb/No value
    reset(errorRate)
    % Reset the array used to collect the error statistics
    errVec1 = [0 0 0];
    % Set the channel Eb/No
    awgnChannel.EbNo = ebnoVec(z);
    
    snr = ebnoVec(z)+10*log10(k)-10*log10(sps);
    
     % Pass the modulated data through the AWGN channel
        %rxSig1 = awgnChannel(dataMod1);
        %rxSig2 = awgnChannel(dataMod2);
        rxSig1 = awgn(dataMod1,snr,'measured');
        rxSig2 = awgn(dataMod2,snr,'measured');
        if z==16
            tempConst = rxSig1;
        end
        
        demodcodedSignal = qamdemod(rxSig1,M,'bin');
        demoduncodedSignal = qamdemod(rxSig2,M,'bin');
        
        dataOutMatrix = de2bi(demodcodedSignal,k);
        demodcodedSignal = dataOutMatrix(:); % Return data in column vector
        dataOutMatrix = de2bi(demoduncodedSignal,k);
        demoduncodedSignal = dataOutMatrix(:); % Return data in column vector
    
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
x = dataMod1;
figure(1)
plot(psd(spectrum.periodogram,x,'Fs',Fs,'NFFT',length(x)));
awgnChannel = comm.AWGNChannel('BitsPerSymbol',log2(16));

%Plot Time Domain graph
t1=0:length(x)-1;
figure(2)
plot(t1,real(x));
title('Time domain plot');

%Calculate theoretical BER 
berTheory = berawgn(ebnoVec,'qam',16,'nondiff');

figure
semilogy(ebnoVec,[ber1; ber2; berTheory])
xlabel('Eb/No (dB)')
ylabel('BER')
grid
legend('Simulation-Coded message','Simulation-Uncoded message','Theoretical','location','ne')

%{
%Plot Constellation Diagram for Eb/No=16dB
sPlotFig = scatterplot(tempConst,1,0,'g.');
hold on
scatterplot(dataMod1,1,0,'k*',sPlotFig)
%}