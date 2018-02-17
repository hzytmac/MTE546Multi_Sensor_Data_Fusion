close all;
clear;
clc;

% Discrete time step
Tf = 5;
dt = 0.1;
T = 0:dt:Tf;
% Prior (initial assumption)
xhat = [0.5;0.5]; % mean (mu)
P = eye(2);% covariance (Sigma)


%Motion model
A = [1,dt;0,1];
Q = [0.25 0;0 0.64];

% Measurement model
R = [0.00019,0;0,0.001]; % covariance data from lab1

% H(x) (sensor model:voltage=h(position))
syms x
h1(x) = -2.362e-04*x^3+0.0155*x^2-0.3459*x+3.0776; %short range
H1x = jacobian(h1,x);
h2(x) = -1.36e-05*x^3+0.0024*x^2-0.1443*x+3.33;  %medium range
H2x = jacobian(h2,x);

% Simulation Initializations

x = zeros(2,length(T)+1);
x(:,1) = xhat;
y = zeros(2,length(T));

%% Main loop
for k=1:length(T)
    %% Simulation
    
    % Select a motion disturbance
    w = [Q(1,1)*randn(1);Q(2,2)*randn(1)];
    % Update state
    x(:,k+1) = A*x(:,k)+ w;

    % Take measurement
    % Select a motion disturbance
    v  = [R(1,1)*randn(1);R(2,2)*randn(1)];
    % Determine measurement
    h1x=double(h1(x(1,k+1)));
    h2x=double(h2(x(1,k+1)));
    y(:,k) = [h1x;h2x] + v; %voltage measurement

    
    %% Kalman Filter Estimation
    % Store prior
    xhat_old = xhat;
    P_old = P;

    % Prediction update
    xhat_k = A*xhat;
    P_predict = A*P*A' + Q;

    % Measurement update
    hx=[double(H1x(xhat_k(1,1))) 0;double(H2x(xhat_k(1,1))) 0]; %linearize sensor matrix
    K = P_predict*hx'*inv(hx*P_predict*hx'+R);
    xhat = xhat_k + K*(y(:,k)-hx*xhat_k);
    P = (1-K*hx)*P_predict;
    
    %Store estimates
    xhat_S(:,k)= xhat_k;
    x_S(:,k)= xhat;
    y_hat(:,k) = hx*xhat;
   
end
figure;
subplot(2,2,1)
hold on
plot(T,x(1,2:end)) %State
plot(T,x_S(1,:))
plot(T,xhat_S(1,:)) %Prediction
title('State and Estimates')
legend('State', 'Estimate','prediction');

subplot(2,2,2)
hold on;
plot(T,x_S(2,:))%Estimate
plot(T,x(2,2:end))
%plot(T,xhat_S(2,:)) %Prediction

subplot(2,2,3);
hold on
plot(T,y(1,:)) %Measurement sensor 1
plot(T,y_hat(1,:));
legend('Measurement', 'Prediction');

subplot(2,2,4)
hold on
plot(T,y(2,:)) %Measurement sensor 2
plot(T,y_hat(2,:));

