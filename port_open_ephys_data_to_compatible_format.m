%% Add the Open Ephys Reading tools to the path 
%this directory is available here at the following github link
%https://github.com/open-ephys/open-ephys-matlab-tools.git
dir_with_open_ephys_reader_functions = "D:\open-ephys-matlab-tools"; %change this to match the local path
clustering_dir = cd("D:\open-ephys-matlab-tools");
genpath(".");
cd(clustering_dir);
%% Load the Data
dir_with_continuous_recording_data = "D:\Ephys Data\Electrophysiology Data (OpenEphys)\Pine\2024-11-27_12-58-10__Pine\Record Node 103\experiment1\recording1\continuous";
session = Session(directory);
disp(size(session.))