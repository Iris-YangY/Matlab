% decay_probability = 46%, time scale in years
decay_probability = 0.46;
decay_rate = decay_probability/1;
N0 = 1e9;
t_ = 0:10;
n_t = numel(t_);
N_ = zeros(n_t,1);
N_(1+0) = N0;
for nt=1:n_t-1
    N_(1+nt) = N_(1+nt-1)*(1-decay_probability);
end

ODE_equation = @(t,N) -decay_rate.*N ;
[t_ode_,N_ode_] = ode23(ODE_equation,[0,10],N0);
figure(1);clf;
hold on;
plot(t_,N_,'go');
plot(t_ode_,N_ode_,'mx-');
hold off;
xlabel('Time in weeks'); ylabel('Number of atoms remaining'); 
title('Model of exponential decay in years for 46% decay probability');
legend({'Difference Equation','ODE Equation Solved'});
xlim([min(t_),max(t_)]);
ylim([0,N0]);