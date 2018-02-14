%% ME 597 Data Accquisition Code
% University of Waterloo ME 597E
% Written by Eugene Li Dec 2015
close all; clear all; clc;
%% Device Configuration
%If this is operating correctly the board name should appear
devices = daq.getDevices
s = daq.createSession('ni')

%Add analog inputs for each sensor being read
% addAnalogInputChannel(s,'Dev2',0,'Voltage') %Each channel corresponds to the AI on the ELVIS
 addAnalogInputChannel(s,'Dev2',1,'Voltage')
s.Rate = 800; %Baud rate
%% Sensor Reads

% Debugging Tools
%Do a single sensor read
% data = s.inputSingleScan 

%Read for a second
%[data,time] = s.startForeground;
%plot(time,data); 

%Continuious Background Read
% figure;
% s.DurationInSeconds = 5;
% lh = addlistener(s,'DataAvailable', @(src,event) plot(event.TimeStamps, event.Data));
% s.NotifyWhenDataAvailableExceeds = 8000;
% s.startBackground();
% s.wait()
% delete(lh);

%Normal Operation
%Read for a set period of time
s.DurationInSeconds = 5;
[data,time] = s.startForeground;
figure; plot(time,data); legend('Channel 1','Channel 2');


