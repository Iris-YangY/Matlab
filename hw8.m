%The error E2(1,0)^2 is 79
%The parameters a,b which minimize the error E2(a,b)^2 are -0.0389 and
%2.7899
%The error associated with this optimal line is 21.2685
N = 6;
DATA_x = [2,1,2,3,9,2];
DATA_y = [0,5,2,1,3,5];

hold on;
plot(DATA_x,DATA_y,'ko');

error = @ (a,b) sum((a.*DATA_x+b-DATA_y).^2);
error_10 = error(1,0);
disp(error_10); 
oppara = polyfit(DATA_x,DATA_y,1);
a = oppara(1);
b = oppara(2);
plot(DATA_x, a*DATA_x +b);
error_optimal = error(a,b);
disp(a);
disp(b);
disp(error_optimal);
hold off;