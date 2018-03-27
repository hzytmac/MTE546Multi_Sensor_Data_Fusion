close all;
clear;
clc;

% edge coordinate (set by user for simulation)
% will be replaced with the sensor model on the experiment
x=5;
y=5;

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
