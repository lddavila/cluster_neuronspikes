function config = spikesort_config()
%SPIKESORT_CONFIG Generates the global config for spikesort
%   config = SPIKESORT_CONFIG()

config = struct();

% Prints extra output
config.DEBUG = true;

% If not empty, puts results in a separate directory instead of the session
% dir.
config.SAVE_DIRECTORY = '';

% Usually keep it false - instead of only spikesorting a single session,
% spikesorts all subfolders too.
config.RECURSIVE_SPIKESORT = false;

% Re-spikesorts even if output already exists - deletes existing output.
config.FORCE_SPIKESORT = true;

% Statistics related config options:
% Only clusters if there exists an existing matlab "gold standard" file.
config.ONLY_MANUAL_CLUSTERED = false;
% Where to look for the existing manually clustered files.
% KYLE FORMAT:
% config.MANUAL_DIR = '../../backup';
% LEDIA FORMAT:
% config.MANUAL_DIR = '..';
% KATY FORMAT:
% config.MANUAL_DIR = '.';
% ALEXANDER FORMAT:
config.MANUAL_DIR = 'clustered';

% Maximum firing rate (in Hz)
config.MAX_FIRING_RATE = 250;
% Maximum number of spikes
config.MAX_NUM_SPIKES = 400000;
% Minimum number of (good) spikes in order to consider spike sorting.
config.MIN_NUMBER_OF_SPIKES = 100;

% Whether to detect and process nearly simultaneous spikes
config.NEAR_SIMULTANEOUS_SPIKE_DETECTION = true;

% In addition to saving timestamps in the output, this will save the
% waveforms too (warning: huge .mat files)
config.SAVE_WAVEFORMS = false;

% Saves the output as an NTT file for viewing in Plexon. Note: if
% SAVE_WAVEFORMS is false, this will only temporarily save waveforms.
config.SAVE_NTT = true;
% Aligns the waveforms if outputting waveforms
config.ALIGN_OUTPUT = true;

% This dynamic field just keeps track of whether to initially save
% waveforms, either permanently or just for generating the NTT file.
config.save_waveforms = config.SAVE_WAVEFORMS || config.SAVE_NTT;

% For interpolation - if you're unsure, do not change
config.NUM_SMOOTH_POINTS = 120;

% *** Spikesort namespace ***
config.spikesort = struct();
config.spikesort.DEBUG = config.DEBUG;

% Whether to do iterations of clustering
config.spikesort.NUM_ITERATIONS = 5;
config.spikesort.DO_BAD_CLUSTER_ROUND = true;

% Which preprocessing filters to use
% Stationarity/Timestamp filter - change depending on your data (keep by
% default)
config.spikesort.USE_TIMESTAMP_FILTER = true;
% SNR filter - change depending on your data (keep by default)
config.spikesort.USE_SNR_FILTER = true;
% Density/Border removal filter - change depending on your data (keep by
% default)
config.spikesort.USE_DENSITY_FILTER = true;

% Cluster/Subcluster parameters:
% Maximum number of clusters to try in FCM
config.spikesort.CLUSTER_NS = 6;
% Maximum number of clusters to try in FCM for each dimension in weight
% calculations.
config.spikesort.WEIGHT_NS = 4;
% Maximum number of clusters to try in FCM in subcluster steps
config.spikesort.SUBCLUSTER_NS = 4;
% Maximum subcluster recursion depth (Inf by default)
config.spikesort.MAX_SUBCLUSTER_DEPTH = 5;

% Flag for whether to trust that neurons far from threshold in the peak
% dimensions will be sorted correctly. The reason for this is because such
% neurons are close to the electrode, so the gaussianity assumption no
% longer necessarily holds.
config.spikesort.TRUST_FAR_NEURONS = false;

% Flag for whether to make cluster Gaussian in PC1 (remove outliers) at the
% very end of the processing
config.spikesort.USE_PC1_CLEANING = false;

config.spikesort.USE_DIMENSION_SELECTION = true;
config.spikesort.DO_REFINEMENT = true;

% Redundant Dimension Selection - Future Work (do not set to true)
config.spikesort.REDUNDANT_DIMENSION_SELECTION = false;

