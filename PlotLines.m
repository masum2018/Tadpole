function [] = PlotLines(Red,Green,Blue,TitleOfTheImage)
%Plotting of line
%Author:Monirul,07/15/2020
s = strcat(TitleOfTheImage,': Horizontal line');

 figure,
    subplot(2,2,1)
    plot(Red( round (size(Red,1)/2),:),'r');hold on;
    plot(Green( round (size(Red,1)/2),:),'g');hold on;
    plot(Blue( round (size(Red,1)/2),:),'b');hold off;
    legend("Red","Green","Blue");title(s);
    xlabel("pixels"); ylabel("#counts");
    
    Avg_red=mean(Red( round (size(Red,1)/2),:));
    Avg_green=mean(Green( round (size(Red,1)/2),:));
    Avg_blue=mean(Blue( round (size(Red,1)/2),:));
    
    s = strcat(TitleOfTheImage,': Horizontal line(Added Offset)');
    subplot(2,2,2)
    plot(Red( round (size(Red,1)/2),:),'r');hold on;
    plot(Avg_red- Avg_green+ Green( round (size(Red,1)/2),:),'g');hold on;
    plot(Avg_red- Avg_blue+Blue( round (size(Red,1)/2),:),'b');hold off;
    legend("Red","Green","Blue");title(s)
    xlabel("pixels"); ylabel("#counts");
    
     s = strcat(TitleOfTheImage,': Vertical line');
    subplot(2,2,3)
    plot(Red(:, round (size(Red,2)/2)),'r');hold on;
    plot(Green(:, round (size(Red,2)/2)),'g');hold on;
    plot(Blue(:, round (size(Red,2)/2)),'b');hold off;
    legend("Red","Green","Blue");title(s);
    xlabel("pixels"); ylabel("#counts");
    
    Avg_red=mean(Red( :,round (size(Red,2)/2)));
    Avg_green=mean(Green(:, round (size(Red,2)/2)));
    Avg_blue=mean(Blue(:, round (size(Red,2)/2)));
    
    s = strcat(TitleOfTheImage,': Vertical line(Added Offset)');
    subplot(2,2,4)
    plot(Red(:, round (size(Red,2)/2)),'r');hold on;
    plot(Avg_red- Avg_green+ Green( :,round (size(Red,2)/2)),'g');hold on;
    plot(Avg_red- Avg_blue+Blue( :,round (size(Red,2)/2)),'b');hold off;
    legend("Red","Green","Blue");title(s)
    xlabel("pixels"); ylabel("#counts");
end

