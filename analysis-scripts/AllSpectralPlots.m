function AllSpectralPlots(basenameREAD, Runs, Rpt, ResF, lambda, plotname, DFact)
% Make one overall plot each (max. averaging)

mu0 = 1.256637e-006; %4*pi*1E-7; % vacuum permeability in V·s/(A·m) ? 1.2566370614...×10?6 V·s/(A·m) or H?m?1 or N·A?2 or T·m/A or Wb/(A·m)
% cLight = 299792458; % m / s;  physconst('LightSpeed');  sqrt(1/(2*mu0*cLight)) 
eps0 = 8.854188e-012; %v acuum permittivity (?0 = 8.854187817...×10?12 F/m)

% initlise matrices for storing integration results for all (bee vision) integration intervals
SpectrumAvSpec = zeros(ResF,Runs); % initialize matrix to save results
SpectrumAvScat = zeros(ResF,Runs); % initialize matrix to save results
SpectrumAvRest = zeros(ResF,Runs); % initialize matrix to save results
SpectrumAvAll = zeros(ResF,Runs); % initialize matrix to save results


%% Loop for all files of one run of simulations corresponding to "basename"
for n = 1:Rpt; % repetitions of random disorder runs with same parameters

for m = 1:Runs; % nr. of parameter sweep
    % load data out of matlab file
    [refl, theta, SPower] = LoadFileDisorder(basenameREAD, m, n);

    %% normalise to source for each wavelength
    thetaRAD = theta*pi/180; % convert angle to radian
    thetaRADSpacing = thetaRAD(2:length(thetaRAD))-thetaRAD(1:length(thetaRAD)-1); Middle = round(length(thetaRADSpacing)/2); % make uneven spacing vector
    thetaRADSpacing = [thetaRADSpacing(1:Middle);  thetaRADSpacing(Middle:length(thetaRADSpacing))]; % +1 to compensate for the lost element
    for k = 1:ResF; % for all wavelengths
        % calculate the poynting vector
        Svec = 0.5*sqrt(eps0/mu0)* (refl(:,k).*thetaRADSpacing); % last term is power integral -> integral over E0^2 angle|frequency region
        % apply source normalization 
        refl(:,k) = Svec / SPower(k); % make sure the wavelength interval matches(!) and apply normalisation factor
        clear Svec
    end

    
    %% create spectral matrix (angle integration)
    % data for angle subset (4degr to 90deg and negative) to spare out the zero order
    refl2 = refl(((theta>=-2)&(theta<=2)),:); % use values for included angles only

        refl3 = refl(((theta>=2)|(theta<=-2)),:); % use values for included angles only
        theta3 = theta((theta>=2)|(theta<=-2)); % make adjusted array
        refl4 = refl3(((theta3>=-10)&(theta3<=10)),:); % use values for included angles only

        refl5 = refl(((theta>=10)|(theta<=-10)),:); % use values for included angles only
        theta4 = theta((theta>=10)|(theta<=-10)); % make adjusted array
        refl6 = refl5(((theta4>=-40)&(theta4<=40)),:); % use values for included angles only
        
    % trapezoidal nonlinear numerical integration in radian
%     theta2RAD = theta2*pi/180; % convert angle to radian
    IntAngle2 = sum(refl2); % integral over angle subset
        IntAngle3 = sum(refl4); % integral over angle subset
            IntAngle4 = sum(refl6); % integral over angle subset

    % average: store each repeated run in spectral matrix
    SpectrumAvSpec(:,m)= SpectrumAvSpec(:,m) + (IntAngle2'/Rpt); % Average over runs
    SpectrumAvScat(:,m)= SpectrumAvScat(:,m) + (IntAngle3'/Rpt); % Average over runs
    SpectrumAvRest(:,m)= SpectrumAvRest(:,m) + (IntAngle4'/Rpt); % Average over runs
    SpectrumAvAll(:,m)= SpectrumAvAll(:,m) + ((sum(refl))'/Rpt); % Average over runs
    
    %% Clear variable memory
    clear IntAngle2 IntAngle3 IntAngle4
    clear refl2 theta3 refl3 theta3 refl4 refl5 refl5 theta4
end

end


for m = 1:Runs;
%% make spectral plot for flower parameters

SaveName = [plotname '_spectrum-' num2str(DFact(m)) '.jpg'];
xLabel = 'wavelength (nm)';
yLabel = 'light reflected into angular interval (%)';
Legend = {'Specular refl. {\pm}2^{\circ}', 'Scattering {\pm}10^{\circ}', 'Scattering {\pm}40^{\circ}', 'Total reflected'};
xAxis = lambda*1E9;
xLim = [250 750];
yLim = [0 4];

NiceDoublePlot(xAxis, SpectrumAvSpec(:,m), SpectrumAvScat(:,m), SpectrumAvRest(:,m), SpectrumAvAll(:,m), xLim, yLim, xLabel, yLabel, Legend, SaveName)
end


%% make spectral sweep plots

xLabel = 'wavelength (nm)';
xAxis = lambda*1E9;
xLim = [250 750];
Legend = num2str((DFact'), '%.2g%% disorder');
yLabel = 'light reflected into angular interval (%)';

%%% SPECULAR
% SweepData = SpectrumAvSpec;
SaveName = [plotname '_specular_sweep.jpg'];
% yLabel = 'specular reflection';
yLim = [0 3];
NiceSweepPlot(xAxis, yLim, xLim, SpectrumAvSpec, xLabel, yLabel, Legend, SaveName)

%%% SCATTERING
% SweepData = SpectrumAvScat;
SaveName = [plotname '_scattering_sweep.jpg'];
% yLabel = 'percent of light scattered between +-10degr';
yLim = [0 3];
NiceSweepPlot(xAxis, yLim, xLim, SpectrumAvScat, xLabel, yLabel, Legend, SaveName)

%%% NEXT20
% SweepData = SpectrumAvScat;
SaveName = [plotname '_next20_sweep.jpg'];
% yLabel = 'percent of light scattered between +-25degr';
yLim = [0 3];
NiceSweepPlot(xAxis, yLim, xLim, SpectrumAvRest, xLabel, yLabel, Legend, SaveName)

% % %%% ALL
% % % SweepData = SpectrumAvAll;
% % SaveName = [plotname '_all_sweep.jpg'];
% % yLabel = '% total light scattered compared to source';
% % yLim = [0 4];
% % NiceSweepPlot(xAxis, yLim, xLim, SpectrumAvAll, xLabel, yLabel, Legend, SaveName)


