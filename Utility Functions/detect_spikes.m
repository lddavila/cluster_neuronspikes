function [spikes_matrix] = detect_spikes(recording_matirx)
%finds potential spikes on individual channels
spikes_matrix = cell(1,size(recording_matirx,2));
for i=1:size(recording_matirx,2)
    [~,pk_locs] = findpeaks(recording_matirx(:,i));
    spikes_matrix{i} = pk_locs; 
end