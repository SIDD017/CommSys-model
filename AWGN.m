function AWGN

global codedSignal uncodedSignal k nsamp ebnoVec freqsep Fs M demodcodedSignal demoduncodedSignal coded uncoded;



EbNo = 10;
snr = EbNo+10*log10(k)-10*log10(nsamp);
disp(EbNo);
disp(snr);
x = awgn(codedSignal, snr, 'measured');

disp("AWGN added");

demodcodedSignal = fskdemod(x,M,freqsep,nsamp,Fs);

%clear variables to free up memory
clear x;

disp(demodcodedSignal);
disp("Demodulation done");




%{
z1=1;
z2=1;
for i = 1:length(ebnoVec)
rxSig1  = awgn(codedSignal,ebnoVec(i)+10*log10(k)-10*log10(nsamp),'measured',[],'dB');
rxSig2  = awgn(uncodedSignal,ebnoVec(i)+10*log10(k)-10*log10(nsamp),'measured',[],'dB');
y1(z1:(z1+length(rxSig1)-1)) = rxSig1;
y2(z2:(z2+length(rxSig2)-1)) = rxSig2;
% BER_theory(i) = berawgn(ebnoVec(i),'fsk',M,'noncoherent');
% [num1(i),BER1(i)] = biterr(data1,rxsig1);
% [num2(i),BER2(i)] = biterr(data2,rxsig2);
z1 = z1+length(rxSig1);
z2 = z2+length(rxSig2);

end


% Demodulate the received signal.
dataOut1 = fskdemod(rxSig1,M,freqsep,nsamp,Fs);
dataOut2 = fskdemod(rxSig2,M,freqsep,nsamp,Fs);


% Calculate the bit error rate.
for i = 1:length(ebnoVec)
    [num1(i),BER1(i)] = biterr(coded,dataOut1);
    [num2(i),BER2(i)] = biterr(uncoded,dataOut2);
    BER_theory(i) = berawgn(ebnoVec(i),'fsk',M,'noncoherent');
end

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
legend('Simulation-Coded message','Simulation-Uncoded message','Theory','location','ne')

%  xlabel('Eb/No (dB)')
%  ylabel('BER')
%  grid
%  legend('Simulation-Coded message','Theory','location','ne')
demodcodedSignal = dataOut1;
demoduncodedSignal = dataOut2;
%}