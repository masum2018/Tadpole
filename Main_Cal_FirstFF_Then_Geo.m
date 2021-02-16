%Monirul, July,2020
%Apply all calibrations on Raw image
%% Software flow
%{
%   Steps in the code
%   Input: Raw TIFF image(Image_r)
%        a.Dead/Hot pixel corrected(from loaded bin file)
%        b.Demosaicing  (Separate R, G and B layers- 3x65MP pixels)
%   Step1:Dark noise correction(Image_rd)
%   Step2: Geometric Correction(Image_rdg)
%        a.Calibration file has the mapping coordinate(x,y) of distorted and corrected image
%        b.Fill the gap in the corrected image by nearest neighbor pixels
%  Step3:Flatfield Correction(Image_rdgf)
%       A TIFF image(taken from RS-6) is used as a calibration source
%  Step4:Binning on Image(Image_rdgfb)
%       a.Binning is required to reduce the noise
%
%  Step5:Apply Color Cal (Image_rdgfbc)
%       Different color calibration matrix on different spatial location

% Folder Structure
%      A12345678 - Calibration Files- all calibration files
%                -Output files
%                -Raw Images

%  Parameters Note:
%     1. Any variable start with b is binary number. Value is either 0 or 1.
%     2. Any variable start with n is interger number.
%}
%% Environment setting
close all;clear;close all;
set(0,'defaultfigurecolor',[1 1 1]);
set(0,'defaultAxesXLimSpec', 'tight');
tic;
%% Set parameters 
%Customized running for specific angle
Parameters.HorizontalAngle=46;
Parameters.VerticalAngle=0; 
Parameters.nNumberOfImagesBeAveraged=1; % How many images to be averaged?
Parameters.bDemosaicing=1;            % For .tiff image,bDemosaicing=1 and for .raw image, set bDemosaicing=0
Parameters.nBinningSizeRow=128;        % binning size
Parameters.nBinningSizeColumn=128;
Parameters.nImage_width=9344;         %Basic image info for 65MP sensor
Parameters.nImage_height=7000;
Parameters.FlatfieldROIx=50;          % Flatfield gain
Parameters.FlatfieldROIy=50;
Parameters.CroppedRowRange=951:5850;  % Crop image from the 65MP sensor
Parameters.CroppedColumnRange=1001:8350;
% file locations
Parameters.RawImagesFilesLocation='C:\Gamma\65MP\A12345678\Raw Images\';
Parameters.DarkImagesFilesLocation='C:\Gamma\65MP\A12345678\Dark Images\';
Parameters.CalibrationFileLocation='C:\Gamma\65MP\A12345678\Calibration Files\';
Parameters.OutputFileLocation='C:\Gamma\65MP\A12345678\Output Files\';
%calibration file name
Parameters.DeadHotPixelsCalFilename='DeadAndHotPixelsList.mat';
Parameters.GeometricFilename='GeometricCorrectionFile.mat';
Parameters.FlatfieldFilename='FlatfieldCalibrationImage.mat';
Parameters.ColorCalFilename='ColorCalibrationMatrix.mat';

%LMD specific info
Parameters.HorizontalFOV=120;
Parameters.VerticalFOV=80;
%save results
Parameters.CIE1931_x=[];
Parameters.CIE1931_y=[];
Parameters.TristimulusY=[];
Parameters.bShowPlot=  [1,...   %Image_r/Image_d
                        1,...   %Image_rd
                        1,...   %Image_rd with defect pixels correction
                        0,...   %Image_rdfg
                        1,...   %Image_rdf
                        0,...   %Image_rdfgb
                        0,...   %Image_rdgfbc
                        1];     %final results

%  TODO Basic info
Parameters.temp = '31°C';
Parameters.exposure_time = '23 ms';
Parameters.SN = 'A12345678';
Parameters.ImageFormat = '.tiff';
Parameters.DeviceType = 'VR';
Parameters.DeviceName = 'FlatPanel';
Parameters.DeviceGrade = 'A';
Parameters.Orientation = 'Upside Down';
Parameters.DeviceSerialNumber = 'A987654321';
Parameters.Comments = 'Initial Testing';
Parameters.PRNU = '0.31423';
Parameters.DSNU = '12';
% log file
Parameters.LogFileLocation='C:\Gamma\65MP\A12345678\Log Files\';
Parameters.LogFilename = 'Log.txt';
Parameters.LogON = 1;             % set True=any positive number, False=0;
%% Input: Raw TIFF image(Image_r)
Image_r= ReadImages(Parameters,'Raw');
Image_d= ReadImages(Parameters,'Dark');
Image_r=Image_r(Parameters.CroppedRowRange,Parameters.CroppedColumnRange,:);
Image_d=Image_d(Parameters.CroppedRowRange,Parameters.CroppedColumnRange,:);

figure,plot(Image_r(:, 4668,1));
figure,plot(Image_r(:, 4668,2));
figure,plot(Image_r(:, 4668,3));
figure,imagesc(Image_r(:,:,1));axis equal;
figure,imagesc(Image_r(:,:,2));axis equal;
figure,imagesc(Image_r(:,:,3));axis equal;
%% Step1:Dark noise correction(Image_rd)
[Image_rd] = DarkNoiseCorrection(Image_r,Image_d,Parameters,'Dark Noise Corrected');
clear Image_r;
% correct hot/dead pixels
[Image_rd] = CorrectForDeadAndHotPixels(Image_rd,Parameters);
toc;

%% Step2:Flatfield Correction(Image_rdgf)
[Image_rdf] = FlatFieldCorrection(Image_rd,Image_d,Parameters);
% clear Image_d Image_rdg;
toc;

%% Step3: Geometric Correction(Image_rdg)
[Image_rdfg] = GeometricCorrection(Image_rdf,Parameters);
clear Image_rd;
toc;

%% Step4:Binning on Image(Image_rdgfb)
[Image_rdfgb] = Binning(Image_rdf,Parameters);
clear Image_rdfg;
toc
%% Step5:Apply Color Cal (Image_rdgfbc)
[Result] = ApplyColorCalibrationMatrixCustomized(Image_rdfgb,Parameters);
clear Image_rdgfb;
% Parameters.CIE1931_x=Result(:,:,1);
% Parameters.CIE1931_y=Result(:,:,2);
% Parameters.TristimulusY=Result(:,:,3);

Parameters.CIE1931_x=Result(1);
Parameters.CIE1931_y=Result(2);
Parameters.TristimulusY=Result(3);
toc;
%% Step6:Save and show results
% if(Parameters.bShowPlot(7))
%     figure, imagesc(Result(:,:,1)); title('1931_x');
%     figure, imagesc(Result(:,:,2)); title('1931_y');
%     figure, imagesc(Result(:,:,3)); title('Y');
%     
% end
% save result and parameters
SaveResults(Parameters);
disp('Results are saved!!!')
toc;

