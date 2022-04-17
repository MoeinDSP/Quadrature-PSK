clc;
clear;
close all
input=randi([0 1],1,200000);%the input for modulation 
input_s=zeros(1,100000);%the input sample for modulation 

%In QPSK every 2 bits convert to 1 sample so 
%the number of inputs ought to 2time the inputs sample

output=zeros(1,100000);%the output for demodulation
output_sample=[];
counter_errors=0;%for counting the number of Error in EbN0 
Eb=10;%the energy of per bits
EbN0dB=0;
ber_sim=[];%Bit Error Rate Simulation       
ber_th=[]; %Bit Error Rate Theory 
i=0;
%i,j,k and L are our counters in our loops 
%% Makning the samples 
while i<length(input_s)
    i=i+1;
    j=2*i;
if input(1,j-1)==0&&input(1,j)==0
    input_s(1,i)=((1+1j)*sqrt(Eb));
end
if input(1,j-1)==0&&input(1,j)==1
    input_s(1,i)=((-1+1j)*sqrt(Eb));
end

if input(1,j-1)==1&&input(1,j)==0
    input_s(1,i)=((1-1j)*sqrt(Eb));
end
if input(1,j-1)==1&&input(1,j)==1
    input_s(1,i)=((-1-1j)*sqrt(Eb));
end
end
%% Making the noise
Noise_maker1=randn(1,length(input_s));
Noise_maker2=randn(1,length(input_s));

%% Reciever 
while EbN0dB<10
    EbN0dB=EbN0dB+1;
    counter_errors=0;
    N0=Eb/(10^(EbN0dB/10));
    white_noise=sqrt(N0/2)*(Noise_maker1+(1j*Noise_maker2));
    output_sample=input_s+white_noise;
for k=1:100000
    L=2*k;
if real(output_sample(k))>=0&&imag(output_sample(k))>=0
    output(L-1)=0;
    output(L)=0;
end

if real(output_sample(k))<0&&imag(output_sample(k))>=0
    output(L-1)=0;
    output(L)=1;
end

if real(output_sample(k))>=0&&imag(output_sample(k))<0
    output(L-1)=1;
    output(L)=0;
end

if real(output_sample(k))<0&&imag(output_sample(k))<0
    output(L-1)=1;
    output(L)=1;
end

 if input(L)~=output(L)
     counter_errors=counter_errors+1;
 end
  if input(L-1)~=output(L-1)
     counter_errors=counter_errors+1;
 end
end
ber_sim(1,EbN0dB)=(counter_errors/length(input));
ber_th(1,EbN0dB)=qfunc(sqrt((2*Eb)/N0));
%The Q function is related to the complementary error function, erfc,
%according to Q(x)=1/2*erfc(x/sqrt2)
end
%%
EbN0=1:10;
semilogy(EbN0,ber_sim,'-*g',EbN0,ber_th,'-ok','linewidth',2);
grid on

