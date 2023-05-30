clear; %<-- clears matlab memory. ;

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

n_player = 1024; %<-- number of players in each trial. ;
n_t = 1024; %<-- set number of rounds for each trial. ;

n_trial = 1024; %<-- set number of trials (i.e., tournaments / simulations). ;
h_end__ = zeros(n_type,n_trial);
for ntrial=0:n_trial-1;
if (mod(ntrial,32)==0); disp(sprintf(' %% ntrial %d/%d',ntrial,n_trial)); end;
rseed = ntrial; %<-- make sure to set the random seed to be different for each trial. ;
tmp_h_ = pokemon_markov_ver3(rseed,n_player,n_t); %<-- the species histogram/distribution at the last round of the trial. ;
h_end__(:,1+ntrial) = tmp_h_(:,end); %<-- record type count in the last round of the trial. ;
end;%for ntrial=0:n_trial-1;

figure(1);clf;set(gcf,'Position',1+[0,0,1024*2,512*2]);
colormap(1-colormap('gray'));
subplot(1,5,[1:4]); imagesc(h_end__); set(gca,'ydir','normal');
set(gca,'YTick',1:n_type','YTickLabel',type_str);
xlabel('trial number');
subplot(1,5,5); barh(mean(h_end__,2)); ylim([1-0.5,n_type+0.5]);
set(gca,'YTick',1:n_type,'YTickLabel',type_str);
sgtitle(sprintf('n_player %d n_t %d',n_player,n_t),'Interpreter','none');
xlabel('total count');
