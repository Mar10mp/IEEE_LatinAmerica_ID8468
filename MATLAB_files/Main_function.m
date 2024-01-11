%% Buck Model parameters

% Second order plant model
ts = 0.000005;
num_Buck = [0 0 1152]; 
dem_Buck = [4.224e-7 0.00022 24];
%Desire Phase margin
Pmd = 55;
%% ----- Fractional aproximation
[Gp,N_alfa,s_alfa,Kc,Ti] = Buck_aproximation(num_Buck,dem_Buck,ts,Pmd);

%% Substitution in FOPID control structure
Gc = Kc * (((Ti * s_alfa) + 1)^2)/(s_alfa)

%% For visualization of results for the analog representation
Go=Gp*Gc;
figure(1), bode(Go);
figure(2),step(feedback(Gp*Gc,1))

% For discretization,a simplification and tustin discretization method is applied
Gcm=minreal(Gc,0.00001)
GpD = c2d(Gp,1/100000,'tustin')
GcmD = c2d(Gcm,1/100000,'tustin')

% To visualize TF for the digital implementation
[num,den] = tfdata(GcmD,'v')

% To plot resulting step response and bode plot for discrete representation
figure(3), step(feedback(GpD*GcmD,1))
figure(4), bode(GpD*GcmD,Gp*Gc)


%% Boost Model parameters
% Second order plant model (no minimal model)
ts = 0.000005;
num_Boost = [-19199.38562 921570509.7]; 
dem_Boost = [1 199.9936002 9418856.551];
%Desire Phase margin
Pmd = 55;
%% Fractional aproximation
[Gp_min,N_alfa,s_alfa,Kc,Ti] = Boost_aproximation(num_Boost,dem_Boost,ts,Pmd)
%% Substitution in FOPID control structure
Gc = Kc * (((Ti * s_alfa) + 1)^2)/(s_alfa)

%% For visualization of results for the analog representation
Go=Gp_min*Gc;
figure(5), bode(Go);
figure(6),step(feedback(Gp_min*Gc,1))

% For discretization,a simplification and tustin discretization method is applied
Gcm=minreal(Gc,0.00001)
GpD = c2d(Gp_min,1/100000,'tustin')
GcmD = c2d(Gcm,1/100000,'tustin')

% To visualize TF for the digital implementation
[num,den] = tfdata(GcmD,'v')

% To plot resulting step response and bode plot for discrete representation
figure(7), step(feedback(GpD*GcmD,1))
figure(8), bode(GpD*GcmD,Gp_min*Gc)
