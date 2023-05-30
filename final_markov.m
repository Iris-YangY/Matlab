n_side = 192;
n_point = n_side^2;
step = 2;
L = 1 + 2*step*(step+1);
%%%%%%%%;
P_index_col_ = zeros(L*n_point,1);
P_index_row_ = zeros(L*n_point,1);
count=0;
for k = 0:n_point-1;
j = floor(k/n_side);
i = mod(k,n_side);
for n = -step:step; %-4:4
if (j+n< 0); j = j+n + n_side;
elseif (j+n>= n_side); j = j+n - n_side;
else j = j+n;
end;
for m= -step+abs(n) : step-abs(n);
if (i+m< 0); i = i+m + n_side;
elseif (i+m>= n_side); i = i+m - n_side;
else i = i+m;
end;
P_index_row_(1+count) = k;
P_index_col_(1+count) = j*n_side+i;

count = count+1;
j = floor(k/n_side);
i = mod(k,n_side);
end;%for k = 0:n_point-1;
end;%for n = -step:step;
end;%for m= -step+abs(n) : step-abs(n);
P__ = sparse(1+P_index_row_,1+P_index_col_,1/L,n_point,n_point);
[V__,D__] = eigs(P__,6); D_ = diag(D__); %<-- note that the second largest
%eigenvalue is very close to 1. This implies very slow decay (for the lowest
%eigenmodes). ;
n_t = 4*ceil(log(0.5)/log(D_(2))); %<-- we make sure to take sufficiently many
%timesteps so that the slowest decaying mode will be reduced by a factor of 2. ;
Y__ = zeros(n_point,n_t);
initial_i = 96; initial_j = 96;
Y__(((initial_j - 1)*n_side + initial_i),1) = 1; %<-- initial ensemble-distribution: starting
%with an ensemble all concentrated at a single point. ;
for nt=1:n_t-1;
Y__(:,1+nt) = P__*Y__(:,1+nt-1);
end;%for nt=1:n_t-1;
%
figure(1); clf;
subplot(3,4,1);
imagesc(P__,[0,1/L]); axis image;
title('state-transition');
nf=0;
for nf=0:6-1;
subplot(3,4,1+1+nf);
plot(0:n_point-1,V__(:,1+nf),'.-');
title(sprintf('ev %d , ew %0.6f',1+nf,D_(1+nf)));
end;%for nf=0:6-1;
n_t_pick = floor(linspace(1, n_t, 5));
for np = 1:5;
subplot(3,4,7+np);
%subplot(3,4,8);
% imagesc(log(Y__));
temp = reshape(Y__(:, n_t_pick(np)), [n_side,n_side]);
% imagesc(log(Y__),[-9,0]);
imagesc(temp);
colorbar;
% xlabel('time');
% ylabel('point');
title(sprintf('ensemble, t = %d', n_t_pick(np)));
%set(gcf,'Position',1+[0,0,1024*2,1024]);
set(gcf,'Position',1+[0,0,1024*2,1024*1]);
end;%for np = 1:5;