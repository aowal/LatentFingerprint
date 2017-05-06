
addpath('../Utils/')
addpath('../similarity/')
THRESHOLD = 0.3;
imageTitle = ['../../Fingerprint Database/Images/' ftitle '.jpg'];
I = imread(imageTitle);
image=I;
DB='NIST27';
lambda1 = 6; lambda2 = 2; dict_name = 'dict';
blksize = 16;
param = SetParam(DB,image,blksize);
param.lambda1 = lambda1;
param.lambda2 = lambda2;
bh = param.bh;
bw = param.bw;
MASK = true(bh,bw);
[A,~,DIR] = GetBlocksStrongWaves(image,param,MASK);
DIR =  NormalizeRidgeDir( round(-DIR*180/pi-90) ) ;
DIR(A==0)=91;


ImageData = reshape(DIR(:,1),[bh bw]);

ImageData = reshapeImage(ImageData);
Image = ReplaceBlockWithSimilarBlockInDictionary(ImageData);
prevScore =0;
newScore = getCohesiveScore(Image);

while abs(newScore-prevScore) >=THRESHOLD
    prevScore = newScore;
    Image = ReplaceLessFittingBlocks(Image);
    newScore = getCohesiveScore(Image);
end

show(Image);

