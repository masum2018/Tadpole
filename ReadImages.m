function [AveragedImage] = ReadImages(Parameters,TitleOfTheImage)

%   Input: SourceOfFiles=Location of the raw images
%   nNumberOfImagesBeAveraged= How many images need to be averaged
%   ImageFormat: .raw if bDemosaicing=0, TIFF if bDemosaicing=1;
%   Author: Monirul, 07/15/2020

%% Get parameters
if(strcmp(TitleOfTheImage,'Raw'))
    SourceOfFiles=Parameters.RawImagesFilesLocation;
else
    SourceOfFiles=Parameters.DarkImagesFilesLocation;
end
width=Parameters.nImage_width;
height=Parameters.nImage_height;
nNumberOfImagesBeAveraged=Parameters.nNumberOfImagesBeAveraged;
bShowPlot=Parameters.bShowPlot;
bDemosaicing=Parameters.bDemosaicing;
%% Load and process image
if(bDemosaicing)
    Files= dir([SourceOfFiles,'*.tiff']);
    % save log
    if(Parameters.LogON)
        SaveLog('Loaded image is .tiff format',Parameters)
    end
else
    Files= dir([SourceOfFiles,'*.raw']);
    BufferLength=width*height;
    if(Parameters.LogON)
        SaveLog('loaded image is .raw format',Parameters)
    end
end

AveragedImage=0;
if(nNumberOfImagesBeAveraged>length(Files))
    nNumberOfImagesBeAveraged= length(Files);
end
%read all images from a folder
for(imageCount=1:nNumberOfImagesBeAveraged)
    
    strFilename = sprintf('%s%s',SourceOfFiles,Files(imageCount).name);
    disp(strFilename);
    % read images
    if(bDemosaicing)
        Image=double(imread(strFilename));
    else
        
        fileID = fopen(strFilename,'r');
        img=fread(fileID,BufferLength,'ubit16');
        fclose(fileID);
        Image=reshape(img, [width,height]);
    end
    AveragedImage=AveragedImage+Image;
    % save log
    if(Parameters.LogON)
        SaveLog(strFilename,Parameters)
    end
end

AveragedImage=AveragedImage/nNumberOfImagesBeAveraged;

if(~bDemosaicing)
    AveragedImage=AveragedImage';
end

%% Show loaded image
if(bDemosaicing==1 && bShowPlot(1)==1 )
    %plot lines
    PlotLines(AveragedImage(:,:,1),AveragedImage(:,:,2),AveragedImage(:,:,3),TitleOfTheImage);
    %     PlotLines_Diagonal(AveragedImage(:,:,1),AveragedImage(:,:,2),AveragedImage(:,:,3));
    figure,
    subplot(311), imagesc(AveragedImage(:,:,1));colorbar;title('Red ');
    subplot(312), imagesc(AveragedImage(:,:,2));colorbar;title(' Green ');
    subplot(313), imagesc(AveragedImage(:,:,3));colorbar;title(' Blue '); 
    
end
end