% Internal parameters - DO NOT MODIFY IF NOT ADVANCED USER
params = struct();
params.CL_MIN_CLUSTER_SPIKES = 50; % Minimum number of spikes in a cluster.
params.CL_MPC_THRESHOLD = 0.75; % MPC threshold in dimension evaluation for whether to consider the dimension.

params.CL_HFCM_EPSILON = 1e-5; % Epsilon value for hfcm.
params.CL_HFCM_NUM_ITER = 50; % Number of iterations for each fcm in hfcm.

params.CL_MIN_REDUNDANT_OVERLAP = 0.9; % Minimum amount of overlap to be considered redundant dimensions.

params.OT_WIDTH_SCALING_FACTOR = 0.75; % Amount to scale ksdensity's bandwdith estimation in overlap_test.
params.OT_MIN_SPIKES_LARGE_CLUSTER = 5000; % Minimum number of spikes to be considered a large cluster in overlap test.
params.OT_EPSILON = 1e-3; % Epsilon value for overlap_test.
params.OT_PEAK_RADIUS = 10; % Number of indices around the peak to consider in overlap_test.
params.OT_HIGH_VALLEY_THRESH = 0.5; % Threshold for large valleys in overlap_test.
params.OT_MIN_CLUSTER_PERCENT = 0.25; % Minimum size for a cluster as a percentage of the size of the data in overlap_test.
params.OT_MIN_CLUSTER_SIZE_UPPER_BOUND = 500; % The largest minimum cluster size in overlap_test.
params.OT_MAX_VALLEY_PERCENT = 0.75; % The maximum valley height percentage of the max peak in overlap_test.
params.OT_MAX_SIG_VALLEY_PERCENT = 0.35; % The maximum significant valley height percentage of the max peak in overlap_test.
params.OT_HEIGHT_THRESH = 0.7; % The percentage of the max peak which the min pk has to exceed and the valley has to maintain in overlap_test.

params.RF_CORE_CLUSTER_PERCENT = 0.3; % Percentage of cluster that should be the core cluster.
params.RF_CORE_UPPER_BOUND_PERCENT = 0.6; % The maximum percentage of cluster that the core cluster can be until core exceeds "until bound" below.
params.RF_CORE_UNTIL_BOUND = 200; % The bound until which to consider the upper bound percent in computing the core cluster.
params.RF_GOOD_RATING = 0.05; % Good LRatio for a cluster (well isolated) in refinement.
params.RF_NUM_STD = 1; % Number of stds from mean of mahalanobis distance distribution to keep when cleaning.
params.RF_NUM_STD_PEAKS = 2.5; % Number of stds from mean of mahalanobis distance distribution to keep when cleaning using only peaks.
params.RF_MAHAL_HIST_BOUND_SCALE = 15; % Scaling factor for mahal histogram bound.
params.RF_NOCLEAN_MAHAL_HIST_BOUND_SCALE = 20; % Scaling factor for mahal histogram bound when not cleaning.
params.RF_MAHAL_BINSIZE_SCALE = 0.25; % Scaling factor for mahal histogram bound to determine bin size.

params.RB_TRUST_SMALL_ISOLATED = false; % Trust small isolated clusters when removing bad ones.

params.TF_NUM_THRESH = 3; % Number of thresholds needed to be considered far away.
params.TF_IR_PERCENT = 0.5; % Percent of input range needed to be considered far away.
params.TF_IR_PERCENT_AFTER_REFINE = 0.6; % Percent of input range needed to be considered far away after refinement.

params.GR_SHORT_ISI_LEN = 1e-3; % Maximum length of a short ISI (in seconds)
params.GR_MAX_SHORT_ISI_PERCENT = 0.05; % Maximum percentage of short ISI before it is considered not a cluster.

params.IC_NUM_STD_REMOVE_CLUSTER = 3; % Number of std's from the mean to remove from the peak space when removing a cluster in iterative_clustering.

params.NS_NUM_STD = 2.5; % Number of std from the median of the mahalanobis distance distribution to consider a nearly simultaneous spike as part of the cluster.

params.FC_MIN_NUM_SPIKES = 25; % Minimum number of spikes for a cluster.

params.FO_MIN_OVERLAP_PERCENT = 0.65; % Minimum percentage of the clusters which overlaps in order to merge clusters in fix_cluster_overlaps.

config.spikesort.params = params;

end
