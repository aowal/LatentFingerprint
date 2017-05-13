
addpath('../Utils/')
addpath('../similarity/')
THRESHOLD = 0.3;
imageTitle = ['../../Images/137.bmp'];
maskTitle = ['../../Images/q137.txt'];
lambda1 = 6; lambda2 = 2; dict_name = 'dict';
blksize = 16;
DB='NIST27';

% This dictionary was learnt from a list of fingerprints in NIST SD4 (a patch contains 10x10 blocks and a block contains 16x16 pixels),

ftitle = '137';

%% Load image
I = imread(imageTitle);
image=I;
%% Set parameter
%%First We Need To Find Where the fnger print is identifies
%%


[h,w] = size(I);

param = SetParam(DB,image,blksize);
param.lambda1 = lambda1;
param.lambda2 = lambda2;
bh = param.bh;
bw = param.bw;
if strcmp(DB,'NIST27')
    MASK = load(maskTitle);
    MASK = MASK>0;
else
    MASK = true(bh,bw);
end

[A,~,DIR] = GetBlocksStrongWaves(image,param,MASK);
DIR =  NormalizeRidgeDir( round(-DIR*180/pi-90) ) ;
DIR(A==0)=91;
DIR1 = reshape(DIR(:,1),[bh bw]);
DIR2 = DIR1;
Image = reshapeImage(DIR1);
% Image
% imshow(Image);

% prevScore =0;
% newScore = getCohesiveScore(Image);

% Main Run! 
prevScore =0;
newScore =1;
size(Image)
while abs(newScore-prevScore) >=THRESHOLD
    [Image,simScores] = ReplaceBlockWithSimilarBlockInDictionary(Image);
    prevScore = newScore;
    Image = ReplaceLessFittingBlocks(Image);
    newScore = GetCohesiveScore(Image);
end
DIR1 = Image;
DrawDir(1,DIR1,blksize,'r');
DIR = ResizeDirImage(DIR1,blksize);
DIR = MakeSameSize(DIR,h,w,91);
PED = ones(size(DIR))*9;
I2 = GaborEnhance(I,DIR,PED);
Show(2,I2);
imshow(I2);

% DIR1 = DIR2;
% DrawDir(1,DIR1,blksize,'r');
% DIR = ResizeDirImage(DIR1,blksize);
% DIR = MakeSameSize(DIR,h,w,91);
% PED = ones(size(DIR))*9;
% I2 = GaborEnhance(I,DIR,PED);
% Show(3,I2);
% figure ,imshow(I2);


