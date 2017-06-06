clear all; clc; addpath(genpath(pwd));

%% EXTRACT FEATURES FROM AN ARBITRARY FINGERPRINT
filename='101_1.tif';
img = imread(filename);
if ndims(img) == 3; img = rgb2gray(img); end  % Color Images
disp(['Extracting features from ' filename ' ...']);
ffnew=ext_finger(img,1);

%% GET FEATURES OF AN ARBITRARY FINGERPRINT FROM THE TEMPLATE AND MATCH IT WITH FIRST ONE
filename='101_2.tif';
img = imread(filename);
if ndims(img) == 3; img = rgb2gray(img); end  % Color Images
disp(['Extracting features from ' filename ' ...']);
ffold=ext_finger(img,1);
S=match(ffnew,ffold,1);