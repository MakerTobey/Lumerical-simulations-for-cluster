function [ReflAv] = GoniometerPlots(basenameREAD, Runs, Rpt, ResF, lambda, plotname, DFact)
% Make "Goniometer" plots, averaged over randomnes repititons
% initialise, load, normalise, average, plot

mu0 = 1.256637e-006; %4*pi*1E-7; % vacuum permeability in V·s/(A·m) ? 1.2566370614...×10?6 V·s/(A·m) or H?m?1 or N·A?2 or T·m/A or Wb/(A·m)
% cLight = 299792458; % m / s;  physconst('LightSpeed');  sqrt(1/(2*mu0*cLight)) 
eps0 = 8.854188e-012; %v acuum permittivity (?0 = 8.854187817...×10?12 F/m)
        [~, theta, ~] = LoadFileDisorder(basenameREAD, 1, 1);

%% Loop for all files of one run of simulations corresponding to "basename"
for m = 1:Runs; % nr. of parameter sweep

ReflAv = zeros(length(theta),ResF); % initialize matrix to save results
    
for n = 1:Rpt; % repetitions of random disorder runs with same parameters
    
    % load data out of matlab file
    [refl, theta, SPower] = LoadFileDisorder(basenameREAD, m, n);
    refl = flipud(refl);

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

    %% average: store each repeated run in farfield matrix
    ReflAv = ReflAv + (refl/(Rpt)); % Average over repititions
    

end


%% Smooth data with a span of 4% of the data points
AA = mslowess(theta,ReflAv,'Order', 2, 'Span', 0.04, 'Kernel', 'gaussian');
% AA = ReflAv;

%% Reduce specular reflection intensity 3-fold
thetaSpecular = ((theta<=2.5)&(theta>=-2.5));
AA(thetaSpecular,:) = AA(thetaSpecular,:)/3;

%% Reduce size of matrix to exclude sparsely sampled areas
% Not used now but useful when not ploting the cos(theta) values further down
thetaRegion = ((theta<=75)&(theta>=-35));%((theta<=91)&(theta>=-91));
lambdaRegion =  ((lambda<=720*1E-9)&(lambda>=280*1E-9));

AA(not(thetaRegion),:) = [];
thetaC = theta;
thetaC(not(thetaRegion)) = [];

AA(:,not(lambdaRegion)) = [];
lambdaC = lambda;
lambdaC(not(lambdaRegion)) = [];

%% make "gonimeter" plots
xAxis = cosd(thetaC+270); % thetaC; %Decide on scaling of angular axsis: theta or cosd(thetaC+270) 
yAxis = lambdaC*1E9;
%Data2D = AA' (see function below)
cLims = [0 0.8E-4]; % set colour scale limits
yLabel = 'wavelength in nm';
xLabel = 'scattering angle in degr'; %'cos of scattering angle';
zLabel = 'intensity';
xTick = cosd((-90:10:90)+270); % -60:30:60;
xTickLabel = {'' '' -70 '' '' -40 '' -20 -10 0 10 20 '' 40 '' 60 '' '' ''}; % or leave emty: []
yTick = 300:100:700;
yTickLabel = [];%num2str(300:100:700);
Title = ''; % this is supposed to stay empty
SaveName = [plotname '_farfield-' num2str(DFact(m))];

NicePPlot(xAxis, yAxis, AA', cLims, xLabel, yLabel, zLabel, xTick, yTick, xTickLabel, yTickLabel, Title, SaveName)


end
