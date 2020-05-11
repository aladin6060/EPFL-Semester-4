%% Pole placement
clc; close all; clear all;

load Gyro300
Z=iddata(y,u,Ts);
Zd=detrend(Z);
G1 = oe(Zd,[6 6 1]);
G1f=spa(Zd,100);

load Gyro400
Z=iddata(y,u,Ts);
Zd=detrend(Z);
G2 = oe(Zd,[6 6 1]);
G2f=spa(Zd,100);

load Gyro500
Z=iddata(y,u,Ts);
Zd=detrend(Z);
G3 = oe(Zd,[6 6 1]);
G3f=spa(Zd,100);

clear Z
clear Zd
%% Extracting the coefficients of the polynomials A & B

B=G2.b;
A=G2.f;

%% Dominant poles
overshoot=0.05;
Tset=0.6;
dampfact=sqrt(log(overshoot)^2/(log(overshoot)^2+pi^2));
natfreq=-log(0.02)/(dampfact*Tset);
p1=-2*exp(-dampfact*natfreq*Tset)*cos(natfreq*Ts*sqrt(1-dampfact^2));
p2=exp(-2*dampfact*natfreq*Tset);
P=[1;p1;p2];

%% Find R & S
H_S=[1,-1]; %integrator
H_R=[1,1]; %open loop at Nyqu frequ

[R,S]=poleplace(B,A,H_R,H_S,P);

%% Verify closed loop poles
P_achieved=conv(A,S)+conv(B,R)