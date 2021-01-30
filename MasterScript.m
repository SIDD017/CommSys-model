global inputBits encodedData;

function RandomBits

%Generate random bits
r1 = randi(100,1,256);
r2 = mod(r1, 2);
disp(r2);

fid = fopen('input.bin', 'w');
fwrite(fid, r2, 'double');
fclose(fid);

inputBits = r2;
disp("Binary file generated successfully");
disp("cue chjsdc hdsjxxxxxybacswiudaciusc");
end

%-------------------------------------------------------------------------
function Text2Bits(filename)

%Read bits from a text file (maximum 100 characters) stored in memory
%filename = 'test.txt';
fileID = fopen(filename);
formatSpec = '%c';
A = fscanf(fileID, formatSpec);
fclose(fileID);
%{
fid = fopen('input.bin', 'w');
fwrite(fid, A, 'double');
fclose(fid);
%}

B = dec2bin(A);
inputBits = A;
disp("Binary file generated successfully");
end

%-------------------------------------------------------------------------
function Img2Bits(filename)

%Read bits from a grayscale image stored in memory
%filename = 'periodic2.jpg';
y = imread(filename);
g = rgb2gray(y);
[r,c] = size(g);
imbin = dec2bin(y);

%a = dec2bin(img);
imbin = imbin-'0';
imbin = imbin';
bincode = reshape(imbin,1,[]);

fid = fopen('input.bin', 'w');
fwrite(fid, bincode, 'double');
fclose(fid);

inputBits = bincode;
disp("Binary file generated successfully");

%{
final = zeros(r,c);
imdec = bin2dec(imbin);
for i=1:c
    for j = 1:r
        final(j,i) = imdec(((i-1)*r)+j, 1);
    end
end
imshow(mat2gray(uint8(final)));
%}
end

%-------------------------------------------------------------------------
function Audio2Bits(filename)

%Read bits from audio signal stored in memory
%filename = 'sample.wav';
audiodata = audioread(filename);
orig_size = size(audiodata);
%sound(audiodata);
fid = fopen('input.bin', 'w');
fwrite(fid, audiodata, 'double');
fclose(fid);

inputBits = audiodata;
disp("Binary file generated successfully");

%{
fid = fopen('wav.bin');
A = fread(fid, 'double');
fclose(fid);
%B = reshape(typecast(A, 'double') , orig_size );
sound(A);
%}
end

%-------------------------------------------------------------------------
function CodeHamming

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
% apparently dec2bin(A) generates a character matrix. We do -'0' to get
% numeric matrix from that character matrix
%A = dec2bin(A) - '0';

[r c] = size(A);

encodedData = encode(A, n, k, 'hamming/binary');
disp("Hamming channel coding successful");

%DecodeHamming(encodedData);

%{
decData = decode(bhejna,n,k,'hamming/binary');
numerr = biterr(A,decData);

disp(numerr);
%}
end

%-------------------------------------------------------------------------
function CodeBCH

%(127,64) BCH channel coding
n = 127;
k = 64;

%{
%Read input.bin file into single comlumn vector of 4bit binary values
filename = 'input.bin';
fileID = fopen(filename);
A = fread(fileID);
fclose(fileID);
%}

%A = dec2bin(A) - '0';

A = inputBits;
data = A;
if mod(length(data),64) ~= 0
            for a = 63:-1:mod(length(data),64)
                data = [data,0] 
            end
end
B = reshape(data,[ ],64);

B = gf(B); 

encodedData = bchenc(B, n, k);
disp("BCH channel coding Successful");
end

%{
%-----------------REFERENCE CODE-----------------------------%
y = handles.source;
m = 7;
n = (2^m)- 1;
k=64;
data = y;
if mod(length(data),64) ~= 0
            for a = 63:-1:mod(length(data),64)
            data = [data,0] 
            end
end

tdata = reshape(data,[ ],64);
msg = gf(tdata);
[genpoly,t] = bchgenpoly(n,k);
code = bchenc(msg,n,k);
c=gf(code);
%disp(c);
d=c.x;
d_vect = dec2bin(d');
dataout = d_vect - '0';
%d=reshape(d,1,[ ]);
BCHout=dataout';
%end
disp(BCHout);
handles.code = BCHout;
guidata(hObject, handles);
%}

%--------------------------------------------------------------------------
function FSKMod
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
x = codedsignal;
figure(1)
plot(psd(spectrum.periodogram,x,'Fs',Fs,'NFFT',length(x)))
    
    
t1=0:length(codedsignal)-1;
disp("PSD Graph plotted");
figure(2)
plot(t1,codedsignal);
title('Time domain plot');
disp("Time Domain Graph plotted");
end

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