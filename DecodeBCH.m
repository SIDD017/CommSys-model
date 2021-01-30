function DecodeBCH

global demodcodedSignal receivedData encodedData corrSize inputBits;

demodcodedSignal = demodcodedSignal';

disp(size(demodcodedSignal));
[p,o] = size(demodcodedSignal);
demodcodedSignal(:,(corrSize+1):o) = [];
disp(demodcodedSignal);
disp(size(demodcodedSignal));



binary_db = reshape(demodcodedSignal,127,[]);%15*127
    binary_db = binary_db';
    binary_db = gf(binary_db);
    [newmsg,err,ccode] = bchdec(binary_db,127,64);
    x = newmsg.x;
    L = reshape(x,[],1);
    
    Z = dec2bin(L);
    temporary = Z - '0';
    temporary = temporary';
    
    [r,c] = size(inputBits);
    [h,j] = size(temporary);
    temporary(:,(c+1):j) = [];
    receivedData = temporary;
    disp(receivedData);
    
  %{  
    %'x' has to be reduced to the size of 'x2'
    t=zeros([1 original_length_data2]);
     for h=1:1:original_length_data2
          t(h)= DecOutput(h);
     end
    
    errVec1 = errorRate(original_source_fsk,t');
    ber1(j) = errVec1(1);
    
    if j == 8
        handles.dem1 = t';
    end

    end

end

%}












%{
dataout = demodcodedSignal;
datain = typecast(dataout,'uint8');
binary = dec2bin(datain);
binary = binary';
binary_db = binary-'0';

disp(size(binary_db));

[p,o] = size(binary_db);
binary_db(:,(corrSize+1):o) = [];

binary_db = reshape(binary_db,[],127);
binary_db = gf(binary_db);


[newmsg,err,ccode] = bchdec(binary_db,127,64);
d1=newmsg.x;
d_vect1 = dec2bin(d1');
dataout1 = d_vect1 - '0';
bits=dataout1;
%disp(bits);
receivedData= bits';
%}











%{
disp(size(encodedData));
disp(size(demodcodedSignal));
%D = dec2bin(demodcodedSignal) - '0';
D = demodcodedSignal;
D = D';
D = D+'0';
%disp(size(D));


[p,o] = size(D);
D(:,(corrSize+1):o) = [];

disp(size(D));

%[numErrors,ser] = symerr(encodedData,demodcodedSignal);
%disp(numErrors);
binary_db = reshape(D,[],127);
binary_db = gf(binary_db);


newmsg = bchdec(binary_db,127,64);
%disp(newmsg);
d1=newmsg.x;

%d_vect1 = reshape(d1, 1, []);

%disp(d_vect1);

d_vect1 = dec2bin(d1');
dataout1 = d_vect1 - '0';
bits=dataout1;

receivedData = bits';
%[numErrors,ser] = symerr(inputBits,receivedData);
%disp(numErrors);
%}