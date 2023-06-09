function quiz_independence_0();
string_netid = input('enter your netid: ','s');
code_netid = string_netid_to_code_netid(string_netid);
disp(sprintf(' %% you entered %s --> your quiz code is %d',string_netid,code_netid));
rng(code_netid);
n_die = 2 + floor(2*rand);
n_side = (5 - n_die) + floor(3*rand);
threshold_dn = floor(n_die*(n_side+1)/2);
threshold_up = ceil((n_die+1)*(n_side+1)/2);
disp(sprintf(' %% Assume that you roll %d different die, each with %d sides (ranging in value from 1 to %d).',n_die,n_side,n_side));
disp(sprintf(' %% Now assume that you record the sum S of the numbers on each die.'));
disp(sprintf(' %% What is the probability that A: %d <= S ?',threshold_dn));
disp(sprintf(' %% What is the probability that B: S <= %d ?',threshold_up));
disp(sprintf(' %% What is the probability that both A and B occur? That is, that C: %d <= S <= %d ?',threshold_dn,threshold_up));
disp(sprintf(' %% Are these two events independent?'));

function code_netid = string_netid_to_code_netid(string_netid);
code_netid_ = cast(string_netid,'int32');
n_l = numel(code_netid_);
code_netid=0;
for nl=0:n_l-1;
code_netid = code_netid*code_netid_(1+nl) + code_netid_(1+nl);
code_netid = mod(code_netid,1024);
end;%for nl=0:n_l-1;
