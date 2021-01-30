function CodeBCH

global inputBits encodedData corrSize;
%{
y = inputBits;
m = 7;
n = (2^m)- 1;
k=64;
data = y;
if mod(length(data),64) ~= 0
            for a = 63:-1:mod(length(data),64)
                data = [data,0] 
            end
end

%{
t = bchnumerr(n,k);
tdata = reshape(data,[ ],64);
msg = gf(tdata);

encodedData = bchenc(msg,n,k);
disp(encodedData);
%}

tdata = reshape(data,[ ],64);
msg = gf(tdata);
disp(msg);
[genpoly,t] = bchgenpoly(n,k);
code = bchenc(msg,n,k);
disp(code);
c=gf(code);
%disp(c);
d=c.x;
d_vect = dec2bin(d');


dataout = d_vect - '0';
%d=reshape(d,1,[ ]);
encodedData=dataout';
%}


y = inputBits;
m = 7;
n = (2^m)- 1;
k=64;
data = y;
if mod(length(data),64) ~= 0
            for a = 63:-1:mod(length(data),64)
            data = [data,0] ;
            end
end
tdata = reshape(data,[ ],64);
msg = gf(tdata);
code = bchenc(msg,n,k);
d=code.x;                       %Converts GF to uint32
d_vect = dec2bin(d');
dataout = d_vect - '0';
BCHout = dataout';
encodedData = BCHout;  
disp("BCH Encoding done");


disp("start");
[q,corrSize] = size(encodedData);
disp(corrSize);
disp("end");

%}









%{
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
%}


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