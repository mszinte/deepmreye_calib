function const = constConfig(scr, const)
% ----------------------------------------------------------------------
% const = constConfig(scr, const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define all constant configurations
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Randomization
[const.seed, const.whichGen] = ClockRandSeed;

const.task_lst = [1,2,3,4];
const.task_txt = {'CalibMatthias', 'TriangleOpen', 'TriangleartClosed', 'TriangleClosed'};
const.orientation_lst = [0,90,180,360];   %in degrees, need to check still for triangles
const.orientation_txt = {'0', '90', '180', '360'};

% Colors
const.white = [1, 1, 1];
const.black = [0,0,0];
const.gray = [0.5, 0.5, 0.5];
const.dark_gray = [0.3, 0.3, 0.3];
const.red = [0.8, 0, 0];
const.green = [0.2, 0.7, 0.2];
const.fixation_color = const.dark_gray;
const.background_color = const.gray; 


% Time parameters
const.TR_sec = 1.2;                                                         % MRI time repetition in seconds
const.TR_frm = round(const.TR_sec/scr.frame_duration);                      % MRI time repetition in seconds in screen frames

%new stimulus time parameters
const.fixtask.dur_TR = 1;                                                       % Fixation task stimulus duration in scanner TR
const.fixtask.dur_sec = const.fixtask.dur_TR * const.TR_sec;                    % Fixation task stimulus duration in seconds, should be 1.5
const.fixtask.dur_frm = round(const.fixtask.dur_sec /scr.frame_duration);       % Total stimulus duration in screen frames

const.pursuit.dur_TR = 1;                                                   % Smooth pursuit task stimulus duration in scanner TR
const.pursuit.dur_sec = const.pursuit.dur_TR * const.TR_sec; 
disp(['smooth pursuit stimulus duration:' const.pursuit.dur_sec])           % Smooth pursuit task stimulus duration in seconds
const.pursuit.dur_frm = round(const.pursuit.dur_sec /scr.frame_duration);   % Total stimulus duration in screen frames

const.picTask.dur_TR = 1;                                                   % Picture free viewing task stimulus duration in scanner TR
const.picTask.dur_sec = const.picTask.dur_TR * const.TR_sec;                % Picture free viewing task stimulus duration in seconds
const.picTask.dur_frm = round(const.picTask.dur_sec /scr.frame_duration);   % Total stimulus duration in screen frames


const.TRs = (const.fixtask.dur_TR+const.pursuit.dur_TR+const.picTask.dur_TR)*2; % TR per trials
    

% Stim parameters
[const.ppd] = vaDeg2pix(1, scr); % one pixel per dva
const.dpp = 1/const.ppd;    
const.env_size_dva = 0.125;                                                 % Half-size of envelope (dva)
const.env_size_pix = vaDeg2pix(const.env_size_dva, scr);                    % half-size of envelope (pix)

const.im_wdth = 5*const.env_size_pix+1;                                     % Size of support in pixels, make odd number (?) /Needed??
const.im_hght = 5*const.env_size_pix+1;                                     % Size of support in pixels, make odd number (?)


%Fixation Task (Calib Matthias)

const.fixtask.win_sz         =    [scr.scr_sizeY, scr.scr_sizeY]./1.25;% % sample fixations within this window
const.fixtask.n_locs         =    [3 3]; % n fixation locations [horizontal, vertical] [10 10]
const                        =    getFixLocations(const,scr);

%Smooth Pursuit Task (Calib Matthias) 
const.pursuit.win_sz         =    const.fixtask.win_sz;
const.pursuit.angles         =    deg2rad(0:15:359); % tested directions
const.pursuit.mov_amp        =    [4 6 8]; % movement amplitudes in visual angle
valid = 0; while ~valid
    [const, valid]           =    getFixLocations_pursuit(const,scr,valid); end % smooth pursuit task


%Picture Free Viewing Task (Calib Matthias) 
const.picTask.path2pics      =   fullfile('C:\Users\sinak\Documents\INT\Year_1\DeepMReye\new_experiment\new_experiment\others\images'); % needs to be made flexible
const.picTask.n_pics         =   3; % how many of the pictures in the folder should be shown (random selection)? (10)


%Traingle eyes open

%TODO add stuff
%Triangle partly eyes closed 

%TODO add stuff

%Triangle fully eyes closed 

%TODO add stuff

% Trial settings
if const.mkVideo
    const.nb_repeat = 1;                                                    % Trial repetition in video mode
    const.nb_trials = 1;                                                    % Number of trials in video mode
else
    const.nb_repeat = 4;                                                    % Trial repetition
    const.nb_trials = const.nb_repeat * length(const.task_lst) * ... % Number of trials
        length(const.task_lst);
end



% define total TR numbers and scan duration
if const.scanner
    const.TRs_total = const.nb_trials*const.TRs;
    fprintf(1,'\n\tScanner parameters: %1.0f TRs of %1.2f seconds for a total of %s\n',...
        const.TRs_total, const.TR_sec, ...
        datestr(seconds((const.TRs_total*const.TR_sec...
        )),'MM:SS'));
end

% Bullseye configs
const.fix_out_rim_radVal = 0.25;                                            % radius of outer circle of fixation bull's eye in dva
const.fix_rim_radVal = 0.75*const.fix_out_rim_radVal;                       % radius of intermediate circle of fixation bull's eye in dva
const.fix_radVal = 0.25*const.fix_out_rim_radVal;                           % radius of inner circle of fixation bull's eye in dva
const.fix_out_rim_rad = vaDeg2pix(const.fix_out_rim_radVal, scr);           % radius of outer circle of fixation bull's eye in pixels
const.fix_rim_rad = vaDeg2pix(const.fix_rim_radVal, scr);                   % radius of intermediate circle of fixation bull's eye in pixels
const.fix_rad = vaDeg2pix(const.fix_radVal, scr);                           % radius of inner circle of fixation bull's eye in pixels

% Personal calibrations
angle = 0:pi/3:5/3*pi;
 
% compute calibration target locations
const.calib_amp_ratio = 0.5;
[cx1, cy1] = pol2cart(angle, const.calib_amp_ratio);
[cx2, cy2] = pol2cart(angle + (pi / 6), const.calib_amp_ratio * 0.5);
cx = round(scr.x_mid + scr.x_mid * [0 cx1 cx2]);
cy = round(scr.y_mid + scr.x_mid * [0 cy1 cy2]);
 
% order for eyelink
const.calibCoord = round([cx(1), cy(1),...                                  % 1. center center
    cx(9), cy(9),...                                                        % 2. center up
    cx(13),cy(13),...                                                       % 3. center down
    cx(5), cy(5),...                                                        % 4. left center
    cx(2), cy(2),...                                                        % 5. right center
    cx(4), cy(4),...                                                        % 6. left up
    cx(3), cy(3),...                                                        % 7. right up
    cx(6), cy(6),...                                                        % 8. left down
    cx(7), cy(7),...                                                        % 9. right down
    cx(10), cy(10),...                                                      % 10. left up
    cx(8), cy(8),...                                                        % 11. right up
    cx(11), cy(11),...                                                      % 12. left down
    cx(12), cy(12)]);                                                       % 13. right down

% compute validation target locations (calibration targets smaller radius)
const.valid_amp_ratio = const.calib_amp_ratio * 0.8;
[vx1, vy1] = pol2cart(angle, const.valid_amp_ratio);
[vx2, vy2] = pol2cart(angle + pi /6, const.valid_amp_ratio * 0.5);
vx = round(scr.x_mid + scr.x_mid*[0 vx1 vx2]);
vy = round(scr.y_mid + scr.x_mid*[0 vy1 vy2]);

% order for eyelink
const.validCoord =round([vx(1), vy(1),...                                   % 1. center center
    vx(9), vy(9),...                                                        % 2. center up
    vx(13), vy(13),...                                                      % 3. center down
    vx(5), vy(5),...                                                        % 4. left center
    vx(2), vy(2),...                                                        % 5. right center
    vx(4), vy(4),...                                                        % 6. left up
    vx(3), vy(3),...                                                        % 7. right up
    vx(6), vy(6),...                                                        % 8. left down
    vx(7), vy(7),...                                                        % 9. right down
    vx(10), vy(10),...                                                      % 10. left up
    vx(8), vy(8),...                                                        % 11. right up
    vx(11), vy(11),...                                                      % 12. left down
    vx(12), vy(12)]);                                                       % 13. right down
end