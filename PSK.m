function PSK

global inputBits encodedData codedSignal uncodedSignal k nsamp ebnoVec demodcodedSignal demoduncodedSignal freqsep Fs M coded uncoded;

custMap = [0 2 4 6 8 10 12 14 15 13 11 9 7 5 3 1];

pskModulator = comm.PSKModulator(16,'BitInput',true,'SymbolMapping','Custom', 'CustomSymbolMapping',custMap);
pskDemodulator = comm.PSKDemodulator(16,'BitOutput',true,'SymbolMapping','Custom','CustomSymbolMapping',custMap);

tempConst = 0;
%constellation(pskModulator)

awgnChannel = comm.AWGNChannel('BitsPerSymbol',log2(16));
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
    
    while errVec1(2) < 200 && errVec1(3) < 1e7
        % Generate a 1000-symbol frame
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
            data2 = [data2,0]; 
            end
        end
        %Modulation is performed on column vector
        data2 = data2';
        % Modulate the binary data
        modData1 = pskModulator(data1);
        modData2 = pskModulator(data2);
        
        % Pass the modulated data through the AWGN channel
        rxSig1 = awgnChannel(modData1);
        rxSig2 = awgnChannel(modData2);
        if z==16
            tempConst = rxSig1;
        end
        
        % Demodulate the received signal
        demodcodedSignal = pskDemodulator(rxSig1);
        demoduncodedSignal = pskDemodulator(rxSig2);
        
        % Collect the error statistics
        errVec1 = errorRate(data1,demodcodedSignal);
        errVec2 = errorRate(data2,demoduncodedSignal);
        
    end
    
    % Save the BER data
    ber1(z) = errVec1(1);
    ber2(z) = errVec2(1);
    
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
berTheory = berawgn(ebnoVec,'psk',16,'nondiff');

figure
semilogy(ebnoVec,[ber1; ber2; berTheory])
xlabel('Eb/No (dB)')
ylabel('BER')
grid
legend('Simulation-Coded message','Simulation-Uncoded message','Theoretical','location','ne')

%Plot Constellation Diagram for Eb/No=16dB
sPlotFig = scatterplot(tempConst,1,0,'g.');
hold on
scatterplot(modData1,1,0,'k*',sPlotFig)

%{
scatterplot(tempConst);
disp(rxSig1);
disp("done");
%}








%{
%---------------------------------Constellation----------------------------
M = 16;             % Modulation alphabet size
phOffset = 0;       % Phase offset
symMap = 'binary';  % Symbol mapping (either 'binary' or 'gray')
%Construct the modulator object.

pskModulator = comm.PSKModulator(M,phOffset,'SymbolMapping',symMap);
%Plot the constellation.

%constellation(pskModulator);
%scatterplot(pskModulator);
cd = comm.ConstellationDiagram('ShowReferenceConstellation',false);
step(cd,demodcodedSignal);  

data1 = encodedData;
data1 =data1';
% Modulate the binary data
modData1 = pskModulator(data1);

t1=0:length(modData1)-1;
figure(4)
plot(t1,modData1)
%disp(demodcodedSignal);
%}