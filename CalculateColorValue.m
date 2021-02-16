function [xm,ym,Ym] = CalculateColorValue(CalMatrix,Rs,Gs,Bs)

% Input: Calibration matrix and RGB value
% Output=1931 x, 1931 y and Y
% Author:Monirul,07/17/2020



Xm=CalMatrix(1)*Rs +CalMatrix(4)*Gs+CalMatrix(7)*Bs;
Ym=CalMatrix(2)*Rs +CalMatrix(5)*Gs+CalMatrix(8)*Bs;
Zm=CalMatrix(3)*Rs +CalMatrix(6)*Gs+CalMatrix(9)*Bs;
xm=Xm/(Xm+Ym+Zm);
ym=Ym/(Xm+Ym+Zm);


% Xm=CalMatrix(1,1)*Rs +CalMatrix(2,1)*Gs+CalMatrix(3,1)*Bs;
% Ym=CalMatrix(1,2)*Rs +CalMatrix(2,2)*Gs+CalMatrix(3,2)*Bs;
% Zm=CalMatrix(1,3)*Rs +CalMatrix(2,3)*Gs+CalMatrix(3,3)*Bs;

end

