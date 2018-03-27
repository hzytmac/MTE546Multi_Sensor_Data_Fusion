close all;
clear;
clc;

import1=load('case2_T.mat');
v1=import1.data(:,1);
v2=import1.data(:,2);
v3=import1.data(:,3);
v4=import1.data(:,4);
v5=import1.data(:,5);
% initial occupancy grid map
ocmap_Thermo = 0.5*ones(10,10);

% temperature measurement (set by the user)
% will be replaced with the actuall data on experiment
T1=mean((v1-1.25)/(0.005*5)); % top left
T2=mean((v2-1.25)/(0.005*5)); % top right
T3=mean((v3-1.25)/(0.005*5)); % centre
T4=mean((v4-1.25)/(0.005*5)); % bot left
T5=mean((v5-1.25)/(0.005*5)); % bot right


% create the temperature map
T1_Map=zeros(10,10);
T2_Map=zeros(10,10);
T3_Map=zeros(10,10);
T4_Map=zeros(10,10);
T5_Map=zeros(10,10);
T_Map=zeros(10,10);

Tmax=8.6;
for i=1:1:10
    for j=1:1:10
        T1_Map(i,j)=T1+double(round(sqrt(i^2+j^2)))*0.2;
        T2_Map(i,j)=T2+double(round(sqrt(i^2+(11-j)^2)))*0.2;
        T4_Map(i,j)=T4+double(round(sqrt((11-i)^2+j^2)))*0.2;
        T5_Map(i,j)=T5+double(round(sqrt((11-i)^2+(11-j)^2)))*0.2;
        T3_Map(i,j)=T3+double(round(sqrt((5.5-(i-0.5))^2+(5.5-(j-0.5))^2)))*0.2;
    end
end

for i=1:1:10
    for j=1:1:10
        a=abs(Tmax-T1_Map(i,j));
        b=abs(Tmax-T2_Map(i,j));
        c=abs(Tmax-T3_Map(i,j));
        d=abs(Tmax-T4_Map(i,j));
        e=abs(Tmax-T5_Map(i,j));
        A=[a,b,c,d,e];
        if a==min(A)
            T_Map(i,j)=T1_Map(i,j);
        elseif b==min(A)
            T_Map(i,j)=T2_Map(i,j);
        elseif c==min(A)
            T_Map(i,j)=T3_Map(i,j);
        elseif d==min(A)
            T_Map(i,j)=T4_Map(i,j);
        else
            T_Map(i,j)=T5_Map(i,j);
        end
    end
end

% update the occupancy grid map
for i=1:1:10
    for j=1:1:10
        if abs(Tmax-T_Map(i,j))<=0.1
            ocmap_Thermo(i,j)=0.9;
        elseif Tmax-T_Map(i,j)<=0.15 && Tmax-T_Map(i,j)>0.1
            ocmap_Thermo(i,j)=0.7;
        else
            continue;
        end
    end
end

% create occunpacy grip mapping
image(100*ocmap_Thermo);
colormap(gray);

    




