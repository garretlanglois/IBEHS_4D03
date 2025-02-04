function err = mychisq(a,xdata,ydata);
%Arvand Barghi, August 2011
%calculates the chi squared value between fitted curve and data
yfit = varerf(a,xdata);
err = sum((yfit-ydata).^2);
end