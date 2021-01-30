function RandomBits

global inputBits;
%Generate random bits
r1 = randi(100,1,256);
r2 = mod(r1, 2);
disp(r2);

fid = fopen('input.bin', 'w');
fwrite(fid, r2, 'double');
fclose(fid);

inputBits = r2;
disp("Binary file generated successfully");