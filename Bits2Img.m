function Bits2Img

global receivedData r c br bc;

%x = reshape(receivedData, [], 7);

received = reshape(receivedData,br,bc);
imbin = char(received + '0');
g = uint8(bin2dec(imbin));
g = reshape(g,r,c);

imshow(g);