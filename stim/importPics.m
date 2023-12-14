function const = importPics(const, scr)
% import random images from specified folder.
% MN, September 2021

% select random images
path2pics = dir(fullfile(const.picTask.path2pics, 'image*'));
path2pics = fullfile(path2pics(1).folder, {path2pics(:).name}');
tmp  = unique(randi(numel(path2pics), 1, 100)); tmp = tmp(randperm(numel(tmp))); 
path2pics = path2pics(tmp(1:const.picTask.n_pics));
const.pics.paths = path2pics;

% import images
const.pics.id = cell2mat(arrayfun(@(x) Screen('MakeTexture', scr.main, imread(path2pics{x})), 1:const.picTask.n_pics, 'uni', 0));
end