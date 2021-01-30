function Audio2Bits(filename)

global inputBits Fs refsize r c;
%Read bits from audio signal stored in memory
%filename = 'sample.wav';
[audiodata,Fs] = audioread(filename);

sound(audiodata,Fs);

%sound(audiodata);

g = audiodata .* (10^4);
wavbinary = dec2bin(g);
[r,c] = size(g);
wavbinary = wavbinary - '0';

wavbinary = reshape(wavbinary, 1, []);

%{
wavbinary = dec2bin( typecast( single(audiodata(:)), 'uint64'), 64 ) - '0';
refsize = size(wavbinary);
wavbinary = reshape(wavbinary,1,[]);
%}
inputBits = wavbinary;
disp(inputBits);
[r,c] = size(inputBits);
disp("Binary file generated successfully");
disp(size(inputBits));
disp(r);
disp(c);
disp(size(audiodata));

%{
nbits = 8;
data = audiodata.*(2^(nbits-1));
data = data(:);
data_uint = typecast(data,'uint8');
binary = dec2bin(data_uint);
binary_trans = binary';
y = binary_trans-'0';
inputBits = reshape(y,1,[]);
disp(inputBits);
disp(size(data));
%}





%{

orig_size = size(audiodata);
%sound(audiodata);
fid = fopen('input.bin', 'w');
fwrite(fid, audiodata, 'double');
fclose(fid);

inputBits = audiodata;
disp(inputBits);
disp("Binary file generated successfully");

%}









%{
fid = fopen('wav.bin');
A = fread(fid, 'double');
fclose(fid);
%B = reshape(typecast(A, 'double') , orig_size );
sound(A);
%}

%---------------------------REFERENCE CODE---------------------------------
%{
[y,Fs] = audioread('Audio3.wav');
nbits = 8;
data = y.*(2^(nbits-1));
data = data(:);
data_uint = typecast(data,'uint8');
binary = dec2bin(data_uint);
binary_trans = binary';
y = binary_trans-'0';
y = reshape(y,1,[]);
%disp(y);
disp("Data converted to binary form succesfully");
fprintf("Size of array %d \n",size(y,2));
handles.source = y;
guidata(hObject, handles);
%}