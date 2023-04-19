%% Data Loading
clc;close all;
clear all;

% path: "C:\Users\c.boscarino\OneDrive - Reply\Desktop\ChiaraBoscarino\UNI\BSPLab\Project\training2017"

path = '\training2017\';
SelectedPatient='A00001';
filename= [path,SelectedPatient];

[Sig, Fs, Time] = rdsamp(filename, 1);
plot(Time, Sig);


%% Filtering
fs= Fs;         %sampling freq

wp= [0.5 60];   %passband freq
ws= [0.3 80];   %stopband freq

w1=wp/(fs/2);   %passband normalized
w2=ws/(fs/2);   %stopband normalized

rp= 0.2;        %passband ripple
rs= 40;         %stopband ripple

[n,wn]=buttord(w1,w2,rp,rs);        %computing optimal settings
[b,a]=butter(n,wn,'bandpass');      %getting the filter coeff.

freqz(b,a);
