function NiceSweepPlot(xAxis, yLim, xLim, SweepData, xLabel, yLabel, Legend, SaveName)
% make a publishable plot and save

%plot axis
Title = ''; %[plotname ' integral over scattering angles'];

%plot integral over angel subset
FontSize = 12;
FontName = 'MyriadPro-Regular'; % or choose any other font
figure_width = 20;  
figure_height = 10;
figuresVisible = 'on'; % 'off' for non displayed plots (will still be exported)

hfig = figure(1); clf;

% Set colors for plot lines
set(0,'DefaultAxesColorOrder',jet(size(Legend,1)));%parula,winter,jet,hot

    set(hfig,'Visible', figuresVisible)

    set(hfig, 'units', 'centimeters', 'pos', [5 5 figure_width figure_height])   
    set(hfig, 'PaperPositionMode', 'auto');    
    set(hfig, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background

% --- dimensions and position of plot 
hsp = subplot(1,1,1, 'Parent', hfig);

hold all

for o = 1:length(SweepData(1,:));
    plot(xAxis,SweepData(:,o)*100,'Linewidth',2);
end

%settings:
% title(Title1,'FontSize',FontSize);
legend(Legend,'Location','SouthEastOutside')
hTitle = title(Title);
hXLabel = xlabel(xLabel);
hYLabel = ylabel(yLabel);
xlim(xLim)
ylim(yLim)

set(gca, ...
    'Box'         , 'on'      , ...
    'TickDir'     , 'in'      , ...
    'TickLength'  , [.015 .015] , ...
    'XMinorTick'  , 'off'      , ...
    'YMinorTick'  , 'off'     , ...
    'XGrid'       , 'off'     , ...
    'YGrid'       , 'off'     , ...
    'LineWidth'   , 0.6        );

% set properties for all handles
set([gca, hTitle, hXLabel, hYLabel], ...
    'FontSize'   , FontSize    , ...
    'FontName'   , FontName);

hold off
%     saveas(gcf1,SaveName,'jpg'); 
    print(hfig, ['-r' num2str(400)], [SaveName '.jpg' ], ['-d' 'jpeg']);
    print(hfig, [SaveName '.svg' ], ['-d' 'svg']); 
display('finished plot export')