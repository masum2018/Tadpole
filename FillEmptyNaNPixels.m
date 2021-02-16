function [CorrectedImage] = FillEmptyNaNPixels(Image)

%  Input: Image with NaN pixels
%  Output:Image with filled pixels
%  If there is any empty space, fill the the gap from sourronding pixels
%  Author: Monirul, 07/22/2020

%% Apply the logic for inner part first excluding edge pixels
CorrectedImage=Image;
for(i=2:(size(Image,1)-1))
    for(j=2:(size(Image,2)-1))
        
        if(isnan(Image(i,j)))
            % nearest 4 neighbour averaging
            I= nanmean([Image(i,j+1,:),Image(i+1,j,:),Image(i-1,j-1,:),Image(i,j-1,:)]);
            if(isnan(I))
                % nearest 8 neighbour averaging
                I= nanmean([Image(i,j+1,:),Image(i+1,j,:),Image(i-1,j-1,:),Image(i,j-1,:),...
                    Image(i-1,j-1,:),Image(i+1,j-1,:),Image(i-1,j+1,:),Image(i+1,j+1,:)]);
                CorrectedImage(i,j,:)  =I;   % sacrificing special resolution
            else
                CorrectedImage(i,j,:)  =I;
            end
        end % if(isnan(Image(i,j)))
        
        
    end % for(j=2:(size(Image,2)-1))
end %for(i=2:(size(Image,1)-1))

%% Fill the empty space for the edge pixels of the image

% top row (row number 1)
i=1;
for(j=2:(size(Image,2)-1))
    
    if(isnan(Image(i,j)))
        
        CorrectedImage(i,j,:)  =nanmean([Image(i,j+1,:),Image(i+1,j,:),Image(i,j-1,:)]);
        
    end % if(Image(i,j)==0)
end

% special treatment:top left corner
i=1;j=1;
if(isnan(Image(i,j)))
    CorrectedImage(i,j,:)= nanmean([Image(i,j+1,:),Image(i+1,j,:),Image(i+1,j+1,:)]);
end
% special treatment:top right corner
i=1;j=size(Image,2);
if(isnan(Image(i,j)))
    CorrectedImage(i,j,:)=nanmean ([Image(i,j-1,:),Image(i+1,j,:),Image(i+1,j-1,:)]);
end


% bottom row (row number: size(Image,1))
i=size(Image,1);
for(j=2:(size(Image,2)-1))
    
    if(isnan(Image(i,j)))
        CorrectedImage(i,j,:)  =nanmean([Image(i,j+1,:),Image(i-1,j,:),Image(i,j-1,:)]);
    end % if(Image(i,j)==0)
end

% special treatment:Bottom left corner
i=size(Image,1);j=1;
if(isnan(Image(i,j)))
    CorrectedImage(i,j,:)= nanmean([Image(i,j+1,:),Image(i-1,j,:),Image(i-1,j+1,:)]);
end
% special treatment:Bottom right corner
i=size(Image,1);j=size(Image,2);
if(isnan(Image(i,j)))
    CorrectedImage(i,j,:)=nanmean([Image(i,j-1,:),Image(i-1,j,:),Image(i-1,j-1,:)]);
end

%Column number 1
j=1;
for(i=2:(size(Image,1)-1))
    
    if(isnan(Image(i,j)))
        CorrectedImage(i,j,:)  =nanmean([Image(i,j+1,:),Image(i-1,j,:),Image(i+1,j,:)]);
    end % if(isnan(Image(i,j)))
end

%Column number :size(Image,2)
j=size(Image,2);
for(i=2:(size(Image,1)-1))
    
    if(isnan(Image(i,j)))
        CorrectedImage(i,j,:)  =nanmean([Image(i,j-1,:),Image(i-1,j,:),Image(i+1,j,:)]);
    end % if(isnan(Image(i,j)))
end

%% TODO, final check of NaN number
%for now
CorrectedImage(isnan(CorrectedImage))=nanmean(CorrectedImage( size(CorrectedImage,1)/2-100:size(CorrectedImage,1)/2,size(CorrectedImage,2)/2-100:size(CorrectedImage,2)/2),'All');


end

