function [lambda, fsource, periods, fillfact, heights, Index, Nperiods, I, sigmaW, sigmaX, sigmaH, seed, DFact, Rpt] = LoadSettingsDisorder(name)
% Load Reflection_Intensity, theta, lambda
% rename "Reflection_Intensity" into "refl"

S = load(name); % load data
lambda = S.lambda;
fsource = S.fsource;
periods = S.periods;
fillfact = S.fillfact;
heights = S.heights;
Index = S.Index;
Nperiods = S.Nperiods;
I = S.I;
sigmaW = S.sigmaW;
sigmaX = S.sigmaX;
sigmaH = S.sigmaH;
seed = S.seed;
DFact = S.DFact;
Rpt = S.Rpt;

clear name S