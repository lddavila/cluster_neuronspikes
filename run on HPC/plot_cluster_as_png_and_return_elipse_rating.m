function [eccentricity,circularity] = plot_cluster_as_png_and_return_elipse_rating(compare_wire_peaks,compare_wire_2_peaks)

%it seems as though circularity below 1.7 can indicate something bad
eccentricity = NaN;
circularity = NaN;

k = boundary(compare_wire_peaks.',compare_wire_2_peaks.',1);
% hold on;
f =figure('Position',[2027         394         560         420]);
fill(compare_wire_peaks(k),compare_wire_2_peaks(k),'k');

axis off;
saveas(f,"tempcluster.png");
the_cluster_image = imread("tempcluster.png");
grayImage = rgb2gray(the_cluster_image);
binary_image = imbinarize(grayImage);

disp("num pixels:"+string(size(binary_image)));
figure('Position',[3077         367         560         420]);


scatter(compare_wire_peaks,compare_wire_2_peaks,'black','Marker','o','MarkerFaceColor',"black",'SizeData',20)
hold on;


figure('Position',[ 2583         488         560         420]);
h = histogram2(compare_wire_peaks,compare_wire_2_peaks,'Normalization','probability','NumBins',[26,26]);
bin_counts = h.Values;

left_half = bin_counts(:,1:13);
right_half = bin_counts(:,14:end);
upper_half = bin_counts(1:13,:);
lower_half = bin_counts(14:end,:);

left_to_right_symmetry = sum(left_half - right_half,"all");

diagonal_symmetry = tril(bin_counts) -  triu(bin_counts);
up_down_symmetry = upper_half - lower_half;


delete('tempcluster.png')
% get_grades_for_nth_pass_of_clustering(dir_with_timestamps_and_rvals,dir_with_output,list_of_tetrodes,dir_to_save_grades_to,config,varying_z_scores(2),debug,relevant_grades,name_of_grades)


close all;
end