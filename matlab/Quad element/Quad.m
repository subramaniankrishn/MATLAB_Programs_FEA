%----------------------------------------------------------------------------
%   plane stress analysis of a solid using linear triangular elements           
%
% Variable descriptions                                                      
%   k = element matrix                                             
%   f = element vector
%   kk = system matrix                                             
%   ff = system vector                                                 
%   disp = system nodal displacement vector
%   eldisp = element nodal displacement vector
%   stress = matrix containing stresses
%   strain = matrix containing strains
%   gcoord = coordinate values of each node
%   nodes = nodal connectivity of each element
%   index = a vector containing system dofs associated with each element     
%   bcdof = a vector containing dofs associated with boundary conditions     
%   bcval = a vector containing boundary condition values associated with    
%           the dofs in 'bcdof'                                              
%----------------------------------------------------------------------------            

%------------------------------------
%  input data for control parameters
%------------------------------------

clear all
clc

nnel=4;                  % number of nodes per element
ndof=2;                  % number of dofs per node
edof=nnel*ndof;          % degrees of freedom per element

poisson=0.3;             % Poisson's ratio

%---------------------------------------------
%  input data for nodal coordinate values
%  gcoord(i,j) where i->node no. and j->x or y
%---------------------------------------------

%---------------------------------------------------------
%  input data for nodal connectivity for each element
%  nodes(i,j) where i-> element no. and j-> connected nodes
%---------------------------------------------------------

    load elem_conn.txt
    load nodes_coord.txt
    
    temp = size(elem_conn);
    nel = temp(1);
    

    temp = size(nodes_coord);
    nnode = temp(1);
    sdof=nnode*ndof;         % total system dofs  
    
    gcoord = zeros(nnode,2);
    
    for i = 1:nnode
        gcoord(i,1) = nodes_coord(i,2);
        gcoord(i,2) = nodes_coord(i,3);
    end
    
    emodule = zeros(nel,1);
    nodes = zeros(nel,3);
    
    for i = 1:nel
        emodule(i) = elem_conn(i,2);
        nodes(i,1) = elem_conn(i,3);
        nodes(i,2) = elem_conn(i,4);
        nodes(i,3) = elem_conn(i,5);
        nodes(i,4) = elem_conn(i,6);
    end



%-------------------------------------
%  input data for boundary conditions
%-------------------------------------

%-----------------------------------------
%  initialization of matrices and vectors
%-----------------------------------------

ff=zeros(sdof,1);       % system force vector


    load loads.txt
    
    temp = size(loads);
        
    for i=1:temp(1)/2
        n1 = loads(2*i-1,1); n2 = loads(2*i,1);
       ff(2*n1) = ff(2*n1) + loads(2*i-1,2)/2*sqrt( ( gcoord(n1,2)-gcoord(n2,2) )^2 + ( gcoord(n1,1)-gcoord(n2,1) )^2 );
       ff(2*n2) = ff(2*n2) + loads(2*i,2)/2*sqrt( ( gcoord(n1,2)-gcoord(n2,2) )^2 + ( gcoord(n1,1)-gcoord(n2,1) )^2 );
    end
    
    load bdry_cond.txt
    
    temp = size(bdry_cond);
    bcdof = zeros(temp(1),1);
    
    for i = 1:temp(1)
        bcdof(i) = bdry_cond(i,1);
    end
    bcval=zeros(temp(1),1);    


kk=zeros(sdof,sdof);    % system matrix
disp=zeros(sdof,1);     % system displacement vector
eldisp=zeros(edof,1);   % element displacement vector
stress=zeros(nel,3);    % matrix containing stress components
strain=zeros(nel,3);    % matrix containing strain components
index=zeros(edof,1);    % index vector
Bmtx2=zeros(3,edof);   % kinematic matrix
matmtx=zeros(3,3);      % constitutive matrix

%----------------------------
%  force vector
%----------------------------



%-----------------------------------------------------------------
%  computation of element matrices and vectors and their assembly
%-----------------------------------------------------------------

matmtx=fematiso(1,emodule(1),poisson);        % compute constitutive matrix

for iel=1:nel           % loop for the total number of elements
    
nd(1)=nodes(iel,1); % 1st connected node for (iel)-th element
nd(2)=nodes(iel,2); % 2nd connected node for (iel)-th element
nd(3)=nodes(iel,3); % 3rd connected node for (iel)-th element
nd(4)=nodes(iel,4); % 3rd connected node for (iel)-th element

x1=gcoord(nd(1),1); y1=gcoord(nd(1),2);% coord values of 1st node
x2=gcoord(nd(2),1); y2=gcoord(nd(2),2);% coord values of 2nd node
x3=gcoord(nd(3),1); y3=gcoord(nd(3),2);% coord values of 3rd node
x4=gcoord(nd(4),1); y4=gcoord(nd(4),2);% coord values of 4th node

index=feeldof(nd,nnel,ndof);% extract system dofs associated with element

[Jpp, Jmp, Jmm, Jpm] = jacobian_func(x1,y1,x2,y2,x3,y3,x4,y4);

[Bmat_pp, Bmat_mp, Bmat_mm, Bmat_pm] = febmatrices(Jpp, Jmp, Jmm, Jpm);

k = Bmat_pp'*matmtx*Bmat_pp*det(Jpp) + Bmat_mp'*matmtx*Bmat_mp*det(Jmp) + Bmat_mm'*matmtx*Bmat_mm*det(Jmm) + Bmat_pm'*matmtx*Bmat_pm*det(Jpm);

kk=feasmbl1(kk,k,index);  % assemble element matrices 
end

%-----------------------------
%   apply boundary conditions
%-----------------------------

[kk,ff]=feaplyc2(kk,ff,bcdof,bcval);

%----------------------------
%  solve the matrix equation
%----------------------------

disp=kk\ff;   

%---------------------------------------
%  plot the graph user defined nodes.
%---------------------------------------

load graphs_txt.txt
 
temp = size(graphs_txt);
 
for i = 1:temp(1)
    disp_array(i) = disp(2*graphs_txt(i,1));
    dist(i) = i-1;
end

figure(1);
plot(dist,disp_array);

meshdraw(gcoord,nodes,disp,4);