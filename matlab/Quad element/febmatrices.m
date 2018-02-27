function [ Bmat_pp, Bmat_mp, Bmat_mm, Bmat_pm ] = febmatrices (Jpp, Jmp, Jmm, Jpm)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here



eta = 1/sqrt(3);
rho = 1/sqrt(3);
det_pp = det(Jpp);
Bmat_pp = [1 0 0 0; 0 0 0 1; 0 1 1 0]*1/det_pp;
Bmat_pp = Bmat_pp * [Jpp(2,2) -Jpp(2,1) 0 0; -Jpp(1,2) Jpp(1,1) 0 0; 0 0 Jpp(2,2) -Jpp(2,1); 0 0 -Jpp(1,2) Jpp(1,1)];
Bmat_pp = Bmat_pp *0.25*[eta-1 0 1-eta 0 1+eta 0 -1-eta 0; rho-1 0 -1-rho 0 1+rho 0 1-rho 0; 0 eta-1 0 1-eta 0 1+eta 0 -1-eta; 0 rho-1 0 -1-rho 0 1+rho 0 1-rho];


eta = -1/sqrt(3);
rho = 1/sqrt(3);
det_mp = det(Jmp);
Bmat_mp = [1 0 0 0; 0 0 0 1; 0 1 1 0]*1/det_mp;
Bmat_mp = Bmat_mp * [Jmp(2,2) -Jmp(2,1) 0 0; -Jmp(1,2) Jmp(1,1) 0 0; 0 0 Jmp(2,2) -Jmp(2,1); 0 0 -Jmp(1,2) Jmp(1,1)];
Bmat_mp = Bmat_mp * 0.25 * [eta-1 0 1-eta 0 1+eta 0 -1-eta 0; rho-1 0 -1-rho 0 1+rho 0 1-rho 0; 0 eta-1 0 1-eta 0 1+eta 0 -1-eta; 0 rho-1 0 -1-rho 0 1+rho 0 1-rho];


eta = -1/sqrt(3);
rho = -1/sqrt(3);
det_mm = det(Jmm);
Bmat_mm = [1 0 0 0; 0 0 0 1; 0 1 1 0]*1/det_mm;
Bmat_mm = Bmat_mm * [Jmm(2,2) -Jmm(2,1) 0 0; -Jmm(1,2) Jmm(1,1) 0 0; 0 0 Jmm(2,2) -Jmm(2,1); 0 0 -Jmm(1,2) Jmm(1,1)];
Bmat_mm = Bmat_mm * 0.25 * [eta-1 0 1-eta 0 1+eta 0 -1-eta 0; rho-1 0 -1-rho 0 1+rho 0 1-rho 0; 0 eta-1 0 1-eta 0 1+eta 0 -1-eta; 0 rho-1 0 -1-rho 0 1+rho 0 1-rho];


eta = 1/sqrt(3);
rho = -1/sqrt(3);
det_pm = det(Jpm);
Bmat_pm = [1 0 0 0; 0 0 0 1; 0 1 1 0]*1/det_pm;
Bmat_pm = Bmat_pm * [Jpm(2,2) -Jpm(2,1) 0 0; -Jpm(1,2) Jpm(1,1) 0 0; 0 0 Jpm(2,2) -Jpm(2,1); 0 0 -Jpm(1,2) Jpm(1,1)];
Bmat_pm = Bmat_pm * 0.25 * [eta-1 0 1-eta 0 1+eta 0 -1-eta 0; rho-1 0 -1-rho 0 1+rho 0 1-rho 0; 0 eta-1 0 1-eta 0 1+eta 0 -1-eta; 0 rho-1 0 -1-rho 0 1+rho 0 1-rho];
