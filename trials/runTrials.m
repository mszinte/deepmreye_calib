function expDes = runTrials(scr, const, expDes, my_key, aud)
% ----------------------------------------------------------------------
% expDes = runTrials(scr, const, expDes, my_key, aud)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw stimuli of each indivual trial and waiting for inputs
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : struct containg experimental design
% my_key : structure containing keyboard configurations
% aud : structure containing audio configurations
% ----------------------------------------------------------------------
% Output(s):
% resMat : experimental results (see below)
% expDes : struct containing all the variable design configurations.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Open video
if const.mkVideo
    open(const.vid_obj);
end

% Trial counter
t = expDes.trial;

% Compute and simplify var and rand
var1 = expDes.expMat(t, 5);
rand1 = expDes.expMat(t, 6);

% Check trial
if const.checkTrial && const.expStart == 0
    fprintf(1,'\n\n\t============= TRIAL %3.0f ==============\n',t);
    fprintf(1,'\n\tTask  =\t%s', ...
        const.task_txt{var1});
    fprintf(1,'\n\torientation    =\t%s', ...
        const.orientation_txt{rand1});
end

% Time settings
%add time settings back (on, off frames etc for each task?)

% Wait first MRI trigger
if t == 1
    Screen('FillRect',scr.main,const.background_color);
    drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'conf');
    Screen('Flip',scr.main);
    
    first_trigger = 0;
    expDes.mri_band_val = my_key.first_val(3);
    while ~first_trigger
        if const.scanner == 0 || const.scannerTest
            first_trigger = 1;
            mri_band_val = -8;
        else
            keyPressed = 0;
            keyCode = zeros(1,my_key.keyCodeNum);
            for keyb = 1:size(my_key.keyboard_idx, 2)
                [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
                keyPressed = keyPressed + keyP;
                keyCode = keyCode + keyC;
            end
            if const.scanner == 1
                input_return = [my_key.ni_session2.inputSingleScan,...
                    my_key.ni_session1.inputSingleScan];
                if input_return(my_key.idx_mri_bands) == ...
                        ~expDes.mri_band_val
                    keyPressed = 1;
                    keyCode(my_key.mri_tr) = 1;
                    expDes.mri_band_val = ~expDes.mri_band_val;
                    mri_band_val = input_return(my_key.idx_mri_bands);
                end
            end
            if keyPressed
                if keyCode(my_key.escape) && const.expStart == 0
                    overDone(const, my_key)
                elseif keyCode(my_key.mri_tr)
                    first_trigger = 1;
                end
            end
        end
    end

    % Write in edf file
    log_txt = sprintf('trial %i mri_trigger val = %i', t, ...
                mri_band_val);
    if const.tracker; Eyelink('message', '%s', log_txt); end
end

% Write in edf file
if const.tracker
    Eyelink('message', '%s', sprintf('trial %i started\n', t));
end

% Trial loop
nbf = 0;

%mot_int1_nbf = 0;
%mot_int2_nbf = 0;
%resp_int1 = 0;
%resp_int2 = 0;
%resp_conf = 0;
%feedback_int1 = 0;
%feedback_int2 = 0;

    
% Flip count
nbf = nbf + 1;

% Draw background
Screen('FillRect', scr.main, const.background_color );
%drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'conf');

%-------------------------TASK 1--------------------------
%-------------------------FIXATION-------------------------
%theStr = 'test instruction string';
const.passedTrials = 1;
%const = draw_text(const, 1, 4, theStr); % draw task instructions

const.passedTrials = const.passedTrials + 1; currTrial = 0;
while currTrial<=numel(const.fixtask.xy_trials)-1 %&& logs{1}.userQuit == 0 TODO:adapt
    currTrial = currTrial + 1; 
    cFrame = 0;
    
    % send trial info to eye tracker
   % if settings.eyeTracking == 1; Eyelink('Message',sprintf('Trial%d', currTrial)); end
    
    % show fixation sequence
    frames = cFrame+1:cFrame+const.fixtask.dur_sec*scr.hz;
    [const, cFrame] = playGuidedViewingBullsEye(const, scr, currTrial, frames, 'fixation');
end
const.passedTrials = const.passedTrials + currTrial;

