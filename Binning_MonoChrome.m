function [OutputImage] = Binning_MonoChrome(Image,ROIr,ROIc)
%Binning of image
%Input: Image
%Output: Binning image
%Author: Monirul, 07/15/2020

nRow=size(Image,1);
nColumn=size(Image,2);

nNewRow=floor(nRow/ROIr);
nNewColumn=floor(nColumn/ROIc);

OutputImage=zeros(nNewRow,nNewColumn);

nCountRow=1;
for(i=1:ROIr:(nNewRow*ROIr)-1)
    nCountColumn=1;
    for(j=1:ROIc:(nNewColumn*ROIc)-1)
        
        OutputImage(nCountRow,nCountColumn)=mean2( Image(i:i+ROIr,j:j+ROIc));
        
        nCountColumn=nCountColumn+1;
    end
    nCountRow=nCountRow+1;
    
end
end