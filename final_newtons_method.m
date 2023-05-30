function simple_newton_1();

maximum_iteration=20;

x=zeros(1,maximum_iteration+1);

x(1)=1; %<-- initial guess. ;
%%%%%%%%;
% perform the actual iteration. ;
%%%%%%%%;
for iteration_index=1:maximum_iteration;
x(iteration_index+1)=x(iteration_index)-Dg(x(iteration_index))\g(x(iteration_index)); %<-- solving the equation associated with newtons method for the next step. ;
% This process uses matlab function 'mldivide' which is specifically designed for inverting linear systems of equations. ;
% Notice that I wrote "Dg\g" as opposed to "g/Dg". Either choice of code will work here, since we are working with only one variable. ;
% However, if "Dg" were a matrix, only the first expression ("Dg\g") makes sense. ;
end;%for iteration_index=1:maximum_iteration;

x,;
%{
for iter=1:maximum_iteration;
    disp(iter);
    disp(abs(x(iter)-exactvalue));
end;
%}
%%%%%%%%;
% visualization. ;
%%%%%%%%;

t=-pi:pi/128:pi;

figure;hold on;
plot(t,g(t),'b');
plot(t,t*0,'r');
for iteration_index=1:maximum_iteration;
title(sprintf('press space to see iteration %d/%d',iteration_index,maximum_iteration));
plot([x(iteration_index) x(iteration_index)],[0 g(x(iteration_index))],'g'); %<-- plot a vertical line ;
plot([x(iteration_index) x(iteration_index+1)],[g(x(iteration_index)) 0],'g'); %<-- plot a tangent-line ;
pause();
end;%for iteration_index=1:maximum_iteration;
hold off;

function output=g(input);
output = 1+2*sin(2*pi.*log(input)/log(2))*log(2)/(2*pi);

function output=Dg(input);
output = 2*cos(2*pi.*log(input)/log(2))*(1/input);