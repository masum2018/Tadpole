function [] = SaveResults(Parameters)

% Input: Result(x,y,Y) and parameters
%Output: Saved data
%Author:Monirul,07/21/2020

%% save results and parametrs
FileName='_Results_';
CurrentTime=datetime('now','Format','yyyy-MM-dd''_''HHmmss');
ResultFileName = sprintf('%s%s%s%s',Parameters.OutputFileLocation,Parameters.SN,FileName,CurrentTime,'.mat');
save(ResultFileName,'-struct','Parameters');

end

