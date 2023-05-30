function [t_,y_] = pokemon_ode_ver1();

n_type = 0;
type_str{1+n_type} = 'normal'; n_type = n_type+1;
type_str{1+n_type} = 'fire'; n_type = n_type+1;
type_str{1+n_type} = 'water'; n_type = n_type+1;
type_str{1+n_type} = 'electric'; n_type = n_type+1;
type_str{1+n_type} = 'grass'; n_type = n_type+1;
type_str{1+n_type} = 'ice'; n_type = n_type+1;
type_str{1+n_type} = 'fighting'; n_type = n_type+1;
type_str{1+n_type} = 'poison'; n_type = n_type+1;
type_str{1+n_type} = 'ground'; n_type = n_type+1;
type_str{1+n_type} = 'flying'; n_type = n_type+1;
type_str{1+n_type} = 'psychic'; n_type = n_type+1;
type_str{1+n_type} = 'bug'; n_type = n_type+1;
type_str{1+n_type} = 'rock'; n_type = n_type+1;
type_str{1+n_type} = 'ghost'; n_type = n_type+1;
type_str{1+n_type} = 'dragon'; n_type = n_type+1;
type_str{1+n_type} = 'dark'; n_type = n_type+1;
type_str{1+n_type} = 'steel'; n_type = n_type+1;
type_str{1+n_type} = 'fairy'; n_type = n_type+1;
type_str{1+n_type} = 'phantom'; n_type = n_type+1;

quit_chance = input(sprintf(' %% enter quit_chance (default 0): ')); 
if (isempty(quit_chance)); quit_chance = 0.000; disp(sprintf(' %% using default quit_chance %f',quit_chance)); end;
A = pokematrix(); B = A./(A+transpose(A)); B(14,1)=0.5; B(1,14)=0.5; %normal-vs-ghost;

T0 = 0; TF = 256*4; t_ = linspace(T0,TF,1024*4);
%y_init = rand(19,1); y_init = y_init/sum(y_init); %<-- random initial data will produce different results from trial to trial. ;
y_init = ones(19,1); y_init = y_init/sum(y_init); %<-- fixed initial data will always produce the same result! ;
[t_,y_] = ode45(@(t,y) pokefun(t,y,B,quit_chance),t_,y_init);
figure;cla;
plot(t_,y_); xlim([0,max(t_)]);
legend(type_str);
y_avg = mean(y_,1);
[tmp,ij] = max(y_avg); title(sprintf('type %s wins on average! (TF %0.2f)',type_str{ij},TF));
[tmp,ij] = sort(y_avg,'descend');
for nr=1:length(ij);
disp(sprintf(' %.2d-place: type-%s (%0.2f)',nr,type_str{ij(nr)},y_avg(ij(nr))));
end;%for nr=1:length(ij);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ;
% principal component analysis;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ;
%[U,S,V] = svds(y_,3);
%figure;cla;
%plot3(U(:,1),U(:,2),U(:,3),'r-'); title('PCA: rotate me!');
%axis vis3d;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ;

function A = pokematrix();
A = [... 
 2 2 2 2 2 2 2 2 2 2 2 2 1 0 2 2 1 2 2 ; ...
 2 1 1 2 4 4 2 2 2 2 2 4 1 2 1 2 4 2 2 ; ...
 2 4 1 2 1 2 2 2 4 2 2 2 4 2 1 2 2 2 2 ; ...
 2 2 4 1 1 2 2 2 0 4 2 2 2 2 1 2 2 2 2 ; ...
 2 1 4 2 1 2 2 1 4 1 2 1 4 2 1 2 1 2 2 ; ...
 2 1 1 2 4 1 2 2 4 4 2 2 2 2 4 2 1 2 2 ; ...
 4 2 2 2 2 4 2 1 2 1 1 1 4 0 2 4 4 1 2 ; ...
 2 2 2 2 4 2 2 1 1 2 2 2 1 1 2 2 0 4 2 ; ...
 2 4 2 4 1 2 2 4 2 0 2 1 4 2 2 2 4 2 2 ; ...
 2 2 2 1 4 2 4 2 2 2 2 4 1 2 2 2 1 2 2 ; ...
 2 2 2 2 2 2 4 4 2 2 1 2 2 2 2 0 1 2 2 ; ...
 2 1 2 2 4 2 1 2 2 1 4 2 2 1 2 4 1 1 2 ; ...
 2 4 2 2 2 4 1 2 1 4 2 4 2 2 2 2 1 2 2 ; ...
 0 2 2 2 2 2 2 2 2 2 4 2 2 4 2 1 2 2 2 ; ...
 2 2 2 2 2 2 2 2 2 2 2 2 2 2 4 2 1 0 2 ; ...
 2 2 2 2 2 2 1 2 2 2 4 2 2 4 2 1 2 1 2 ; ...
 2 1 1 1 2 4 2 2 2 2 2 2 4 2 2 2 1 4 2 ; ...
 2 1 2 2 2 2 4 1 2 2 2 2 2 2 4 4 1 2 2 ; ...
 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ; ...
     ] / 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ;

function f = pokefun(t,y,B,quit_chance);
%f = + y.*((B)*y) - y.*(transpose(B)*y) + quit_chance*(sum(y)/19-y);
f = + y.*((B-transpose(B))*y) + quit_chance*(sum(y)/19-y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ;
