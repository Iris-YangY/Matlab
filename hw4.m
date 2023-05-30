ODE_1d = @(y) 0.70.*y - 0.30.*(y-2).*(y+1) + 0.70.*cos(2.*pi*2.*y) + 0.70.*sin(2.*pi.*4.*y);
y_ = linspace(-2,+2,257);
subplot(1,2,1);
hold on;
plot(y_,ODE_1d(y_),'b-','LineWidth',2);
plot(y_,0*y_,'k-','LineWidth',2);
hold off;
grid on;
xlabel('y'); ylabel('dy/dt');
subplot(1,2,2);
T_max = 3;
n_t = 64; dt = T_max/n_t;
t_ = linspace(0,T_max,n_t);
n_y = 65; dy = 4/n_y;
y_ = linspace(-2,+2,n_y);
[T__,Y__] = ndgrid(t_,y_);
Vt__ = ones(n_t,n_y);
Vy__ = ODE_1d(Y__);
W__ = atan2(Vy__,Vt__);
Ut__ = cos(W__);
Uy__ = sin(W__);
r = min(dt,dy)*0.45;
T_pos__ = T__ + r*Ut__; T_pre__ = T__ - r*Ut__;
Y_pos__ = Y__ + r*Uy__; Y_pre__ = Y__ - r*Uy__;
hold on;
p = patch(transpose([T_pre__(:),T_pos__(:)]),transpose([Y_pre__(:),Y_pos__(:)]),'k');
ODE_RHS = @(t,y) ODE_1d(y);
n_iteration=35;
for niteration=0:n_iteration-1
Y_ini = -2 + 4/35*niteration;
[t_ode_,Y_ode_] = ode23(ODE_RHS,linspace(0,T_max,128),Y_ini);
plot(t_ode_,Y_ode_,'r-','LineWidth',2);
end
hold off;
xlabel('time'); ylabel('y');
xlim([0,T_max]);
ylim([-2,+2]);
% Yes, there are some stable fixed-points when dy/dt = 0, which means the
% graph intersects with the x-axis. As we can see through the graph, there
% are several intersections that indicate the fixed-points, and compared 
% with the y versus time graph, when time goes to infinity, some y-values 
% have asymptotes, which corresponding to the stable fixed points.