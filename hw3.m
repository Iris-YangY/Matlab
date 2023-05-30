% 4A + 3B <--> 4C + 3D
% Forward reaction rate 0.160
% Backward reaction rate 0.080
clear;

P_frwd = @(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) placeholder_rate_frwd .* A.^4 .* B.^3 ;
P_back = @(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) placeholder_rate_back .* C.^4 .* D.^3 ;

ODE_RHS_A = @(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) - 4*P_frwd(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) + 4*P_back(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) ;
ODE_RHS_B = @(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) - 3*P_frwd(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) + 3*P_back(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) ;
ODE_RHS_C = @(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) + 4*P_frwd(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) - 4*P_back(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) ;
ODE_RHS_D = @(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) + 3*P_frwd(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) - 3*P_back(A,B,C,D,placeholder_rate_frwd,placeholder_rate_back) ;

rate_frwd = 0.160 ;
rate_back = 0.080 ;

ODE_RHS = @(t,Y_) [ ...
 ODE_RHS_A(Y_(1+0,:),Y_(1+1,:),Y_(1+2,:),Y_(1+3,:),rate_frwd,rate_back) ; ... 
 ODE_RHS_B(Y_(1+0,:),Y_(1+1,:),Y_(1+2,:),Y_(1+3,:),rate_frwd,rate_back) ; ...
 ODE_RHS_C(Y_(1+0,:),Y_(1+1,:),Y_(1+2,:),Y_(1+3,:),rate_frwd,rate_back) ; ...
 ODE_RHS_D(Y_(1+0,:),Y_(1+1,:),Y_(1+2,:),Y_(1+3,:),rate_frwd,rate_back) ; ...
];

T_max = 30; %<-- final time should be a bit larger than max(1/rate_frwd,1/rate_back), max(6.25, 12.5) ;
Y_ini_ = rand(4,1);
[t_ode_,Y_ode_] = ode23(ODE_RHS,[0,T_max],Y_ini_);
subplot(1,2,1);
plot(t_ode_,transpose(Y_ode_),'o-');
xlim([0,T_max]);
xlabel('time');
ylabel('concentration');
legend({'A','B','C','D'});
title('t_ode_','Interpreter','none');

t_lin_ = linspace(0,T_max,64);
[~,Y_lin_] = ode23(ODE_RHS,t_lin_,Y_ini_); 
subplot(1,2,2);
plot(t_lin_,transpose(Y_lin_),'o-');
xlim([0,T_max]);
xlabel('time');
ylabel('concentration');
legend({'A','B','C','D'});
title('t_lin_','Interpreter','none');
set(gcf,'Position',1+[0,0,1024,512]);