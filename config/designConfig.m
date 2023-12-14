function expDes = designConfig(const)
% ----------------------------------------------------------------------
% expDes = designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define experimental design
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg experimental design
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------


% Experimental random variables
% Var 1: task
if const.mkVideo
    expDes.oneV = input(sprintf('\n\tTASK: '));
    expDes.nb_var1 = 1;
else
    expDes.oneV = (1:length(const.task_lst))';
    expDes.nb_var1 = length(const.task_lst);    
end

if const.mkVideo
    expDes.oneR = input(sprintf('\n\tRAND 1: '));
    expDes.nb_rand1 = 1;
else
    expDes.oneR = (1:length(const.orientation_lst))';
    expDes.nb_rand1 = length(const.orientation_lst);
end


% Experimental configuration :
expDes.nb_var = 1;
expDes.nb_rand = 1;

% Experimental loop
trialMat = zeros(const.nb_trials, expDes.nb_var);
ii = 0;
for rep = 1:const.nb_repeat
    for var1 = 1:expDes.nb_var1
           ii = ii + 1;
            trialMat(ii, 1) = var1;
            
       
    end
end

trialMat = trialMat(randperm(const.nb_trials)', :);
for t_trial = 1:const.nb_trials
    rand_var1 = expDes.oneV(trialMat(t_trial,1), :);
    
    
    randVal1 = randperm(numel(expDes.oneR)); 
    rand_rand1 = expDes.oneR(randVal1(1));

    %header: onset, duration, run num, trial num, task
    expDes.expMat(t_trial, :) = [NaN, NaN, const.runNum, t_trial, ...   
        rand_var1, rand_rand1];
    
    % 01: trial onset
    % 02: trial duration
    % 03: run number
    % 04: trial number
    % 05: var1: task
    % 07: rand1: triangle tip orientation
    
end

