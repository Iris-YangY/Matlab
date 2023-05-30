t_ = 0:100;
N_t = numel(t_);
N = deal(zeros(N_t,1));
initial = 10;%0, 1, 2, 3, 10
N(1+0) = deal(initial);

for nt = 1:N_t-1
    N(1+nt) = N(1+nt-1)+0.17*N(1+nt-1)-0.05*4*pi*(3*N(1+nt-1)/(4*pi))^(2/3);
    %N(1+nt) = N(1+nt-1)+rate_survive*N(1+nt-1)-rate_die*4*pi*((0.75*N(1+nt-1)/pi)^(2/3));
end
plot(t_,N,"-r");
xlabel('Time');
ylabel('Numbers of cells remaining');
title(sprintf('Surface Ablation of Initial Condition = %0.1f', initial));