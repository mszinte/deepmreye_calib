function [const, cFrame] = playGuidedViewingBullsEye(const, scr, currTrial, frames, flag)
% play fixation or smooth pursuit task
% MN, September 2021

% select fixation/pursuit trajectory
%if strcmp(flag, 'fixation'); xy = const.fixtask.xy_trials;
%elseif strcmp(flag, 'pursuit'); xy = const.pursuit.xy_trials_pursuit; end

% play all frames
for cFrame = frames
    
    % quit if user aborted experiment
%    [~, firstPress] = KbQueueCheck();
%    if keyCode(my_key.escape) && const.expStart == 0 NEED TO CHECK 
%                    overDone(const, my_key) 
%    end
    
    % draw bullseye
    total_n_Trial =  currTrial+const.passedTrials;  %calculate nr of all trials that already happened
    if strcmp(flag, 'fixation')
    drawBullsEye(scr, const, const.fixtask.xy_trials{currTrial}(cFrame, 1), const.fixtask.xy_trials{currTrial}(cFrame, 2), 'int1');  %adapted to have bullseye instead of fixation cross

    elseif strcmp(flag, 'pursuit')
    drawBullsEye(scr, const, const.pursuit.xy_trials_pursuit{currTrial}(cFrame, 1), const.pursuit.xy_trials_pursuit{currTrial}(cFrame, 2), 'int1');  %adapted to have bullseye instead of fixation cross


    end
    % finish drawing and flip to screen
    Screen('DrawingFinished', scr.main);
    Screen('Flip', scr.main);
    
    % log scanner trigger
%    if firstPress(logs{1}.keys.scannerTriggerKey)
%        logs{1}.tTriggers = [logs{1}.tTriggers, logs{total_n_Trial}.flips(cFrame,1)];
 %   end
end

% add trial info to log file
%{total_n_Trial}.trialType = flag;   
end

