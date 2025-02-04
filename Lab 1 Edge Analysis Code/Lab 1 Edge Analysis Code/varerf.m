function y = varerf(a,x);
%Arvand Barghi, August 2011
%parameterized edge response function, using as a base the gaussian
%integral and having 4 parameters: a(1) controls vertical stretch, a(2)
%controls horizontal stretch, a(3) controls horizontal translation, a(4)
%controls vertical translation
y = a(1)*erf(x*a(2) - a(3)) + a(4);
end