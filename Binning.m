function [OutputImage] = Binning(Image,Parameters)
%Binning of image
%  Input: Image
%  bDemosaicing=1, Image is 3D else image is 2D
%  Output: Binning image
%  Author: Monirul, 07/15/2020
%% Set parameters
ROIr=Parameters.nBinningSizeRow;
ROIc=Parameters.nBinningSizeColumn;
bDemosaicing=Parameters.bDemosaicing;
bShowPlot=Parameters.bShowPlot;
%% Perform Binning
% OutputImage=Image*0;

if(bDemosaicing)
    Image_Red=Image(:,:,1);
    Image_Green=Image(:,:,2);
    Image_Blue=Image(:,:,3);
    [Red] = Binning_MonoChrome(Image_Red,ROIr,ROIc);
    [Green] = Binning_MonoChrome(Image_Green,ROIr,ROIc);
    [Blue] = Binning_MonoChrome(Image_Blue,ROIr,ROIc);
    
    OutputImage(:,:,1)=Red;
    OutputImage(:,:,2)=Green;
    OutputImage(:,:,3)=Blue;
else
    OutputImage= Binning_MonoChrome(Image,ROIr,ROIc);
    
end


%% Show results
if(bShowPlot(6))
    figure,imagesc(Image);colormap(jet);
    axis equal;title('Before Binning');
    
    figure,imagesc(OutputImage);colormap(jet);
    axis equal;title('After Binning');
end
end


