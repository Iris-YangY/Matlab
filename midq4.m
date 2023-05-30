function ODEflow_ver4();
% This function plots a simple vector field and trajectory for an ODE ;

%%%%%%%%;
% Here we define the y-limits of the vector field ;
% as it is visualized in the visual field of the picture. ;
%%%%%%%%;
y1_lim_ = [-3,+3]*pi; y2_lim_ = [-3,+3]*pi; %<-- between plus-or-minus 3*pi. ;
n_bin = 48; %<-- This determines the number of arrows along a side. ;
y1_val_ = linspace(y1_lim_(1),y1_lim_(2),n_bin); %<-- defining the y1-values to be equispaced between the y-limits, with a number of points equal to n_bin. ;
y1_val_ = reshape(y1_val_,1,length(y1_val_)); %<-- We force the answer to look like a row-vector (with reshape). This will come in handy below. ; 
y2_val_ = linspace(y2_lim_(1),y2_lim_(2),n_bin); %<-- we do the same for y2. ;
y2_val_ = reshape(y2_val_,1,length(y2_val_)); %<-- again forcing into a row-vector. ;
%%%%%%%%;
y__ = zeros(2,length(y1_val_)*length(y2_val_)); %<-- creating a big 2-by-n_bin^2 array of y-values, each column of which will correspond to a particular point in the y1-y2-plane. ;
rhs__ = zeros(2,length(y1_val_)*length(y2_val_)); %<-- creating a big 2-by-n_bin^2 array of velocity-vectors, each column holds the velocity-vector of a particular point in the y1-y2-plane. ;
%%%%%%%%;
% At this point y__ and rhs__ are set up to store the position-vectors (y1,y2) and the velocity-vectors (dy1/dt,dy2/dt) for each point in a grid of n_bin-by-n_bin points in the y1-y2 plane. ;
% Of course, we have to fill in this grid, which we do below. ;
%%%%%%%%;
tmp = repmat(y1_val_,length(y2_val_),1); %<-- replicates y1_val_ n_bin times vertically. Put another way, it stacks n_bin copies of y1_val_ on top of one another (remember that y1_val_ is a row-vector). So now tmp is a 'matrix' where every single row looks like y1_val_. ;
tmp=reshape(tmp,1,length(y1_val_)*length(y2_val_)); %<-- now we unroll this matrix, turning it into a long array of length n_bin^2. ;
%%%%%%%%;
% What do I mean by unrolling an array? ;
% Every time a multi-dimensional array is stored in memory, ;
% it is not actually stored as an array. ;
% It is actually stored as a long vector (i.e., sequence). ;
% And the computer/program/language has to decide *how* it is stored. ;
% Most environments store 2-dimensional-arrays in: ;
% 'Fortran-style', which means that the row varies more quickly than the column. ;
% So an array like this: ;
% [ A11 , A12 ]
% [ A21 , A22 ]
% it would be stored like this:
% [A11 , A21 , A12 , A22 ]. ;
% Occasionally you run into a wonky environment that stores things in: ;
% 'C-style', which means that the col varies more quickly than the row. ;
% So an array like this: ;
% [ A11 , A12 ]
% [ A21 , A22 ]
% it would be stored like this:
% [A11 , A12 , A21 , A22 ]. ;
% Generally, try and avoid C-style like the plague, and train your brain to think in fortran-style. Obviously. ;
%%%%%%%%;
y__(1,:) = tmp; %<-- we fill in the first row of y__ with the unrolled version of the duplicated array of y1_val_. ;
tmp = repmat(y2_val_,1,length(y1_val_));
y__(2,:) = tmp; %<-- we fill in the second row of y__ with the unrolled version of the duplicated array of y2_val_. ;
clear tmp;
%%%%%%%%;
% Now, at this point, column: ;
% nbin = 1 + (ny1-1) + (ny2-1)*n_bin ;
% of y__ contains the two entries ;
% y1_val_(ny1) and y2_val_(ny2). ;
% i.e., try: ;
%{
  plot(y__(1,:) , y__(2,:),'x'); %<-- you should see a n_bin-by-n_bin grid. ;
  %}
%%%%%%%%;
rhs__ = my_ode(0,y__); %<-- the right-hand-side function (below) is specifically written (and indeed, matlab expects it to be written) such that it can simultaneously evaluate the velocity-vectors associated with each column of a giant 2-by-N array all at once. ;
%%%%%%%%;
% Now at this point each column of rhs__ corresponds to the derivative-vector associated with the corresponding column of y__. ;
%%%%%%%%;

