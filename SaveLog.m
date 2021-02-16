function [] = SaveLog(strLogMsg,Parameters)

% Input: file location
% This function will be called from other functions in order to save log
% Output: Save log info

% Author: Monirul,07/22/2020

%% Save info in txt file
fid = fopen(fullfile(Parameters.LogFileLocation, Parameters.LogFilename), 'a');
if fid == -1
    error('Cannot open log file.');
end
fprintf(fid, '%s: %s\n', datestr(now, 0), strLogMsg);
fclose(fid);

end

