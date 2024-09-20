function wire_filter = find_live_wires(raw)
%FIND_LIVE_WIRES Creates a filter to ignore dead wires.
    wire_filter = false(1, size(raw, 1));
    for wire = 1:size(raw, 1)
        if sum(any(squeeze(raw(wire, :, :)), 2)) > 0.5 * size(raw, 2)
            % The number of nonzero spikes in this wire is more than 50% of
            % the number of spikes in the recording.
            wire_filter(wire) = true;
        end
    end
end