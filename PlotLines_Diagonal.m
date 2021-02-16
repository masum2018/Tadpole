function [] = PlotLines_Diagonal(Red2D,Green2D,Blue2D)


   [colfrom, rowfrom, Diag_Red] = improfile(Red2D, [1, size(Red2D, 2)], [1, size(Red2D, 1)]);  
   [colfrom, rowfrom, Diag_Green] = improfile(Green2D, [1, size(Green2D, 2)], [1, size(Green2D, 1)]);  
   [colfrom, rowfrom, Diag_Blue] = improfile(Blue2D, [1, size(Blue2D, 2)], [1, size(Blue2D, 1)]);

figure,
    subplot(2,2,1)
    plot( Diag_Red,'r');hold on;
    plot(Diag_Green,'g');hold on;
    plot(Diag_Blue,'b');hold off;
    legend("Red","Green","Blue");title("Diagonal(Top left to Bottom right)");
    xlabel("pixels"); ylabel("#counts");
    
    Avg_red=mean(Diag_Red);
    Avg_green=mean(Diag_Green);
    Avg_blue=mean(Diag_Blue);
    subplot(2,2,2)
    plot( Diag_Red,'r');hold on;
    plot(Avg_red- Avg_green+ Diag_Green,'g');hold on;
    plot(Avg_red- Avg_blue+Diag_Blue,'b');hold off;
    legend("Red","Green","Blue");title("Diagonal(Added offset along Y axis))")
    xlabel("pixels"); ylabel("#counts");
    
    Red2D=fliplr(Red2D);Blue2D=fliplr(Blue2D);Green2D=fliplr(Green2D);
   [colfrom, rowfrom, Diag_Red] = improfile(Red2D, [1, size(Red2D, 2)], [1, size(Red2D, 1)]);  
   [colfrom, rowfrom, Diag_Green] = improfile(Green2D, [1, size(Green2D, 2)], [1, size(Green2D, 1)]);  
   [colfrom, rowfrom, Diag_Blue] = improfile(Blue2D, [1, size(Blue2D, 2)], [1, size(Blue2D, 1)]);
    
    subplot(2,2,3)
    plot( Diag_Red,'r');hold on;
    plot(Diag_Green,'g');hold on;
    plot(Diag_Blue,'b');hold off;
    legend("Red","Green","Blue");title("Diagonal(Top right to Bottom left)");
    xlabel("pixels"); ylabel("#counts");
    
    Avg_red=mean(Diag_Red);
    Avg_green=mean(Diag_Green);
    Avg_blue=mean(Diag_Blue);
    subplot(2,2,4)
    plot( Diag_Red,'r');hold on;
    plot(Avg_red- Avg_green+ Diag_Green,'g');hold on;
    plot(Avg_red- Avg_blue+Diag_Blue,'b');hold off;
    legend("Red","Green","Blue");title("Diagonal(Added offset along Y axis))")
    xlabel("pixels"); ylabel("#counts");
end

