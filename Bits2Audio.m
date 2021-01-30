function Bits2Audio

global receivedData Fs refsize r c;

bits = receivedData;
disp(bits);
%Fs = 48000;
%bin_new = bits';
size(bits)

disp(r);
disp(c);
%wavbinary = reshape(bits,r,c);
wavbinary = char(bits + '0');
g = double(bin2dec(wavbinary));
z = g/(10^4);

%{
data_class_to_use = 'int32';   %or as appropriate
SampleRate = Fs;      %set as appropriate
z = reshape( typecast( uint8(bin2dec( char(bits + '0') )), data_class_to_use ), orig_size );
%}
%{
x = char(bits + '0');
x = x';
y = uint8(bin2dec(x));
z = typecast(y,'double');
disp(z);
z = z./(2^(8-1));
%}

%{
dec = zeros(size(bits,2)/8,1);
k = 1;
for i = 1:8:size(bits,2)
    dec(k) = [128 64 32 16 8 4 2 1]*bits(i:i+7)';
    k = k+1;
end
dec = dec';
dec_new = typecast(dec,'double');
x = dec_new./(2^7);
x = reshape(x,[],2);
%}

audiowrite('Reconstructed.wav',z,Fs);
sound(z, Fs);