%--------------------SMOOTH PURSUIT-------------------------
const.passedTrials = const.passedTrials + 1; currTrial = 0;  %set current Trial counter to 0 again
while currTrial<=numel(const.pursuit.xy_trials_pursuit)-1 %&& logs{1}.userQuit == 0 TODO:adapt    %while current Trial is smaller than 73, do the following
    currTrial = currTrial + 1; 
    cFrame = 0;    %play for each frame
    
    % send trial info to eye tracker
  %  if settings.eyeTracking == 1; Eyelink('Message',sprintf('Tr%d', currTrial)); end
    
    % show pursuit sequence
    frames = cFrame+1:cFrame+const.pursuit.dur_sec*scr.hz;   %calculate number of frames
    [const, cFrame] = playGuidedViewingBullsEye(const, scr, currTrial, frames, 'pursuit');
end
const.passedTrials = const.passedTrials + currTrial;

%-------------------PICTURE VIEWING----------------------------
const = importPics(const,scr);          % load images for picture viewing

const.passedTrials = const.passedTrials + 1; currTrial = 0; %set current trial counter to 0 again
while currTrial<numel(const.pics.id) %&& logs{1}.userQuit == 0 TODO: adaot
    currTrial = currTrial + 1; 
    cFrame = 0;
    
    % send trial info to eye tracker
  %  if settings.eyeTracking == 1; Eyelink('Message',sprintf('Tr%d', currTrial)); end
    
    % draw image
    frames = cFrame+1:cFrame+const.picTask.dur_sec*scr.hz;
    [const, scr] = playPictureViewing(const, scr, currTrial, frames);
