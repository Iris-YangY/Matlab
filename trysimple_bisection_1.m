% This code is designed to test the accracy of bisection method: after 22 iterations, it
% reaches to 2 digits accuracy; after 35 iterations, it reaches to 6 digits
% accuracy; after 55 iterations, it reaches to 12 digits accuracy.
% Bisection method converges at linear rate, very slow, but guarantee finding a
% root between interval [a,b] if f(a)f(b)<0.

function simple_bisection_1(); %<-- an 'explicit' function that we can call from the matlab command prompt. ;
% Matlab does not allow functions to be defined within scripts (i.e., m-files). ;
% Below we try and find a root of f(x), so x refers to the horizontal position, and y to the vertical. ;
exactvalue = 81^(1/10);
error = 0;
n_iteration = 70; %<-- maximum iteration number. Ideally this would be determined adaptively. ;
a = 0; %<-- initial left-endpoint. ;
c = 81; %<-- initial right-endpoint. ;

% Now we step through several iterations of bisection. ;
for niteration = 0:n_iteration-1;
b = (a+c)/2; %<-- define the midpoint of the current interval. ;
fa = function_f(a); %<-- we evaluate the function at the left. ;
fb = function_f(b); %<-- we evaluate the function at the middle. ;
fc = function_f(c); %<-- we evaluate the function at the right. ;
disp(niteration+1);
disp(abs(fc));
if (fa*fb<0); c=b; 
elseif (fa*fc<0); a=b; 
end;
end;
function output_y = function_f(input_x); %<-- another 'explicit' function that we are declaring here, and will call above. ;
% we could simply have defined this using the inline syntax: ;
% e.g., function_f = @(x) 3 - x.^2 + x ;
 output_y = input_x.^10-81;