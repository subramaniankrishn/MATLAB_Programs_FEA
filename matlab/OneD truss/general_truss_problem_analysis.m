%Reading the inputs from the text file.

clear all
clc

load test.txt

temp_count = 1;
numele = test(temp_count,1);
temp_count = temp_count + 1;

numnode = test(temp_count,1);
temp_count = temp_count + 1;

nodes(1,1:numele) = test(temp_count,1:numele);
temp_count = temp_count + 1;
nodes(2,1:numele) = test(temp_count,1:numele);
temp_count = temp_count + 1;

nodes_pos(1,1:numnode) = test(temp_count,1:numnode);
temp_count = temp_count + 1;
nodes_pos(2,1:numnode) = test(temp_count,1:numnode);
temp_count = temp_count + 1;

E(1:numele) = test(temp_count,1:numele);
temp_count = temp_count + 1;
A(1:numele) = test(temp_count,1:numele);
temp_count = temp_count + 1;

ifix_ = test(temp_count,:);
ifix = ifix_(1:numnode*2);
temp_count = temp_count + 1;
force_ = test(temp_count,:);
force_ = force_';
force = force_(1:numnode*2);

temp_count = temp_count + 1;
boundary_displacement = test(temp_count,:);


bigK = zeros(numnode*2);

for i=1:numele
    le(i) = sqrt( ( nodes_pos(2, nodes(2,i)) - nodes_pos(2, nodes(1,i)) ) * ( nodes_pos(2, nodes(2,i)) - nodes_pos(2, nodes(1,i)) ) + ( nodes_pos(1, nodes(2,i)) - nodes_pos(1, nodes(1,i)) ) * ( nodes_pos(1, nodes(2,i)) - nodes_pos(1, nodes(1,i)) )  );
    ke = E(i)*A(i)/le(i)
        
    c  = (nodes_pos(1, nodes(2,i)) - nodes_pos(1, nodes(1,i)))/le(i);
    s = ( nodes_pos(2, nodes(2,i)) - nodes_pos(2, nodes(1,i)) )/le(i);
    
    cos_matrix(i) = c;
    sin_matrix(i) = s;
    
    k = ke*[c*c c*s -c*c -c*s; c*s s*s -c*s -s*s; -c*c -c*s c*c c*s; -c*s -s*s c*s s*s];
    
    bigK(nodes(1,i)*2 - 1, nodes(1,i)*2 - 1) = bigK(nodes(1,i)*2 - 1, nodes(1,i)*2 - 1) + k(1,1);
    bigK(nodes(1,i)*2    , nodes(1,i)*2 - 1) = bigK(nodes(1,i)*2    , nodes(1,i)*2 - 1) + k(2,1);
	bigK(nodes(1,i)*2 - 1, nodes(1,i)*2    ) = bigK(nodes(1,i)*2 - 1, nodes(1,i)*2    ) + k(1,2);
    bigK(nodes(1,i)*2    , nodes(1,i)*2    ) = bigK(nodes(1,i)*2    , nodes(1,i)*2    ) + k(2,2);
    
    bigK(nodes(1,i)*2 - 1, nodes(2,i)*2 - 1) = bigK(nodes(1,i)*2 - 1, nodes(2,i)*2 - 1) + k(1,3);
    bigK(nodes(1,i)*2 - 1, nodes(2,i)*2    ) = bigK(nodes(1,i)*2 - 1, nodes(2,i)*2    ) + k(1,4);
	bigK(nodes(1,i)*2    , nodes(2,i)*2 - 1) = bigK(nodes(1,i)*2    , nodes(2,i)*2 - 1) + k(2,3);
    bigK(nodes(1,i)*2    , nodes(2,i)*2    ) = bigK(nodes(1,i)*2    , nodes(2,i)*2    ) + k(2,4);
    
    bigK(nodes(2,i)*2 - 1, nodes(1,i)*2 - 1) = bigK(nodes(2,i)*2 - 1, nodes(1,i)*2 - 1) + k(3,1);
    bigK(nodes(2,i)*2 - 1, nodes(1,i)*2    ) = bigK(nodes(2,i)*2 - 1, nodes(1,i)*2    ) + k(4,1);
	bigK(nodes(2,i)*2    , nodes(1,i)*2 - 1) = bigK(nodes(2,i)*2    , nodes(1,i)*2 - 1) + k(3,2);
    bigK(nodes(2,i)*2    , nodes(1,i)*2    ) = bigK(nodes(2,i)*2    , nodes(1,i)*2    ) + k(4,2);
    
    bigK(nodes(2,i)*2 - 1, nodes(2,i)*2 - 1) = bigK(nodes(2,i)*2 - 1, nodes(2,i)*2 - 1) + k(3,3);
    bigK(nodes(2,i)*2    , nodes(2,i)*2 - 1) = bigK(nodes(2,i)*2    , nodes(2,i)*2 - 1) + k(4,3);
	bigK(nodes(2,i)*2 - 1, nodes(2,i)*2    ) = bigK(nodes(2,i)*2 - 1, nodes(2,i)*2    ) + k(3,4);
    bigK(nodes(2,i)*2    , nodes(2,i)*2    ) = bigK(nodes(2,i)*2    , nodes(2,i)*2    ) + k(4,4);
    
