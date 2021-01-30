function GetInput

%Generate random bits
r1 = randi(100,1000,1);
r2 = mod(r1, 2);


%Read bits from a text file (maximum 100 characters) stored in memory
filename = 'test.txt';
fileID = fopen(filename);
formatSpec = '%c';
A = fscanf(fileID, formatSpec);
fclose(fileID);
fid = fopen('textfile.bin', 'w');
fwrite(fid, A, 'double');
fclose(fid);
fid = fopen('textfile.bin');
B = fread(fid, 'double');
fclose(fid);
disp(B);
fid = fopen('reconstructed.txt', 'w');
fprintf(fid, formatSpec, B);
fclose(fid);

%Read bits from a grayscale image stored in memory
filename = 'periodic2.jpg';
y = imread(filename);
g = rgb2gray(y);
[r,c] = size(g);
imbin = dec2bin(y);
final = zeros(r,c);
imdec = bin2dec(imbin);
for i=1:c
    for j = 1:r
        final(j,i) = imdec(((i-1)*r)+j, 1);
    end
end
imshow(mat2gray(uint8(final)));



%Read bits from audio signal stored in memory
filename = 'sample.wav';
audiodata = audioread(filename);
orig_size = size(audiodata);
%sound(audiodata);
fid = fopen('wav.bin', 'w');
fwrite(fid, audiodata, 'double');
fclose(fid);
fid = fopen('wav.bin');
A = fread(fid, 'double');
fclose(fid);
%B = reshape(typecast(A, 'double') , orig_size );
sound(A);