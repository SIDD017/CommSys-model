function Text2Bits(filename)

global inputBits r c;
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

B = dec2bin(A) - '0';
B = reshape(B, 1, []);
inputBits = B;
disp(inputBits);
[r,c] = size(inputBits);
disp("Binary file generated successfully");
disp(size(inputBits));