%%%%%%%%;
% This next paragraph plots a colored arrow for each velocity vector. ;
%%%%%%%%;
dy1 = diff(y1_lim_)/n_bin;
dy2 = diff(y2_lim_)/n_bin;
theta_ = atan2(rhs__(2,:)/dy2,rhs__(1,:)/dy1);
cos_ = cos(theta_); sin_ = sin(theta_);
v_ = sqrt((rhs__(2,:)/dy2).^2 + (rhs__(1,:)/dy1).^2);
v_mean = mean(v_); v_std = std(v_); v_lim_ = v_mean+[-1,+1]*1.5*v_std; v_lim_(1)=max(0,v_lim_(1)); v_lim_(2) = min(max(v_),v_lim_(2));
cmap = colormap('cool');
ncbins = length(cmap);
cbin_ = 1 + min(ncbins-1,max(0,floor(ncbins*(v_-v_lim_(1))/diff(v_lim_))));
cload = transpose(cmap(cbin_,:));
dl = 0.45;
lx = [y__(1,:) + dl*dy1*cos_ ; y__(1,:) - dl*dy1*cos_];
ly = [y__(2,:) + dl*dy2*sin_ ; y__(2,:) - dl*dy2*sin_];
for nl=1:size(lx,2);
hold on;
l = line(lx(:,nl),ly(:,nl),'Color',cload(:,nl));
hold off;
end;%for nl=1:size(lx,2);

%%%%%%%%;
% Here are a few trajectories, starting at different initial conditions ;
% you should play around with these initial conditions ;
%%%%%%%%;

t_0in_ = [0:0.001:25]; %<-- define the time-series we want matlab to use when determining the solution trajectory for any particular initial-value. ;
linewidth_use = 3; %<-- line width to use. ;

[t_out_,y_out__] = ode45(@my_ode,t_0in_,[1.0;-3]); % <-- initial condition (1.0 , -3) ;
hold on;
plot(y_out__(1,1),y_out__(1,2),'ko','LineWidth',linewidth_use);
plot(y_out__(:,1),y_out__(:,2),'k-','LineWidth',linewidth_use);
hold off;

[t_out_,y_out__] = ode45(@my_ode,t_0in_,[0.1;3]); % <-- initial condition ( 0.1 , +3) ;
hold on;
plot(y_out__(1,1),y_out__(1,2),'ro','LineWidth',linewidth_use);
plot(y_out__(:,1),y_out__(:,2),'r-','LineWidth',linewidth_use);
hold off;

[t_out_,y_out__] = ode45(@my_ode,t_0in_,[-2.0;0]);  % <-- initial condition (-2.0 , 0.0) ;
hold on;
plot(y_out__(1,1),y_out__(1,2),'bo','LineWidth',linewidth_use);
plot(y_out__(:,1),y_out__(:,2),'b-','LineWidth',linewidth_use);
hold off;

rng(0);
for nl=0:16-1;
[t_out_,y_out__] = ode45(@my_ode,t_0in_,3*pi*(2*rand(1,2)-1)); % <-- initial condition random ;
hold on;
plot(y_out__(1,1),y_out__(1,2),'co','LineWidth',linewidth_use);
plot(y_out__(:,1),y_out__(:,2),'c-','LineWidth',linewidth_use);
hold off;
end;%for nl=0:16-1;

xlim(y1_lim_); xlabel('$\theta$ variable','Interpreter','latex');
ylim(y2_lim_); ylabel('$\omega$ variable','Interpreter','latex');
cbar = colorbar; ylabel(cbar,'velocity');
axis square;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rhs = my_ode(t,y);
% Here is a simple ODE, you should play around with the constants alpha and beta. ;
% More generally, you should play around with the right-hand-side. ;
%alpha = +1.5;
%beta =  +2.5;
%rhs = [0 1 ; -1 0]*y - 0.02*eye(2)*y ...
%  + alpha*[ y(1,:).*y(2,:).^2 ; cos(y(1,:)) + y(2,:).^2 ].*[ exp(-(y(1,:).^2 + y(2,:).^2)/2) ; exp(-(y(1,:).^2 + y(2,:).^2)/4) ] ...
%  + beta*[ y(1,:).^3.*sin(y(2,:)) ; y(1,:).*y(2,:).^2 ].*[ exp(-(y(1,:).^2 + y(2,:).^2)/4) ; exp(-(y(1,:).^2 + y(2,:).^2)/2) ] ...
%;
GoverL = 4.0; % ratio between the gravitational constant and the length of the pendulum; say 1 for now; 
f = -0.15; % friction coefficient --> should be small and positive ;
%f = 0.15;
theta = y(1,:); % angular position of pendulum ;
omega = y(2,:); % d(theta)/dt = angular velocity ;
%rhs = [ +y(2,:) ; -GoverL * sin(y(1,:)) - 2*f*y(2,:) ];
%rhs = [ +omega ; -GoverL * sin(theta) - 2*f*omega ]; % <-- original pendulum ;
rhs = [ +omega ; GoverL*theta - 2*f*omega ]; % <-- linearized version ;
