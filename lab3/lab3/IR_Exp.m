close all;
clear;
clc;

% edge coordinate (set by user for simulation)
% will be replaced with the sensor model on the experiment
import1=load('case1_IR_2.mat');
v1=import1.data(:,1);
v2=import1.data(:,2);
import2=load('case1_IR.mat');
v3=import2.data(:,3);
v4=import2.data(:,4);

% IR model
syms x
% short
f(x) = -2.362e-04*x^3+0.0155*x^2-0.3459*x+3.0776;
g = finverse(f);
% medium
m(x) = -1.36e-05*x^3+0.0024*x^2-0.1443*x+3.33;
n = finverse(m);
% long
p(x) = -2.11e-06*x^3+7.14e-04*x^2-0.0825*x+3.83;
q = finverse(p);

d1y=mean(double(g(v1)))-8;
d2y=mean(double(n(v2)))-8;
d1x=mean(double(q(v3)))-20;
d2x=mean(double(q(v4)))-20;

x=(d1x+d2x)/2;
y=(d1y+d2y)/2;

% round up the coordinate
x=round(x);
y=round(y);

% initial occupancy grid map
ocmap_IR = 0.5*ones(10,10);

% translation from distance to map index
row=y;
column=11-x;

if row==0
    row=row+1;
end

if column==11
    column=column-1;
end

% fill up the map
for i=row:1:row+2
    for j=column:-1:column-2
        if i>10 || i<1 || j<1 || j>10
            continue;
        else
            ocmap_IR(i,j)=0.9;
        end
    end
end



% create occunpacy grip mapping
image(100*ocmap_IR);
colormap(gray);
