function [Gp_Min,N_alfa,s_alfa,Kc,Ti] = Boost_aproximation(num,dem,ts,Pmd)
global plant
%% TF no minimal Phase
Gp=tf(num, dem,'inputDelay',ts);
%% Minimal Phase 
b = num(2);
a = -num(1);
Gp_Min=tf([a b], dem,'inputDelay',ts);

[Gm,Pm,Wcg,Wcp] = margin(Gp_Min);
plant.Buck.params = [Gm,Pm,Wcg,Wcp];
Pp=-180+Pm;

    
%% -- Configuration parameters --

% Intput the desired phase margin
Pmd

Wcf=Wcp;
alfa=(Pmd-180-Pp)/90;
Pc=(Pmd-180-Pp)*pi/180;
plant.Buck.DesireParams = [Wcf, alfa, Pc];
%% ----- Fractional Approximation -----
a0 = abs(alfa)^alfa + 3 * alfa + 2; 
a2 = abs(alfa)^alfa - 3 * alfa + 2;
a1 = 6 * alfa * tan ((2 - alfa) * pi / 4);

N_alfa = [a0 (a1 * Wcf) (a2 * Wcf^2)]; D_alfa = [a2 (a1 * Wcf) (a0 * Wcf^2)];
    
s_alfa = tf(N_alfa, D_alfa);

%% ----- Parameter approximations

% Ti initial aproximation

Ti=(tan(Pc/2)+tan((2+alfa)/(pi/4)))/(tan(Pc/2)-tan((2+alfa)/(pi/4)));

% From observed behaviour, you can manualy adjust Ti, or multiply it by a factor until desired
% behaviour is observed

Ti=Ti*5;

% Kc initial approximation

Kc=((0.5)*((a0-a2)^2 +(a1)^2))/((a0-a2)^2 *(1-Ti)^2 + (a1^2)*(1+Ti)^2)
end
