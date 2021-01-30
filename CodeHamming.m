function CodeHamming

global inputBits encodedData;
%(7,4) Hamming channel coding
n = 7;
k = 4;
%{
%Read input.bin file into single comlumn vector of 4bit binary values
filename = 'input.bin';
fileID = fopen(filename);
A = fread(fileID, 'ubit4');
fclose(fileID);
%}

A = inputBits;

%clear variables to free up memory
%clear inputBits;

% apparently dec2bin(A) generates a character matrix. We do -'0' to get
% numeric matrix from that character matrix
%A = dec2bin(A) - '0';

[r c] = size(A);

encodedData = encode(A, n, k, 'hamming/binary');

%clear variables to free up memory
clear A;

disp(encodedData);
disp("Hamming channel coding successful");

%DecodeHamming(encodedData);

%{
decData = decode(bhejna,n,k,'hamming/binary');
numerr = biterr(A,decData);

disp(numerr);
%}