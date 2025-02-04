function a_best = nonlinfit(xdata,ydata,a_guess);
%Arvand Barghi, August 2011
%calculates, using fminsearch function, the value of a that results in the
%best curve fit, that minimizes the chi squared value. User must input
%a_guess, which is the seed for the algorithm, and a 4-unit vector of zeros or ones will work.
a_best = fminsearch(@(a) mychisq(a,xdata,ydata), a_guess);
end