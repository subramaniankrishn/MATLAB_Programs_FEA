function [ Jpp, Jmp, Jmm, Jpm ] = jacobian_func( x1,y1,x2,y2,x3,y3,x4,y4 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

coord_mat = [x1 y1;x2 y2;x3 y3; x4 y4];
eta = -1/sqrt(3);
rho = -1/sqrt(3);
Jmm = 0.25 * [eta-1 1-eta 1+eta -1-eta; rho-1 -1-rho 1+rho 1-rho]*coord_mat;

eta = 1/sqrt(3);
%rho = -1/sqrt(3);
Jpm = 0.25 * [eta-1 1-eta 1+eta -1-eta; rho-1 -1-rho 1+rho 1-rho]*coord_mat;

%eta = 1/sqrt(3);
rho = 1/sqrt(3);
Jpp = 0.25 * [eta-1 1-eta 1+eta -1-eta; rho-1 -1-rho 1+rho 1-rho]*coord_mat;

eta = -1/sqrt(3);
%rho = 1/sqrt(3);
Jmp = 0.25 * [eta-1 1-eta 1+eta -1-eta; rho-1 -1-rho 1+rho 1-rho]*coord_mat;



