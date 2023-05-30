function PolyRegress_3();

rng(0);

DATA_x = [2 1 2 3 9 2];
DATA_y = [0 5 2 1 3 5];
N = length(DATA_x);

initial_n=12;
theta=(initial_n/12)*pi;

new_DATA_x=cos(-theta)*DATA_x-sin(-theta)*DATA_y;
new_DATA_y=sin(-theta)*DATA_x+cos(-theta)*DATA_y;

d=2;
p=2;

subplot(1,2,1);
hold on;
plot(DATA_x,DATA_y,'b.','MarkerSize',20,'MarkerFaceColor','b');


q_initial=randn(d,1);
[q,ne,fe] = root_of_dEp(q_initial,new_DATA_x,new_DATA_y,p);
q_t=[q(1,1)/(cos(-theta)+q(2,1)*sin(-theta));(-sin(-theta)+cos(-theta)*q(2,1))/(cos(-theta)+sin(-theta)*q(2,1))];
DATA_i = linspace(min(DATA_x),max(DATA_x),4*N);
plot(DATA_i,polyval(q_t(end:-1:1),DATA_i),'r-','LineWidth',2);
text(-1,4,sprintf('theta = %dpi error = %0.2f',initial_n,fe));
disp(q_t);
disp(fe);

hold off;
xlabel('x');ylabel('y');
axis([-1,+10,-1,+6]);


function [qroot,newtonerror,finalerror] = root_of_dEp(q_initial,x,y,p);
max_iteration = 15; iteration=0;
q = q_initial;
while (iteration<max_iteration);
dq = inv(ddEp(q,x,y,p))*dEp(q,x,y,p);
q = q - dq;
iteration = iteration+1;
end; 
qroot = q; newtonerror = norm(dEp(qroot,x,y,p)); finalerror = Ep(qroot,x,y,p);

function output = Ep(q,x,y,p);
r = polyval(q(end:-1:1),x)-y;
output = sum(abs(r).^p);

function output = dEp(q,x,y,p);
r = polyval(q(end:-1:1),x)-y;
output = zeros(length(q),1);
for j=0:length(q)-1;
output(1+j) = sum(p*(abs(r).^(p-1)).*(x.^j).*sign(r));
end;

function output = ddEp(q,x,y,p);
r = polyval(q(end:-1:1),x)-y;
output = zeros(length(q),length(q));
for j=0:length(q)-1;
for k=0:length(q)-1;
output(1+j,1+k) = sum(p*(p-1)*(abs(r).^(p-2)).*(x.^(j+k)));
end;
end;
