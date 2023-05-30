function h_ = pokemon_markov_ver3(rseed,n_player,n_t,quit_chance);

if (nargin<1); rseed=0; end; %<-- check number of input arguments. ;
if (nargin<2); n_player=1024; end; %<-- setting defaults. ;
if (nargin<3); n_t=1024; end; %<-- setting defaults. ;
if (nargin<4); quit_chance=0.001; end; %<-- setting defaults. ;

%%%%%%%%;
% list the names so that we can build a legend later. ;
%%%%%%%%;
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

%%%%%%%%;
% Need to change the random seed to get independent trials. ;
%%%%%%%%;
rng(rseed); %<-- fixes the random seed so that you get the same result. ;
t_ = 1:n_t; %<-- n_t is the number of rounds. ;
p_type_init = 1+mod(transpose(1:n_player),n_type); %<-- deterministic initialization with uniformly distributed species count. ;
%p_type_init = ceil(n_type*rand(n_player,1)); %<-- random initialization. ;
p_type_ = zeros(n_player,n_t); p_type_(:,1) = p_type_init; %<-- p_type_ is an array of size n_type-by-n_t, storing each player species for each time-step (i.e., each column is the species-list for that time-step). ;
%quit_chance = input(sprintf(' %% enter quit_chance (default 0): ')); %<-- ask user for input. ;
if (isempty(quit_chance)); quit_chance = 0.000; disp(sprintf(' %% using default quit_chance %f',quit_chance)); end;

A = pokematrix(); B = A./(A+transpose(A)); B(14,1)=0.5; B(1,14)=0.5; %normal-vs-ghost;

for nt=2:n_t;
if (nargout<1); if (mod(nt,100)==0); disp(sprintf(' %% nt %d/%d',nt,n_t)); end; end; 
p_type = p_type_(:,nt-1);
z_ = zeros(n_player,1);
%%%%%%%%;
% set up the duels for the current round. ;
%%%%%%%%;
prm = random_pairing(n_player); %<-- randomly pair players up against one another. ;
for np=1:n_player;
pp = prm(np); zn = z_(np); zp = z_(pp);
if (~zn & ~zp);
p_type_1 = p_type(np); p_type_2 = p_type(pp);
%%%%%%%%;
% Recall that the B matrix stores the probability that one species would win vs another. ;
% We also update the species of each loser. ;
%%%%%%%%;
if (rand()>B(p_type_1,p_type_2)); p_type(np) = p_type_2; else; p_type(pp) = p_type_1; end;
z_(np) = 1; z_(pp) = 1;
end;%if (~zn & ~zp);
end;%for np=1:n_player;
%%%%%%%%;
% Now update the species of each quitter. ;
%%%%%%%%;
new_ = find(rand(n_player,1)<quit_chance);
if (length(new_)>0); p_type(new_) = 1+floor(n_type*rand(length(new_),1)); end;
p_type_(:,nt) = p_type;
end;%for nt=2:n_t;

%%%%%%%%;
% collect statistics. ;
% Recall that p_type_ is an array of size n_player by n_t. ;
% So, each column corresponds to a list of species (one per player) ;
% at the round corresponding to that column. ;
% We use the 'hist' function to count the number of players of each species. ;
% Generally, hist(vector,bins) will return the number of elements in 'vector' in each bin. ;
% In this case, since we are passing in an array, instead of a vector, the output ;
% is a histogram for each column (default of matlab). ;
% For a 'final' calculation, we probably want h_(:,end), ;
% i.e., the histogram at the final round. ;
%%%%%%%%;
h_ = hist(p_type_,1:n_type); y_ = transpose(h_);
%%%%%%%%;
% generate a plot if no output is requested. ;
%%%%%%%%;
if nargout<1;
figure;cla;set(gcf,'Position',1+[0,0,2*1024,2*512]);
plot(t_,y_/n_player,'LineWidth',2); xlim([0,max(t_)]);
legend(type_str);
y_avg = mean(y_,1);
[tmp,ij] = max(y_avg/n_player); title(sprintf('type %s wins!',type_str{ij}));
[tmp,ij] = sort(y_avg,'descend');
for nr=1:length(ij);
disp(sprintf(' %.2d-place: type-%s (%0.2f)',nr,type_str{ij(nr)},y_avg(ij(nr))/n_player));
end;%for nr=1:length(ij);
end;%if nargout<1;
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

