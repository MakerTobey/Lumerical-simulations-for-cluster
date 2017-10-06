%% Main script to run analysis.
%%% Define input data and initialize arrays

%%%%%%% INPUTS %%%%%%%%%%
% filenames
FileNameSettings = 'matfile_Settings_Supercell_Sweep_PWH_Hibiscus'; % e.g. 'matfile_Settings_for_Grating_Farfield_Sweep'
basenameREAD = 'matfile_all_disorder'; % Base of matlab file name e.g. 'matfile_height_490nm'
% Add a path to searchpath to find matlab files:
path(path,'C:\Users\tw347\OwnCloud_backup\data9,0\twenzel\files\workfiles\Strication Paper\material\Striation paper material fig3\Simulations\Clusterversion\matlabfiles');
plotname = 'hibiscus_all_disorder'; % Made up name to appear on plots e.g. 'Period_displacement'
%%%%%%%%%%%%%%%%%%%%%%%%%

    % load setings and initialise
    [lambda, fsource, periods, fillfact, heights, Index, Nperiods, I, sigmaW, sigmaX, sigmaH, seed, DFact, ~] = LoadSettingsDisorder(FileNameSettings);
    Rpt = 60; % include new runs
    % define from loaded
    Runs = length(DFact); % how many simulations in this sweep
    ResF = length(fsource); % frequenzy resolution % standard 200
 %%%%%
lambda = flip(lambda); 
%%%%%%%%%


%% Make "Goniometer" plot for each sweep-step
lambdaG = lambda(1):((lambda(length(lambda))-lambda(1))/(length(lambda)-1)):lambda(length(lambda)); %format lambda suitably for this plot type
GoniometerPlots(basenameREAD, Runs, Rpt, ResF, lambdaG, plotname, DFact);


%% Make "Spectral" plot for specular reflection and for scattering (for each sweep-step)
AllSpectralPlots(basenameREAD, Runs, Rpt, ResF, lambda, plotname, DFact);
