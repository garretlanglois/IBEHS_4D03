%Spencer Gardner, March 2012
%Edited by Modus Medical May 2012
%This script is an easy tool for plotting multiple 
%fitted edge response functions, point spread functions, or modulation
%transfer functions. Plot layout and settings can be edited by going to
% Edit->Figure Properties in the figure window.

str={'erf','psf','mtf'}; % Plot Options
labels={};
[Selection,ok] = listdlg('PromptString','Select plot type:','SelectionMode','single','ListString',str); % Asks user to select which function to plot
figure %  create new figure for plots
hold all

if Selection ==1
    spaces=who('-regexp', '\w*erf$', 'match');%%%%%%%%%%%%%%%%%%%
    [Workspace,ok] = listdlg('PromptString','Select a file to plot:','SelectionMode','multiple','ListString',spaces); % Asks user to select what they wish to plot
    for i = 1:length(Workspace)
        labels{end+1}=spaces{Workspace(i)}(1:end-3);
        xdata= eval([spaces{Workspace(i)}(1:end-3),'xdata']); %Determines variable name for related ydata.
        plot(xdata,eval(spaces{Workspace(i)}))%plot data and fitted curve
        title('line profile across edge response function')
        xlabel('displacement from centre of line profile (mm)')
        ylabel('Normalized linear attenuation coefficient') % changed label - data is normalized
        legend (labels) 
    end
    

elseif Selection ==2
    spaces=who('-regexp', '\w*psf$', 'match');%%%%%%%%%%%%%%%%%%%
    [Workspace,ok] = listdlg('PromptString','Select a file to plot:','SelectionMode','multiple','ListString',spaces); % Asks user to select what they wish to plot
    for i = 1:length(Workspace)
        labels{end+1}=spaces{Workspace(i)}(1:end-3);
        xdata= eval([spaces{Workspace(i)}(1:end-3),'xdata']); %Determines variable name for related xdata.
        plot(xdata(1:length(xdata)-1),eval(spaces{Workspace(i)}));     %must shorten x-axis by 1 since differentiating a vector shortens its length by 1
        title('line spread function of DeskCAT scanner estimated by differentiating edge response')
        xlabel('x (mm)')
        ylabel('psf(x)')
        legend (labels)
    end
elseif Selection ==3
    spaces=who('-regexp', '\w*mtf$', 'match');%%%%%%%%%%%%%%%
    [Workspace,ok] = listdlg('PromptString','Select a file to plot:','SelectionMode','multiple','ListString',spaces); % Asks user to select what they wish to plot
    for i = 1:length(Workspace)
        labels{end+1}=spaces{Workspace(i)}(1:end-3);
        freqaxis = eval([spaces{Workspace(i)}(1:end-3),'freqaxis']); %Determines variable name for related freqaxis.
        plot(freqaxis,eval(spaces{Workspace(i)}))
        title('Modulation transfer function of DeskCAT estimated using edge response method')
        xlabel('spatial frequency (mm^-^1)');
        ylabel('Modulation');
        axis([0 max(freqaxis)/10 0 1.2]);
        legend (labels)
    end
else
%    break
end
if Workspace == 0
 %break;
end 
hold off