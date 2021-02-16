function [Image_FilledGap] = GeometricCorrection(Image,Parameters)
%{
Input: Distored image and calibration matrix
Calibration matrix is a 2D array of data(X & Y corordinate) like this:
  X__Original   X_ Corrected  Y_Original   Y_Corrected
       1           -10           1          50
        ..         ...
       7000        7200          1           51
this sequence will repeat columnwise

Note: If we save the calibration matrix like above, total size of the
matrix will be 4x65M pixels. However, we can reduce it to 2x65M as we know
the sequence of the original image coordinate.

below code, loaded cal variable name is SaveXUYV.

Output: Corrected Images
Author: Monirul, 07/16/2020
%}
%% Set parameters
GeometricCorrectionFileLocation=Parameters.CalibrationFileLocation;
Filename=Parameters.GeometricFilename;
bShowPlot=Parameters.bShowPlot;
bFillEmptyPixelsByNaN=1;      % internal control, just to check the speed of the method
%% Load calibration matrix
strFilename = sprintf('%s%s',GeometricCorrectionFileLocation,Filename);
load(strFilename);
if(bFillEmptyPixelsByNaN)
    CorrectedImage=Image* NaN;
else
    CorrectedImage=Image*0;
end
%% Transfer intensity value from distorted image to corrected image plane
nSaveCount=0;
for(i=1:1:size(Image,2)) % X
    for(j=1:1:size(Image,1))    %Y
        
        r=SaveXUYV(j,nSaveCount+2);
        c= SaveXUYV(j,nSaveCount+4);
        
        % As image is expanded near the corner of the image(other place as well), there will
        % many out of range number(Negative, or higher than original pixel limit). As we are not changing the size of the
        % original image, we have to limit the the corrected x & y
        % coordinate within original image.
        if(  c>=1 && r>=1 && c<=size(Image,2) && r<=size(Image,1))
            CorrectedImage(r,c,:)=Image(j,i,:);
        end
        
    end
    nSaveCount=nSaveCount+4;
    
end

%% Fill the empty pixels

% As image is expanding(barrel distortion for our WFOV lens), there will be
% empty pixels space. There number of the empty space is higher near the
% edges of the image as distortion is high over there. We need to correct
% for that.

% There are couple of methods to correct the empty space. I chose nearest
% neighbor averaging method.

if(bFillEmptyPixelsByNaN)
    Image_FilledGap = FillEmptyNaNPixels(CorrectedImage);
    
else
    Image_FilledGap = FillEmptyPixels(CorrectedImage);
end
%% Show results
if(bShowPlot(4))
    figure,imagesc(Image(:,:,1));colormap gray;
%     colormap(jet);
    axis equal;title('Before Geometric Correction');
    
    figure,imagesc(CorrectedImage(:,:,1));colormap gray;
%     colormap(jet);
    axis equal;title('Before Empty Pixels Correction');
    
    figure,imagesc(Image_FilledGap(:,:,1));colormap gray;
%     colormap(jet);
    axis equal;title('After Geometric Correction');
end

end

