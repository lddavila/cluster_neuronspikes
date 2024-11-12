function[classification] = category_of_cluster(low_cutoff,medium_cutoff,high_cutoff,peaks)
mean_of_cluster = mean(peaks,"all");
classification = 0;
if -1*low_cutoff<mean_of_cluster && mean_of_cluster < low_cutoff
    classification = 1;
elseif (-1*medium_cutoff<mean_of_cluster && mean_of_cluster <-1*low_cutoff )|| (low_cutoff < mean_of_cluster && mean_of_cluster < medium_cutoff )
    classification =2;
elseif (-1*high_cutoff<mean_of_cluster )|| mean_of_cluster > high_cutoff
    classification =3;
end
end