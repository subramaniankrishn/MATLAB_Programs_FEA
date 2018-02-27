function [ ] = meshdraw( gcoord, nodes, disp, nelnode )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


temp = size(gcoord); %num nodes
nnode = temp(1);

temp = size(nodes);
nel = temp(1);

gcoord_disp = gcoord;

for i = 1:nnode
    gcoord_disp(i,1) = gcoord_disp(i,1) + 1000*disp(2*i-1);
    gcoord_disp(i,2) = gcoord_disp(i,2) + 1000*disp(2*i);
end

for ielp = 1:nel
    nd(1)=nodes(ielp,1); % 1st connected node for (iel)-th element
    nd(2)=nodes(ielp,2); % 2nd connected node for (iel)-th element
    nd(3)=nodes(ielp,3); % 3rd connected node for (iel)-th element
    
    x1=gcoord(nd(1),1); y1=gcoord(nd(1),2);% coord values of 1st node
    x2=gcoord(nd(2),1); y2=gcoord(nd(2),2);% coord values of 2nd node
    x3=gcoord(nd(3),1); y3=gcoord(nd(3),2);% coord values of 3rd node
    
    x1d=gcoord_disp(nd(1),1); y1d=gcoord_disp(nd(1),2);% coord values of 1st node
    x2d=gcoord_disp(nd(2),1); y2d=gcoord_disp(nd(2),2);% coord values of 2nd node
    x3d=gcoord_disp(nd(3),1); y3d=gcoord_disp(nd(3),2);% coord values of 3rd node
       
    if nelnode == 4        
        nd(4)=nodes(ielp,4); % 4th connected node for (iel)-th element
        x4=gcoord(nd(4),1); y4=gcoord(nd(4),2);% coord values of 4th node
        x4d=gcoord_disp(nd(4),1); y4d=gcoord_disp(nd(4),2);% coord values of 4th node
    end
    
    if nelnode == 3
        orig_x = [x1 x2 x3 x1];
        orig_y = [y1 y2 y3 y1];
        
        disp_x = [x1d x2d x3d x1d];
        disp_y = [y1d y2d y3d y1d];
    end
    if nelnode == 4
        orig_x = [x1 x2 x3 x4 x1];
        orig_y = [y1 y2 y3 y4 y1];
        
        disp_x = [x1d x2d x3d x4d x1d];
        disp_y = [y1d y2d y3d y4d y1d];
    end
    
    figure(100);
    hold on
    plot(orig_x, orig_y);
    
    
    figure(101);
    hold on
    plot(disp_x, disp_y, 'r-');    
end

figure(100);
axis([-21 21 -1.5 1.5]);

figure(101);
axis([-21 21 -1.5 1.5]);