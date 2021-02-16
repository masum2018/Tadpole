function [CorrectedImage] = FlatFieldCorrection(RawImage,DarkImage,Parameters)
%   Input: Demosaicied Image
%        a. Uncorrected Raw Image, b. Reference flatfield images, c. Dark image
%   Output: Corrected image
%   Note: Flatfiled Images are-
%         a. Dark noise corrected,
%         b.Geomatric Distortion corrected
%Note: Flatfield images are collected from RS7-6 by sending broadband uniform light(illuminent E). We will collect 128
%images, then subtrack noise from them, then average them.
%We will use this averaged image as a source of the flatfield.
%Author: Monirul,07/15/2020

%% Set parameters
FlatFieldCorrectionFileLocation=Parameters.CalibrationFileLocation;
Filename=Parameters.FlatfieldFilename;
bShowPlot=Parameters.bShowPlot;
ROIx=Parameters.FlatfieldROIx; % these parameters are used to keep the original intensity of the images
ROIy=Parameters.FlatfieldROIy;


%% Load flatfield image
strFilename = sprintf('%s%s',FlatFieldCorrectionFileLocation,Filename);
load(strFilename); % variable name is FlatfieldImage

%% Apply flatfield calibration

%Separate red, green and blue pixels from the flatfield image
Rf=FlatfieldImage(:,:,1);
Gf=FlatfieldImage(:,:,2);
Bf=FlatfieldImage(:,:,3);

%Separate red, green and blue pixels from the raw image
Rr=RawImage(:,:,1);
Gr=RawImage(:,:,2);
Br=RawImage(:,:,3);

% find the gain
Gain_Red=mean2(Rf((size(RawImage,1)/2)-ROIx/2: (size(RawImage,1)/2)+ROIx/2,  (size(RawImage,2)/2)-ROIy/2: (size(RawImage,2)/2)+ROIy/2 ));
Gain_Green=mean2(Gf((size(RawImage,1)/2)-ROIx/2: (size(RawImage,1)/2)+ROIx/2,  (size(RawImage,2)/2)-ROIy/2: (size(RawImage,2)/2)+ROIy/2 ));
Gain_Blue=mean2(Bf((size(RawImage,1)/2)-ROIx/2: (size(RawImage,1)/2)+ROIx/2,  (size(RawImage,2)/2)-ROIy/2: (size(RawImage,2)/2)+ROIy/2 ));

% Apply correction
% CorrectedRedImage=Gain_Red*(Rr- DarkImage(:,:,1))./ (FlatfieldImage(:,:,1)- DarkImage(:,:,1)) ;
% CorrectedGreenImage=Gain_Green*(Gr- DarkImage(:,:,2))./ (FlatfieldImage(:,:,2)- DarkImage(:,:,2));
% CorrectedBlueImage=Gain_Blue*(Br- DarkImage(:,:,3))./ (FlatfieldImage(:,:,3)- DarkImage(:,:,3)) ;

% If both raw and flatfield images are dark noise corrected
CorrectedRedImage=Gain_Red*Rr./ FlatfieldImage(:,:,1) ;
CorrectedGreenImage=Gain_Green*Gr./ FlatfieldImage(:,:,2);
CorrectedBlueImage=Gain_Blue*Br./ FlatfieldImage(:,:,3) ;

% combine corrected image and return as an output
CorrectedImage=RawImage*0;
CorrectedImage(:,:,1)=CorrectedRedImage;
CorrectedImage(:,:,2)=CorrectedGreenImage;
CorrectedImage(:,:,3)=CorrectedBlueImage;

%% Show results
if(bShowPlot(5))
    % show vertical and horizontal line
    PlotLines(Rr,Gr,Br,'Before Flatfield Correction');
    PlotLines(CorrectedRedImage,CorrectedGreenImage,CorrectedBlueImage,'After Flatfield Correction');  
  % show full image
    figure,
    subplot(311), imagesc(CorrectedRedImage);colorbar;title('Flatfield Corrected Red image');
    subplot(312), imagesc(CorrectedGreenImage);colorbar;title('Flatfield Corrected Green image');
    subplot(313), imagesc(CorrectedBlueImage);colorbar;title('Flatfield Corrected Blue image');    
end
end

