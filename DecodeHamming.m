function DecodeHamming

global demodcodedSignal receivedData;

n = 7;
k = 4;

disp(demodcodedSignal);
D = dec2bin(demodcodedSignal) - '0';
%D = demodcodedSignal;
D = D';

disp(D);
receivedData = decode(D, n, k, 'hamming/binary');

disp(receivedData);
disp("recieved signal successfully decoded");