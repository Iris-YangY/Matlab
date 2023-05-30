% This code is designed to test the accracy of Newton's method: after 9 iterations, it
% reaches to 2 digits accuracy; after 10 iterations, it reaches to 6 digits
% accuracy; after 11 iterations, it reaches to 12 digits accuracy.
% Newton's method converges to root at quadratic rate, and is the fastest
% method for root-finding.
function simple_newton_1();

maximum_iteration=20;

x=zeros(1,maximum_iteration+1);

x(1)=3; %<-- initial guess. ;
exactvalue = 81^(1/10);
error = 0;
%%%%%%%%;
% perform the actual iteration. ;
%%%%%%%%;
for iteration_index=1:maximum_iteration;
x(iteration_index+1)=x(iteration_index)-Dg(x(iteration_index))\g(x(iteration_index)); %<-- solving the equation associated with newtons method for the next step. ;
% This process uses matlab function 'mldivide' which is specifically designed for inverting linear systems of equations. ;
% Notice that I wrote "Dg\g" as opposed to "g/Dg". Either choice of code will work here, since we are working with only one variable. ;
% However, if "Dg" were a matrix, only the first expression ("Dg\g") makes sense. ;
end;%for iteration_index=1:maximum_iteration;
format("long")
disp(exactvalue);
x,;
for iter=1:maximum_iteration;
    disp(iter);
    disp(abs(x(iter)-exactvalue));
end;

function output=g(input);
output = input.^10-81;

function output=Dg(input);
output = 10*input.^9;