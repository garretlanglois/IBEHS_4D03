[filename pathname] = uigetfile('*.csv','Please select a csv file');

ydata = csvread([pathname filename],2,1)';

ydata=ydata/max(ydata);

deriv= diff(ydata);

center= find(deriv==max(deriv));

deriv=deriv(center-300:center+300);

figure      %plot psf(x)
plot(deriv);     %must shorten x-axis by 1 since differentiating a vector shortens its length by 1
title('line spread function of DeskCAT scanner estimated by differentiating edge response')
xlabel('x (mm)')
ylabel('psf(x)')