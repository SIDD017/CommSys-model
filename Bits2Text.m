function Bits2Text

global receivedData r c;

%In some tests receivedData had extra columns containing 0s, compared to
%the original number of columns that were transmitted after reading input.
%This caused errors in MATLAB as the next step in reconstructng the
%original file required reshaping the array into a 7 column matrix, which
%always gives error on the console
[p,o] = size(receivedData);
receivedData(:,(c+1):o) = [];

%disp(size(receivedData));
x = reshape(receivedData, [], 7);
%x = receivedData;
x = char(x + '0');
%disp(x);
%disp("gagagagagga");
y = char(bin2dec(x));
disp(y');


fileID = fopen('result.txt', 'w');
formatSpec = '%c';
fprintf(fileID, formatSpec, y);
fclose(fileID);


