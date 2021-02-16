function [CorrectedImage] = CorrectForDeadAndHotPixels(Image,Parameters)
%  Replace_defects - average of their 4 nearest neighbors
%  input: Image, defect_pixel_list as array
%  TODO ignore replcaement pixels if it is adjacent to another
%  defect"

% Author: Original- Mithran, Modified by Monirul, 07/22/2020

%% Set parameters
DeadAndHotPixelsCorrectionFileLocation=Parameters.CalibrationFileLocation;
Filename=Parameters.DeadHotPixelsCalFilename;
bShowPlot=Parameters.bShowPlot;
%% Load list of defect pixels
strFilename = sprintf('%s%s',DeadAndHotPixelsCorrectionFileLocation,Filename);
load(strFilename);  % Loaded variable name: defect_list

%% Remove dead/hot pixels
CorrectedImage = Image;
num_defects =size(defect_list,1);
% Remove all defects outside of 5 pixels from edge.
[r,c] = size(Image);
i = find(defect_list(:,1)>12);         % why 12?
i1 = find(defect_list(:,1)<(r-12));
indices_i = intersect(i,i1);
j = find(defect_list(:,2)>12);
j1 = find(defect_list(:,2)<(c-12));
indices_j = intersect(j,j1);
indices_all = intersect(indices_i,indices_j);
defect_list_final = defect_list(indices_all,:);
num_defects = size(defect_list_final,1);

% Replace defects with NaN
for i= 1:num_defects
    CorrectedImage(defect_list_final(i,1),defect_list_final(i,2))=NaN;
end

for i = 1:num_defects
    c = defect_list_final(i,2);
    r = defect_list_final(i,1);
    
    %  4 nearest neighbors vs 8
    %CorrectedImage(r,c) = nanmean([Image(r+2,c),Image(r-2,c),Image(r,c+2),Image(r,c-2)]);
    CorrectedImage(r,c) = nanmean([Image(r+2,c),Image(r-2,c),Image(r,c+2),Image(r,c-2)...
        Image(r+2,c-2),Image(r-2,c-2),Image(r+2,c+2),Image(r-2,c+2)],'All');                   % Added 'All' to get average of all elements, Monirul,07/24/2020
    % comment these lines out for ignoring defects
    if(bShowPlot(3))
        fig = figure();
        subplot(211)
        imagesc(Image(r-12:r+12,c-12:c+12));
        colorbar();
        subplot(212)
        imagesc(CorrectedImage(r-12:r+12,c-12:c+12));
        colorbar();
        %     close(fig);
    end
    
end
%%  Plot fixed pixels as well as random pixels, verify it is fixed.
% [row, col] = find(isnan(CorrectedImage));
% disp(strcat('Remaining NaNs in row', string(row)));
% rr = randperm(r,1000);
% rc = randperm(c,1000);
% rind = sub2ind(size(CorrectedImage),rr,rc);
% 
% if(bShowPlot(3))
%     
%     fig2 = figure();
%     dindex = sub2ind(size(CorrectedImage),defect_list_final(:,1),defect_list_final(:,2));
%     plot(Image(rind),CorrectedImage(rind),'b.');
%     hold on;
%     grid on;
%     plot(Image(dindex),CorrectedImage(dindex),'r.');
%     legend(['Random Pixels','Defect Pixels']);
%     xlabel('Uncorrected values');
%     ylabel('Corrected Values');
%     title('Defect Pixel versus corrected pixels')
%     % saveas(fig,char(strcat(obj.filepath,"/",obj.name,"_defect_pixel_correct.png")));
%     % close(fig);    
% end
end





