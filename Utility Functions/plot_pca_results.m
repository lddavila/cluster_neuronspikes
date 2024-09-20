function [] = plot_pca_results(peakpcs)

for i=1:size(peakpcs,2)
    for j=i+1:size(peakpcs,2)
        figure;
        scatter(peakpcs(:,i),peakpcs(:,j));
        title("Principal Component Plotting")
        subtitle(string(i) + " Vs " + string(j));
        xlabel("PC channel "+string(i))
        ylabel("PC Channel " + string(j));
    end
end
end