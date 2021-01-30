function Img2Bits(filename)

global inputBits r c br bc;
%Read bits from a grayscale image stored in memory
%filename = 'periodic2.jpg';
g = imread(filename);
%g = rgb2gray(y);
disp(g)
[r,c] = size(g);
imbin = dec2bin(g);

%clear variables to free up memory
clear g;

%a = dec2bin(img);
imbin = imbin-'0';
%imbin = imbin';
%disp(imbin);
[br,bc] = size(imbin);
bincode = reshape(imbin,1,[]);

%clear variables to free up memory
clear imbin;

fid = fopen('input.bin', 'w');
fwrite(fid, bincode, 'double');
fclose(fid);

inputBits = bincode;

%clear variables to free up memory
clear bincode;

disp(inputBits);
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