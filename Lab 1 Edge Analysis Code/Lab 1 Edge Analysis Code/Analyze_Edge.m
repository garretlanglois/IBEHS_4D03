%Arvand Barghi, August 2011 : Modified 2012, Spencer Gardner, Modus Medical
%Devices Inc.

%This script will implement the edge-response function's curve fitting
%algorithm given a csv file, plot the fitted curve, and calcualte the
%resulting point spread function and modulation transfer function

clc
%clear all


[filename pathname] = uigetfile('*.csv','Please select a csv file');

ydata = csvread([pathname filename],2,1)';
%this reads in the csv file, the first index is 2,1 because we want to
%skip the first row as this contains the header

str={'2D Projection Profile','3D Image Profile'}; % Type of profile options
[Selection,ok] = listdlg('PromptString','Select the profile type:','SelectionMode','single','ListString',str); % Asks user and gets input of profile type

if Selection==1
    %input calibration parameter from DeskCAT to calculate resolution of Full Image profile - resolution is calculated at
    %detector.  Assume resolution at detector is valid for entire depth of
    %field for purposes of this experiment.
    prompt = {'Enter Horizontal Light Size:'}; 
    dlg_title = 'Input for 2D Image Pixel Size Calculation';
    num_lines = 1;
    def = {'15'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    horizlightsize = str2num(answer{1});
    imagevoxelsize = horizlightsize*10/640; %determine voxel size in mm
    
else
    
    if Selection==2
    str={'0.25mm','0.5mm','1mm','2mm'}; % Voxel size options
    [Selection,ok] = listdlg('PromptString','Select the voxel size:','SelectionMode','single','ListString',str); % Asks user and gets input of voxel size.
    imagevoxelsize = 2^Selection/8; %Produces an integer for voxel size

    end
end

voxelsize = imagevoxelsize/10;   %sampling frequency of line profile is 10 times that of the image

ydata=ydata/max(ydata); %Normalize ydata
if ydata(1)> ydata(end)          
    ydata=ydata(end:-1:1); %Reverses the data array so that erf is increasing
end


newend=(find(ydata>0.6,1,'first')+length(ydata))/2; %Arbitrary truncation points; But they work best by trial and error.
newstart=(find(ydata<0.3,1,'last'))/2; % changed from 4 to 2 for better centering assuming profile even spaced across step
ydata=ydata(newstart:newend); %Truncates ydata

xdata = (-length(ydata)/2 + 1:length(ydata)/2)*voxelsize;  %creates the x-axis and centers around 0. 

xdatavarname=genvarname([filename(1:(length(filename)-4)),'xdata']); %Generates a variable name based on csv filename
eval ([xdatavarname '=xdata']); %Creates a unique variable for the xdata



%erf_smooth = transpose(smooth(ydata,7)); %smooth step curve prior to fit
%and transpose matrix-requires curve fit toolbox


erf_smooth = runmean(ydata,7); %smooth step curve prior to fit and transpose matrix 



a_guess = [0,0,0,0];    %seed, needed as a starting point for the iterative curve fit below 

%a_best = nonlinfit(xdata,ydata,a_guess);    %non-linear curve fit

a_best = nonlinfit(xdata,erf_smooth,a_guess);    %non-linear curve fit with smoothed erf curve

erf = varerf(a_best,xdata);    %generate curve using optimized parameters
erfvarname=genvarname([filename(1:(length(filename)-4)),'erf']); %Generates a variable name based on csv filename
eval ([erfvarname '=erf']) %Creates a unique variable for the psf

figure; %plot erf(x)
plot(xdata,ydata,xdata,erf);  %plot data and fitted curve
title('Line profile across step-phantom')
xlabel('displacement from centre of line profile (mm)')
ylabel('normalized attenuation coefficient') %changed label - since data normalized
legend('data','curve fit of erf(x)')
hold off

a_best(3) = 0;  %after curve-fitting, centre the erf

erf = varerf(a_best,xdata);    %recalculate curve at centre

psf = diff(erf);   %differentiate erf(x) to get psf(x)
psf = psf/max(psf); % Normalize psf


psfvarname=genvarname([filename(1:(length(filename)-4)),'psf']); %Generates a variable name based on csv filename
eval ([psfvarname '=psf']) %Creates a unique variable for the psf


figure;      %plot psf(x)
plot(xdata(1:length(xdata)-1),psf);     %must shorten x-axis by 1 since differentiating a vector shortens its length by 1
title('Point Spread function of DeskCAT scanner estimated by differentiating edge response')
xlabel('x (mm)')
ylabel('PSF(x)')

nFFT = 4096;    %set the size of the FFT output vector

mtf = abs(fftshift(fft(psf,nFFT)));   %calculate mtf(f)

mtf = mtf/max(mtf);     %normalize mtf

mtfvarname=genvarname([filename(1:(length(filename)-4)),'mtf']); %Generates a variable name based on csv filename
eval ([mtfvarname '=mtf']) %Creates a unique variable for the mtf

freqaxis = linspace(-2/voxelsize,2/voxelsize,nFFT); %calculate frequency axis using Nyquist Theorem

freqaxisvarname=genvarname([filename(1:(length(filename)-4)),'freqaxis']); %Generates a variable name based on csv filename
eval ([freqaxisvarname '=freqaxis']) %Creates a unique variable for the freq axis of the mtf


figure;          %plot mtf(f)
plot(freqaxis,mtf);
title('Modulation transfer function of DeskCAT estimated using edge response method')
xlabel('Spatial Frequency (mm^-^1)');
ylabel('MTF');
axis([0 max(freqaxis)/10 0 1.2])
clear mtf
clear psf
clear erf