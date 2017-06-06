
addpath('../Utils/')
addpath('../similarity/')
InputDirectory = 'mask';
Directory = 'Output_Proposed';
ImageDirectory = 'Latent_New';
files = dir(InputDirectory);
len = size(files);
for i=3:len
    name = files(i).name;
    fl = name(1:1);
    [pathstr,name,ext] = fileparts(name);
    imageTitle = strcat(ImageDirectory,'/',name,'_result.jpg');
    if exist(imageTitle,'file') ==2
        THRESHOLD = 0.3;
        maskTitle = strcat(InputDirectory,'/',name,'.txt');
        outputTitle = strcat(Directory,'/',name,'.jpg');
        lambda1 = 6; lambda2 = 2; dict_name = 'dict';
        blksize = 16;
        DB='NIST27';


        ftitle = '137';

        I = imread(imageTitle);
        image=I;

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
        
        prevScore =0;
        newScore =1;
        while abs(newScore-prevScore) >=THRESHOLD
            [Image,simScores] = ReplaceBlockWithSimilarBlockInDictionary(Image);
            prevScore = newScore;
            Image = ReplaceLessFittingBlocks(Image);
            newScore = GetCohesiveScore(Image);
            prevScore
            newScore
        end
        
        DIR1 = Image;
        DrawDir(1,DIR1,blksize,'r');
        DIR = ResizeDirImage(DIR1,blksize);
        DIR = MakeSameSize(DIR,h,w,91);
        PED = ones(size(DIR))*9;
        I2 = GaborEnhance(I,DIR,PED);
        imwrite(I2,outputTitle);
        outputTitle
        break
    end
end