end

modified_bigK = bigK(1:(numnode*2),1:(numnode*2));


for i=1:2*numnode
    if(ifix(i) == -1)
        for j = 1:2*numnode
        force(j) = force(j) - boundary_displacement(i) * modified_bigK(j,i);
        modified_bigK(j,i) = 0;
        modified_bigK(i,j) = 0;
        end
        modified_bigK(i,i) = 1;
        force(i) = boundary_displacement(i);
    end
    
    if(ifix(i) == 1)
        modified_bigK(:,i) = 0;
        modified_bigK(i,:) = 0;
        modified_bigK(i,i) = 1;
    end
end


displacement = modified_bigK\force


new_displaced_positions = zeros(2,numnode);
for i = 1:numnode
displacement_matrix(1,i) = displacement(i*2 - 1);
displacement_matrix(2,i) = displacement(i*2);

new_displaced_positions(1,i) = nodes_pos(1,i)+displacement_matrix(1,i);
new_displaced_positions(2,i) = nodes_pos(2,i)+displacement_matrix(2,i);

display_positions(1,i) = nodes_pos(1,i)+displacement_matrix(1,i)*10000;
display_positions(2,i) = nodes_pos(2,i)+displacement_matrix(2,i)*10000;
end

for i=1:numele
    stress(i) = E(i)/le(i) * (cos_matrix(i)*(displacement_matrix(1,nodes(2,i)) - displacement_matrix(1,nodes(1,i))) + sin_matrix(i)*(displacement_matrix(2,nodes(2,i)) - displacement_matrix(2,nodes(1,i))));
end

stress

count = 1;
for i = 1:numele
    xx(count) = nodes_pos(1,nodes(1,i));
    yy(count) = nodes_pos(2,nodes(1,i));
    
    xx(count+1) = nodes_pos(1,nodes(2,i));
    yy(count+1) = nodes_pos(2,nodes(2,i));
    
    xx1(count) = display_positions(1,nodes(1,i));
    yy1(count) = display_positions(2,nodes(1,i));
    
    xx1(count+1) = display_positions(1,nodes(2,i));
    yy1(count+1) = display_positions(2,nodes(2,i));
    
    count = count + 2;
end

subplot(211);
plot(xx,yy,'r', xx1,yy1,'b-.','LineWidth',3)
axis ([-0.1 2.1 -0.1 1.1])
title('Deformed truss');xlabel('x');ylabel('y');
legend('Original truss', 'Deformed truss');
hold off
subplot(212);


for ie=1:numele 
   plot([ie,ie+1],[stress(ie),stress(ie)]); 
   hold on; 
end
title('Element stresses');xlabel('Element No');ylabel('Stresses');






