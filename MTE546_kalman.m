%%
% MTE 546: Kalman Filter Example
% Winter 2017
% Written by : Eugene Li
%%
% 2D Kalman filter example
clear;clc;close all;
% Discrete time step
dt = 0.1;

% Prior
xhat = [0.5;0]; % mean (mu)
P = 1;% covariance (Sigma)

%Motion model
k_spring = 1.2;
c = 2.5;
m = 11;
A = [0,1;k_spring/m,c/m];
B = [0,0;0,0];
R = [0.3,0;0,0.5];

% Measurement model
C = [-1,0;0,0.6];
Q = [0.2,0;0,0.1];

% Simulation Initializations
Tf = 10;
T = 0:dt:Tf;
x = zeros(2,length(T)+1);
x(:,1) = xhat;
y = zeros(2,length(T));
u = y;

%% Main loop
for k=1:length(T)
    %% Simulation
    
    % Select a motion disturbance
    w = [Q(1,1)*randn(1);Q(2,2)*randn(1)];
    % Update state
    x(:,k+1) = A*x(:,k)+ B*u(:,k) + w;

    % Take measurement
    % Select a motion disturbance
    v = [R(1,1)*randn(1);R(2,2)*randn(1)];
    % Determine measurement
    y(:,k) = C*x(:,k+1) + v;

    
    %% Kalman Filter Estimation
    % Store prior
    xhat_old = xhat;
    P_old = P;

    % Prediction update
    xhat_k = A*xhat + B*u(:,k);
    P_predict = A*P*A' + Q;

    % Measurement update
    K = P_predict*C'*inv(C*P_predict*C'+R);
    xhat = xhat_k + K*(y(:,k)-C*xhat_k);
    P = (1-K*C)*P_predict;
    
    %Store estimates
    xhat_S(:,k)= xhat_k;
    x_S(:,k)= xhat;
    y_hat(:,k) = C*xhat;
   
end
%Plot full trajectory results
figure;
subplot(2,2,1)
hold on
plot(T,x(1,2:end)) %State
plot(T,x_S(1,:))
%plot(T,xhat_S(1,:)) %Prediction
title('State and Estimates')
legend('State', 'Estimate');

subplot(2,2,2)
hold on;
plot(T,x_S(2,:))%Estimate
plot(T,x(2,2:end))
%plot(T,xhat_S(2,:)) %Prediction

subplot(2,2,3);
hold on
plot(T,y(1,:)) %Measurement
plot(T,y_hat(1,:));
legend('Measurement', 'Prediction');

subplot(2,2,4)
hold on
plot(T,y(2,:)) %Measurement
plot(T,y_hat(2,:));


