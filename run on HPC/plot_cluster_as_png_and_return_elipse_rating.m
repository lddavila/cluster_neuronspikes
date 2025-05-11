function [eccentricity,circularity,symmetry_score,circular_symmetry] = plot_cluster_as_png_and_return_elipse_rating(compare_wire_peaks,compare_wire_2_peaks,dir_of_template_figures,channels)

%it seems as though circularity below 1.7 can indicate something bad
eccentricity = NaN;
circularity = NaN;
symmetry_score = NaN;
circular_symmetry = NaN;
k = boundary(compare_wire_peaks.',compare_wire_2_peaks.',1);
% hold on;
f =figure('Position',[2027         394         560         420]);
fill(compare_wire_peaks(k),compare_wire_2_peaks(k),'k');

axis off;
randomized_temp_file_number_sequence = randi(1e9, 1, 10);
file_save_name = strjoin(string(randomized_temp_file_number_sequence))+".png"; %this file will be deleted
% so we just randomly generate 10 numbers between 1 and billion and use this as a file name to avoid a multi threaded process accidentally
%reading the same file
saveas(f,file_save_name+".png");
close all;
the_cluster_image = imread("tempcluster"+strjoin(string(channels))+".png");
grayImage = rgb2gray(the_cluster_image);
binary_image = imbinarize(grayImage);
% figure;
% imshow(binary_image);

% disp("num pixels for actual filled cluster plot:"+string(size(binary_image)));
%order will always be horizontal elipse, left to right negative elipsde, left to right positive elipse, vertical elipse, circle
elipse_like_score = nan(1,4);
array_of_names = ["horizonal","left to right negative","left_to_right_positive","vertical","circle"];
for i=1:size(dir_of_template_figures,1)
    template_image = imread(dir_of_template_figures(i));
    gray_template_image = rgb2gray(template_image);
    template_binary_image = imbinarize(gray_template_image);
    % disp("Size of the cluster binary image")
    % disp(size(binary_image))
    % disp("Size of the template image")
    % disp(size(template_binary_image))
    pixels_in_common = sum(~binary_image & ~template_binary_image,"all");
    pixels_in_template_image = sum(~template_binary_image,"all");
    number_of_pixels_in_cluster_binary_image = sum(~binary_image,"all");
    pixels_in_cluster_but_not_template =number_of_pixels_in_cluster_binary_image - pixels_in_common;
    if i<5
        elipse_like_score(i) =( pixels_in_common - pixels_in_cluster_but_not_template ) / pixels_in_template_image;
    elseif i==5
        circularity =( pixels_in_common - pixels_in_cluster_but_not_template ) / pixels_in_template_image;
    end
    % figure;
    % imshow(template_binary_image);
    % disp("num pixels for template shape plot:"+string(size(template_binary_image)));
end
% disp([[elipse_like_score,circularity].',array_of_names.'])
[eccentricity,index] = max(elipse_like_score);
% disp("Best Elipse "+array_of_names(index)+" Score:"+string(eccentricity))
% figure('Position',[3077         367         560         420]);


% scatter(compare_wire_peaks,compare_wire_2_peaks,'black','Marker','o','MarkerFaceColor',"black",'SizeData',20)
% hold on;


% figure('Position',[ 2583         488         560         420]);
% h = histogram2(compare_wire_peaks,compare_wire_2_peaks,'Normalization','probability','NumBins',[26,26]);
% bin_counts = h.Values;

% if index==1
%     left_half = bin_counts(:,1:13);
%     right_half = bin_counts(:,14:end);
%     symmetry_score = left_half - right_half;
% elseif index==2
%     upper_triangular_densities = triu(bin_counts);
%     lower_triangular_densities = tril(bin_counts);
%     symmetry_score = sum(upper_triangular_densities - lower_triangular_densities,"all");
% elseif index==3
% 
% elseif index==4
%     upper_half = bin_counts(1:13,:);
%     lower_half = bin_counts(14:end,:);
%     symmetry_score = upper_half - lower_half;
% end
% 
% upper_half = bin_counts(1:13,:);
% lower_half = bin_counts(14:end,:);
% circular_symmetry = upper_half - lower_half;

delete(file_save_name+".png")
% get_grades_for_nth_pass_of_clustering(dir_with_timestamps_and_rvals,dir_with_output,list_of_tetrodes,dir_to_save_grades_to,config,varying_z_scores(2),debug,relevant_grades,name_of_grades)


close all;
end