end
const.passedTrials = const.passedTrials + currTrial;




    
    %if run = 2
    %instructions task 2
    %drawBullseye straight ahead, pair with audio
    %drawBullseye position 2 (depends on rotation randomisation), pair with
    %audio
    %drawBullseye position 3, pair with audio
    %drawBullseye straight ahead, pair with audio

    %if run = 3
    %instructions task 3
    %drawBullseye straight ahead, pair with audio
    %eyetracker needs to not shut down
    %drawBullseye position 2 (depends on rotation randomisation), pair with
    %audio
    %eyetracker needs to not shut down
    %drawBullseye position 3, pair with audio
    %eyetracker needs to not shut down
    %drawBullseye straight ahead, pair with audio
    %eyetracker needs to not shut down

    
    %if run = 4 
    %play audio instructions 
    %play audio orientation (rotation depends on randomisation)



    % Interval 1: motion signal
    if nbf >= int1_signal_nbf_on && nbf <= int1_signal_nbf_off
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'int1');
        mot_int1_nbf = mot_int1_nbf + 1;
        
        expDes = drawGlobalMotion(scr, const, expDes, 1, mot_int1_nbf);
    end
    
    % Interval 1: motion direction judgment
    time2resp_int1 = 0;
    if nbf >= int1_resp_nbf_on && nbf <= int1_resp_nbf_off
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'int1');
        time2resp_int1 = 1;
    end
    
    % Interval 1: inter-trial interval
    if nbf >= int1_iti_on && nbf <= int1_iti_off
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'int1');
    end
    
    % Interval 2: motion signal
    if nbf >= int2_signal_nbf_on && nbf <= int2_signal_nbf_off
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'int1');
        mot_int2_nbf = mot_int2_nbf + 1;
        expDes = drawGlobalMotion(scr, const, expDes, 2, mot_int2_nbf);
    end
    
    % Interval 2: motion direction judgment
    time2resp_int2 = 0;
    if nbf >= int2_resp_nbf_on && nbf <= int2_resp_nbf_off
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'int1');
        time2resp_int2 = 1;
    end
    
    % Interval 2: inter-trial interval
    if nbf >= int2_iti_on && nbf <= int2_iti_off
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'int1');
    end
    
    % Confidence response
    time2resp_conf = 0;
    if nbf >= conf_resp_nbf_on && nbf <= conf_resp_nbf_off
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'conf');
        time2resp_conf = 1;
    end
       
    % Intertrials interval
    if nbf >= conf_iti_nbf_on && nbf <= conf_iti_nbf_off
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'conf');
    end

    % Check keyboard
    keyPressed = 0;
    keyCode = zeros(1,my_key.keyCodeNum);
    for keyb = 1:size(my_key.keyboard_idx,2)
        [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
        keyPressed = keyPressed + keyP;
        keyCode = keyCode + keyC;
    end

    if const.scanner == 1 && ~const.scannerTest
        input_return = [my_key.ni_session2.inputSingleScan, ...
            my_key.ni_session1.inputSingleScan];
        
        % button press trigger
        if input_return(my_key.idx_button_left1) == ...
                my_key.button_press_val
            keyPressed = 1;
            keyCode(my_key.left1) = 1;
        elseif input_return(my_key.idx_button_left2) == ... 
                my_key.button_press_val
            keyPressed = 1;
            keyCode(my_key.left2) = 1;
        elseif input_return(my_key.idx_button_left3) == ...
                my_key.button_press_val
            keyPressed = 1;
            keyCode(my_key.left3) = 1;
        elseif input_return(my_key.idx_button_right1) == ...
                my_key.button_press_val
            keyPressed = 1;
            keyCode(my_key.right1) = 1;
        elseif input_return(my_key.idx_button_right2) == ...
                my_key.button_press_val
            keyPressed = 1;
            keyCode(my_key.right2) = 1;
        elseif input_return(my_key.idx_button_right3) == ...
                my_key.button_press_val
            keyPressed = 1;
            keyCode(my_key.right3) = 1;
        end

        % mri trigger
        if input_return(my_key.idx_mri_bands) == ~expDes.mri_band_val
            keyPressed = 1;
            keyCode(my_key.mri_tr) = 1;
            expDes.mri_band_val = ~expDes.mri_band_val;
            mri_band_val = input_return(my_key.idx_mri_bands);
        end
    end

    % Deal with responses
    if keyPressed
        if keyCode(my_key.mri_tr) 
            % MRI triggers
            log_txt = sprintf('trial %i mri_trigger val = %i',t, ...
                mri_band_val);
            if const.tracker; Eyelink('message','%s',log_txt); end
        elseif keyCode(my_key.escape) 
            % Escape button
            if const.expStart == 0; overDone(const, my_key);end
        elseif keyCode(my_key.left1) 
            % Up-left button (135 deg motion)
            if time2resp_int1 && resp_int1 == 0
                log_txt = sprintf('trial %i int1_signal event %s', t,...
                    my_key.left1Val);
                if const.tracker; Eyelink('message','%s',log_txt); end
                resp_val_int1 = 2;                
                expDes.expMat(t, 9) = resp_val_int1;
                expDes.expMat(t, 10) = GetSecs - int1_resp_vbl_on;
                resp_int1 = 1;
            elseif time2resp_int2 && resp_int2 == 0
                log_txt = sprintf('trial %i int2_signal event %s', t, ...
                    my_key.left1Val);
                if const.tracker; Eyelink('message','%s',log_txt); end
                resp_val_int2 = 2;
                expDes.expMat(t, 11) = resp_val_int2;
                expDes.expMat(t, 12) = GetSecs - int2_resp_vbl_on;
                resp_int2 = 1;
            end
        elseif keyCode(my_key.left3) 
            % Down-left button (225 deg motion)
            if time2resp_int1 && resp_int1 == 0
                log_txt = sprintf('trial %i int1_signal event %s', t, ...
                    my_key.left3Val);
                if const.tracker; Eyelink('message','%s',log_txt); end
                resp_val_int1 = 3;
                expDes.expMat(t, 9) = resp_val_int1;
                expDes.expMat(t, 10) = GetSecs - int1_resp_vbl_on;
                resp_int1 = 1;
            elseif time2resp_int2 && resp_int2 == 0
                log_txt = sprintf('trial %i int2_signal event %s', t, ...
                    my_key.left3Val);
                if const.tracker; Eyelink('message','%s',log_txt); end
                resp_val_int2 = 3;
                expDes.expMat(t, 11) = resp_val_int2;
                expDes.expMat(t, 12) = GetSecs - int2_resp_vbl_on;
                resp_int2 = 1;
            end
        elseif keyCode(my_key.left2)
            % Middle-left button (1st interval confidence)
            if time2resp_conf && resp_conf == 0
                log_txt = sprintf('trial %i conf event %s', t, ...
                    my_key.left2Val);
                if const.tracker; Eyelink('message','%s',log_txt); end
                resp_val_conf = 1;
                expDes.expMat(t, 13) = resp_val_conf;
                expDes.expMat(t, 14) = GetSecs - conf_resp_vbl_on;
                resp_conf = 1;
            end
        elseif keyCode(my_key.right1)
            % Up-right button (45 deg motion)
            if time2resp_int1 && resp_int1 == 0
                log_txt = sprintf('trial %i int1_signal event %s', t, ...
                    my_key.right1Val);
                if const.tracker; Eyelink('message','%s',log_txt); end
                resp_val_int1 = 1;
                expDes.expMat(t, 9) = resp_val_int1;
                expDes.expMat(t, 10) = GetSecs - int1_resp_vbl_on;
                resp_int1 = 1;
            elseif time2resp_int2 && resp_int2 == 0
                log_txt = sprintf('trial %i int2_signal event %s', t, ...
                    my_key.right1Val);
                if const.tracker; Eyelink('message','%s',log_txt); end
                resp_val_int2 = 1;
                expDes.expMat(t, 11) = resp_val_int2;
                expDes.expMat(t, 12) = GetSecs - int2_resp_vbl_on;
                resp_int2 = 1;
            end
        elseif keyCode(my_key.right3)
            % Down-right button (315 deg motion)
            if time2resp_int1 && resp_int1 == 0
                log_txt = sprintf('trial %i int1_signal event %s', t, ...
                    my_key.right3Val);
                if const.tracker; Eyelink('message','%s',log_txt); end
                resp_val_int1 = 4;
                expDes.expMat(t, 9) = resp_val_int1;
                expDes.expMat(t, 10) = GetSecs - int1_resp_vbl_on;
                resp_int1 = 1;
            elseif time2resp_int2 && resp_int2 == 0
                log_txt = sprintf('trial %i int2_signal event %s', t, ...
                    my_key.right3Val);
                if const.tracker; Eyelink('message','%s',log_txt); end
                resp_val_int2 = 4;
                expDes.expMat(t, 11) = resp_val_int2;
                expDes.expMat(t, 12) = GetSecs - int2_resp_vbl_on;
                resp_int2 = 1;
            end
        elseif keyCode(my_key.right2)
            % Middle-right button (2nd interval confidence)
            if time2resp_conf && resp_conf == 0
                log_txt = sprintf('trial %i conf event %s', t, ...
                    my_key.right2Val);
                if const.tracker; Eyelink('message','%s',log_txt); end
                resp_val_conf = 2;
                expDes.expMat(t, 13) = resp_val_conf;
                expDes.expMat(t, 14) = GetSecs - conf_resp_vbl_on;
                resp_conf = 1;
            end
        end
    end
    
    % feedback in training
    if const.training
        if resp_int1 == 1 && feedback_int1 == 0 && resp_val_int1 == rand1
            my_sound(4,aud);
            feedback_int1 = 1;
        end
        if resp_int2 == 1 && feedback_int2 == 0 && resp_val_int2 == rand2
            my_sound(4,aud);
            feedback_int2 = 1;
        end
    end
    % Create movie
    if const.mkVideo
        expDes.vid_num = expDes.vid_num + 1;
        image_vid = Screen('GetImage', scr.main);
        imwrite(image_vid,sprintf('%s_frame_%i.png', ...
            const.movie_image_file, expDes.vid_num))
        writeVideo(const.vid_obj,image_vid);
    end

    % flip screen
    vbl = Screen('Flip',scr.main);
        
    % Save trials times
    if nbf == int1_signal_nbf_on 
        trial_on = vbl;
        log_txt = sprintf('int1_signal %i onset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    elseif nbf == int1_resp_nbf_on
        int1_resp_vbl_on = vbl;
        log_txt = sprintf('int1_resp %i offset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    elseif nbf == int1_iti_on
        log_txt = sprintf('int1_iti_on %i onset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    elseif nbf == int2_signal_nbf_on 
        log_txt = sprintf('int2_signal %i onset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    elseif nbf == int2_resp_nbf_on
        int2_resp_vbl_on = vbl;
        log_txt = sprintf('int2_resp %i offset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    elseif nbf == int2_iti_on
        log_txt = sprintf('int2_iti_on %i onset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    elseif nbf == conf_resp_nbf_on
        conf_resp_vbl_on = vbl;
        log_txt = sprintf('conf_resp %i offset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    elseif nbf == conf_iti_nbf_on
        log_txt = sprintf('iti %i onset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    end


expDes.expMat(t, 1) = trial_on;
expDes.expMat(t, 2) = vbl - trial_on;

% Write in log/edf
if const.tracker
    Eyelink('message', '%s', sprintf('trial %i ended\n', t));
end

% When no response received
if resp_int1 == 0
    expDes.expMat(t, 9) = 0;
    expDes.expMat(t, 10) = 0;
end
    
if resp_int2 == 0
    expDes.expMat(t, 11) = 0;
    expDes.expMat(t, 12) = 0;
end    
    
if resp_conf == 0
    expDes.expMat(t, 13) = 0;
    expDes.expMat(t, 14) = 0;
end

    
end