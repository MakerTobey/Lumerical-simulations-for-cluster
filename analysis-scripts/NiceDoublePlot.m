function NiceDoublePlot(xAxis, Data1D1, Data1D2, Data1D3, Data1D4, xLim, yLim, xLabel, yLabel, Legend, SaveName)
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
    set(hfig,'Visible', figuresVisible)

    set(hfig, 'units', 'centimeters', 'pos', [5 5 figure_width figure_height])   
    set(hfig, 'PaperPositionMode', 'auto');    
%     set(hfig, 'Renderer','Zbuffer'); 
    set(hfig, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background

% --- dimensions and position of plot 
hsp = subplot(1,1,1, 'Parent', hfig);

gcf1 = plot(xAxis,Data1D2*100,'Linewidth',2); hold on %,'m' 'm--'
plot(xAxis,Data1D3*100,'Linewidth',2);%'b',
plot(xAxis,Data1D1*100,'Linewidth',2); %,'g''g:'
plot(xAxis,Data1D4*100,'Linewidth',2);%,'k-.'

%settings:
% title(Title1,'FontSize',FontSize);
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

hleg = legend(char(Legend(2)),char(Legend(3)),char(Legend(1)),char(Legend(4)),'Location','SouthEastOutside');%,'NorthEast');
set(hleg, 'FontSize', FontSize, 'FontName', FontName)%,  'Box', 'off', %%%'FitBoxToText', 'on');


hold off
%     saveas(gcf1,SaveName,'jpg'); 
    print(hfig, ['-r' num2str(400)], [SaveName '.jpg' ], ['-d' 'jpeg']);
    print(hfig, [SaveName '.svg' ], ['-d' 'svg']); 
display('finished plot export')