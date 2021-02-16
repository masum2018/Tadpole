function [DarkNoiseFreeImage] = DarkNoiseCorrection(RawImage,DarkNoise,Parameters,TitleOfTheImage)
% Input: Raw Image and Dark Image
%Output: Dark Noise Free Image
%Author: Monirul, 07/15/2020

%% Set parameters
bDemosaicing=Parameters.bDemosaicing;
bShowPlot=Parameters.bShowPlot;
%% Calculation
DarkNoiseFreeImage=RawImage-DarkNoise;

%% Show Results
if(bDemosaicing==1 && bShowPlot(2)==1 )
    %plot lines
    PlotLines(DarkNoiseFreeImage(:,:,1),DarkNoiseFreeImage(:,:,2),DarkNoiseFreeImage(:,:,3),TitleOfTheImage);
    %     PlotLines_Diagonal(AveragedImage(:,:,1),AveragedImage(:,:,2),AveragedImage(:,:,3));
    
    figure,
    subplot(311), imagesc(DarkNoiseFreeImage(:,:,1));colorbar;title('Dark Noise Corrected Red image');
    subplot(312), imagesc(DarkNoiseFreeImage(:,:,2));colorbar;title('Dark Noise Corrected Green image');
    subplot(313), imagesc(DarkNoiseFreeImage(:,:,3));colorbar;title('Dark Noise Corrected Blue image'); 
end

end

