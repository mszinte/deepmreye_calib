function [const, scr] = playPictureViewing(const, scr, currTrial, frames)
% play picture-viewing task
% MN, September 2021

total_n_Trial =  currTrial+const.passedTrials;
%logs{total_n_Trial}.pic = settings.pics.paths{currTrial};
for cFrame = frames
    
    % quit if user aborted experiment
    %[~, firstPress] = KbQueueCheck();
    %if firstPress(logs{1}.keys.escapeKey) || logs{1}.userQuit == 1
    %    logs{1}.userQuit = 1;
    %    return;
    %end
    
    % draw image
    total_n_Trial          =  currTrial+const.passedTrials;
    picSz                  = round(scr.scr_sizeY/3);
    [center(1), center(2)] = RectCenter(scr.rect);
    picCoords              = [center(1)-picSz center(2)-picSz, center(1)+picSz center(2)+picSz];
    Screen('DrawTexture', scr.main, const.pics.id(currTrial), [],picCoords);
    
    % finish drawing and flip to screen
    Screen('DrawingFinished', scr.main);
    Screen('Flip', scr.main);
    
    % log scanner trigger
   % if firstPress(logs{1}.keys.scannerTriggerKey)
    %    logs{1}.tTriggers = [logs{1}.tTriggers, logs{total_n_Trial}.flips(cFrame,1)];
    %end
    
    % log NaN's for xy's
   % logs{total_n_Trial}.xy(cFrame, :) = [nan, nan];
%end

% add trial info to log file
%logs{total_n_Trial}.trialType = 'free_viewing';
end

