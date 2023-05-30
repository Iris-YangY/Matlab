%First set up ODE as a system 
function quiz_chemical_kinetics_0();
T_max=100; %our final time for envolving the systems 
dt=1/100;
rng(0);%Random seed: Initial value
y_=rand(1);%Initial solution vector
[T_out_, Y_out_]=ode45(@ODE_RHS, [0:dt:T_max], y_);

%Some plotting command 
figure(1);clf;set(gca,'Position', 1+[0,0, 1024, 1024]);
subplot(2,2,1);
plot(T_out_, Y_out_);
legend({'rng(0)'}, 'Location', 'SouthEast');
xlabel('time'); xlim([0,T_max]);
ylabel('Concentrate');
title('dAdt= 0.17A^2-0.05A^3')
hold on;
%dAdt= 0.17A^2

rng(5);
a_=rand(1);%Initial solution vector
[T_out_, Y_out_]=ode45(@ODE_RHS, [0:dt:T_max], a_);
subplot(2,2,2);
plot(T_out_, Y_out_);
legend({'rng(5)'}, 'Location', 'SouthEast');
xlabel('time'); xlim([0,T_max]);
ylabel('Concentrate');
title('Chemical Kinectics')
hold on;

rng(10);
b_=rand(1);%Initial solution vector
[T_out_, Y_out_]=ode45(@ODE_RHS, [0:dt:T_max], b_);
subplot(2,2,3);
plot(T_out_, Y_out_);
legend({'rng(10)'}, 'Location', 'SouthEast');
xlabel('time'); xlim([0,T_max]);
ylabel('Concentrate');
title('Chemical Kinectics')
hold on;

rng(20);
c_=rand(1);%Initial solution vector
[T_out_, Y_out_]=ode45(@ODE_RHS, [0:dt:T_max], c_);
subplot(2,2,4);
plot(T_out_, Y_out_);
legend({'rng(20)'}, 'Location', 'SouthEast');
xlabel('time'); xlim([0,T_max]);
ylabel('Concentrate');
title('Chemical Kinectics')
hold off;

%Define a function
function ODE_LHS =ODE_RHS(t,y);
%function ODE takes two input: time and solution vector 
alpha=0.170;
beta=0.050;
A=y;
frwd_reation=alpha*A^2;
back_reaction=beta*A^3;
%dAdt= +1*frwd_reation
dAdt= +1*frwd_reation-back_reaction
ODE_LHS= dAdt;

%%%%%%%%;
% Older versions of matlab required an "end" at the end of a function declaration. ;
% But newer versions do not. ;
%%%%%%%%;
