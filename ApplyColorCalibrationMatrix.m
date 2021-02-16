function [Results] = ApplyColorCalibrationMatrix(Image,Parameters);

%{
Input: Corrected image, calibration matrix
calibration matrix format:

Hlimit_L_deg    Hlimit_H_deg    Vlimit_L_deg    Vlimit_H_deg    Cal_H_deg    Cal_V_deg      X11          X12           X13         Y11         Y12          Y13            Z11           Z12         Z13
    ____________    ____________    ____________    ____________    _________    _________    ________    __________    _________    ________    ________    __________    ___________    _________    ________

         -5              5                -5              5             0            0        0.057974      0.012034     0.019673    0.015262    0.065893     -0.011295    -0.00083928    -0.033661     0.15567
         -2              2                 8             18             0           14        0.050033       0.01046     0.017109    0.013105    0.055865    -0.0091316     -0.0002807     -0.02827     0.13239
         -2              2              18.1             28             0           24        0.040144     0.0070043     0.014327    0.010471    0.042407     -0.006081      0.0006201    -0.022961     0.10402
         -2              2              28.1             40             0           34        0.039783    0.00029439     0.013752    0.012343    0.031034    -0.0035767      0.0050007    -0.024587    0.090246
         -2              2              40.1             50             0           46        0.036788    -0.0022621    0.0090691    0.015318    0.018554     -0.002357       0.012972    -0.019273    -4.93951
 
Output: CIE1931x,CIE1931y,Y
Author:Monirul, 07/17/2020

%}
%TODO- Add dynamic logic to reduce CCMs
%% set parameters
ColorCalibrationFileLocation=Parameters.CalibrationFileLocation;
Filename=Parameters.ColorCalFilename;
bShowPlot=Parameters.bShowPlot;
HorizontalFOV=Parameters.HorizontalFOV;
VerticalFOV=Parameters.VerticalFOV;
%% load calibration matrix
strFilename = sprintf('%s%s',ColorCalibrationFileLocation,Filename);
load(strFilename);   % variable name: ColorCalibrationMatrix
%% segmenttize the sensor area and apply CCM based on area
%{
Need to choose sensor area based on CCMs performance
Area of each CCM could be circular/square
Based on that, algorithm needs to change.
Initial code is written based on available horizontal and vertical data
with arbitery area serve by each CCM.
%}

%Traverse Horizontal and vertical Angles

CenterH=size(Image,2)/2; % if optoical axis and image center position is not same, need to set appropiate value
CenterV=size(Image,1)/2;

ConvertPixel2Degree_H=size(Image,2)/HorizontalFOV;
ConvertPixel2Degree_V=size(Image,1)/VerticalFOV;

Results=Image*0;
for(v=1:size(Image,1))
    
    for(h=1:size(Image,2))
        
        % current H & V angle on the image plane
        HorizontalAngle=(h-CenterH)/ConvertPixel2Degree_H;
        VerticalAngle=(v-CenterV)/ConvertPixel2Degree_V;
        
        % Find CCM corresponding to Horizontal and vertical angle        
        Index = find(HorizontalAngle>=ColorCalibrationMatrix.Hlimit_L_deg  & HorizontalAngle<=ColorCalibrationMatrix.Hlimit_H_deg ...
            & VerticalAngle>=ColorCalibrationMatrix.Vlimit_L_deg & VerticalAngle<=ColorCalibrationMatrix.Vlimit_H_deg);
        
        CalMatrix=ColorCalibrationMatrix{Index,{ 'X11', 'X12', 'X13', 'Y11', 'Y12', 'Y13', 'Z11','Z12','Z13'}};
        
        %find corresponding RGB
        R=Image(v,h,1); G=Image(v,h,2); B=Image(v,h,3);
        %calculate color info
        [x,y,Y] = CalculateColorValue(CalMatrix,R,G,B);
        
        % store the color info
        Results(v,h,1)=x;
        Results(v,h,2)=y;
        Results(v,h,3)=Y;
        
    end

end


end

