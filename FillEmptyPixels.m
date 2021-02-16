function [CorrectedImage] = FillEmptyPixels(Image)

%  Input: Image with vacant pixels
%  Output:Image with filled pixels
%  If there is any empty space, fill the the gap from sourronding pixels
%  Author: Monirul, 07/16/2020

%% Apply the logic for inner part first excluding edge pixels
CorrectedImage=Image;

for(i=2:(size(Image,1)-1))
    for(j=2:(size(Image,2)-1))
        
        if(Image(i,j)==0)
            
            % surrounding 4 pixels are non-zero
            if( ( Image(i,j+1)*Image(i+1,j)*Image(i-1,j-1)*Image(i,j-1))~=0 )
                I= (Image(i,j+1)+Image(i+1,j)+Image(i-1,j-1)+Image(i,j-1))/4;
            end
            % only 1 pixel is zero
            if( ( Image(i,j+1)==0) && ((Image(i+1,j)*Image(i-1,j-1)*Image(i,j-1))~=0) )
                I= (Image(i+1,j)+Image(i-1,j-1)+Image(i,j-1))/3;
            end
            if( ( Image(i+1,j)==0) && ((Image(i,j+1)*Image(i-1,j-1)*Image(i,j-1))~=0) )
                I= (Image(i,j+1)+Image(i-1,j-1)+Image(i,j-1))/3;
            end
            
            if( ( Image(i-1,j-1)==0) && ((Image(i,j+1)*Image(i+1,j)*Image(i,j-1))~=0) )
                I= (Image(i,j+1)+Image(i+1,j)+Image(i,j-1))/3;
            end
            
            if( ( Image(i,j-1)==0) && ((Image(i,j+1)*Image(i+1,j)*Image(i-1,j-1))~=0) )
                I= (Image(i,j+1)+Image(i+1,j)+Image(i-1,j-1))/3;
            end
            
            % 2 pixels are 0
            if( ( Image(i,j-1)*Image(i+1,j)==0) && (Image(i,j+1)*Image(i-1,j-1))~=0)
                I= (Image(i,j+1)+Image(i-1,j-1))/2;
            end
            if( ( Image(i,j+1)*Image(i+1,j)==0) && (Image(i,j-1)*Image(i-1,j-1))~=0)
                I= (Image(i,j-1)+Image(i-1,j-1))/2;
            end
            if( ( Image(i,j+1)*Image(i-1,j-1)==0) && (Image(i,j-1)*Image(i+1,j))~=0)
                I= (Image(i,j-1)+Image(i+1,j))/2;
            end
            
            %3 pixels are 0
            
            if( ( Image(i,j-1)*Image(i+1,j)*Image(i,j+1)==0) && Image(i-1,j-1)~=0)
                I= Image(i-1,j-1);
            end
            
            if( ( Image(i+1,j)*Image(i,j+1)*Image(i-1,j-1)==0) && Image(i,j-1)~=0)
                I= Image(i,j-1);
            end
            if( ( Image(i,j+1)*Image(i-1,j-1)*Image(i,j-1)==0) && Image(i+1,j)~=0)
                I= Image(i+1,j);
            end
            
            if( ( Image(i-1,j-1)*Image(i,j-1)*Image(i+1,j)==0) && Image(i,j+1)~=0)
                I= Image(i,j+1);
            end
            
            %4 pixels are 0
            %TODO- look for the diagonal nearest pixel
            
            
            CorrectedImage(i,j)  =I;
            
        end % if(Image(i,j)==0)
        
        
    end % for(j=2:(size(Image,2)-1))
end %for(i=2:(size(Image,1)-1))

%% Fill the empty space for the edge pixels of the image

% top row (row number 1)
i=1;
for(j=2:(size(Image,2)-1))
    
    if(Image(i,j)==0)       
        I= (Image(i,j+1)+Image(i+1,j)+Image(i,j-1))/3;        
        CorrectedImage(i,j)  =I;
        
    end % if(Image(i,j)==0)
end

% special treatment:top left corner
i=1;j=1;
if(Image(i,j)==0)    
    CorrectedImage(i,j)= (Image(i,j+1)+Image(i+1,j)+Image(i+1,j+1))/3;
end
% special treatment:top right corner
i=1;j=size(Image,2);
if(Image(i,j)==0)    
    CorrectedImage(i,j)= (Image(i,j-1)+Image(i+1,j)+Image(i+1,j-1))/3;
end


% bottom row (row number: size(Image,1))
i=size(Image,1);
for(j=2:(size(Image,2)-1))
    
    if(Image(i,j)==0)        
        I= (Image(i,j+1)+Image(i-1,j)+Image(i,j-1))/3;        
        CorrectedImage(i,j)  =I;       
    end % if(Image(i,j)==0)
end

% special treatment:Bottom left corner
i=size(Image,1);j=1;
if(Image(i,j)==0)
    
    CorrectedImage(i,j)= (Image(i,j+1)+Image(i-1,j)+Image(i-1,j+1))/3;
end
% special treatment:Bottom right corner
i=size(Image,1);j=size(Image,2);
if(Image(i,j)==0)
    
    CorrectedImage(i,j)= (Image(i,j-1)+Image(i-1,j)+Image(i-1,j-1))/3;
end


%Column number 1
j=1;
for(i=2:(size(Image,1)-1))
    
    if(Image(i,j)==0)        
        I= (Image(i,j+1)+Image(i-1,j)+Image(i+1,j))/3;        
        CorrectedImage(i,j)  =I;       
    end % if(Image(i,j)==0)
end

%Column number :size(Image,2)
j=size(Image,2);
for(i=2:(size(Image,1)-1))
    
    if(Image(i,j)==0)        
        I= (Image(i,j-1)+Image(i-1,j)+Image(i+1,j))/3;        
        CorrectedImage(i,j)  =I;       
    end % if(Image(i,j)==0)
end

end

