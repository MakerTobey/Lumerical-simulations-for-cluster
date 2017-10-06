function [refl, theta, SPower] = LoadFileDisorder(basename, m, nRpt)
% Load Lumerical dataset
% rename "Reflection_Intensity" into "refl"

name = [basename '-run' num2str(nRpt) '--' num2str(m)]; % gernerate full filename

S = load(name); % load data
refl = S.Reflection_Intensity;
theta = S.theta;
SPower = S.SPower;

clear name S